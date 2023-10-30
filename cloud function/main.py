"""main.py"""
import time
from datetime import datetime
import json
import redis
from domaintools.exceptions import (
    NotAuthorizedException,
    ServiceUnavailableException,
)
from google.cloud import storage
import domaintool_client
import fetch_logs
from common import ingest
from common import utils
from common import env_constants

# Environment variable constants
ENV_DOMAINTOOLS_API_USERNAME = "DOMAINTOOLS_API_USERNAME"
ENV_DOMAINTOOLS_API_KEY = "DOMAINTOOLS_API_KEY"
ENV_CHRONICLE_LOG_TYPE = "CHRONICLE_LOG_TYPE"
ENV_LOG_TYPE_FILE_PATH = "LOG_TYPE_FILE_PATH"
ENV_PROVISIONAL_TTL = "PROVISIONAL_TTL"
ENV_NON_PROVISIONAL_TTL = "NON_PROVISIONAL_TTL"
ENV_ALLOW_LIST = "ALLOW_LIST"
ENV_MONITORING_LIST = "MONITORING_LIST"
ENV_MONITORING_TAGS = "MONITORING_TAGS"
ENV_BULK_ENRICHMENT = "BULK_ENRICHMENT"

client = redis.StrictRedis(
    host=utils.get_env_var(env_constants.ENV_REDIS_HOST),
    port=utils.get_env_var(env_constants.ENV_REDIS_PORT, required=False, default=6379),
    decode_responses=True,
)


def get_and_ingest_logs(
    chronicle_label: str,
    domain_list: list[str],
    function_mode: str,
    reference_list_name: str = "",
) -> None:
    """Fetch logs from the DomainTools platform and ingest it to Chronicle.

    Args:
      chronicle_label (str): Chronicle label in which data will be ingested.

    Raises:
      RuntimeError: When logs could not be pushed to the Chronicle.
    """
    domaintool_user = utils.get_env_var(ENV_DOMAINTOOLS_API_USERNAME, is_secret=True)
    domaintool_password = utils.get_env_var(ENV_DOMAINTOOLS_API_KEY, is_secret=True)

    try:
        provisional_ttl = utils.get_env_var(
            ENV_PROVISIONAL_TTL, required=False, default=1
        )
        provisional_ttl = int(provisional_ttl)
        non_provisional_ttl = utils.get_env_var(
            ENV_NON_PROVISIONAL_TTL, required=False, default=30
        )
        non_provisional_ttl = int(non_provisional_ttl)
    except ValueError as e:
        print(
            "Error occurred while storing domains in the memory store. An invalid value is provided for the TTL in the environment variable."
        )
        raise e

    domain_tool_client_object = domaintool_client.DomainToolClient(
        domaintool_user, domaintool_password
    )
    if function_mode == "scheduler":
        # skip domains which are present in allow_list
        allow_list_name = utils.get_env_var(ENV_ALLOW_LIST, required=False, default="")
        if allow_list_name != "":
            try:
                allow_list_domains = ingest.get_reference_list(allow_list_name)
            except Exception as error:
                print("Unable to fetch reference list. Error:", error)
                allow_list_domains = []
        else:
            allow_list_domains = []

        print("Checking domains in the memorystore.")
        temp_domains_list = domain_list.copy()
        # skip domains which is already present in redis
        for domain in domain_list:
            data = client.hget(domain, "value")
            if data or (domain in allow_list_domains):
                temp_domains_list.remove(domain)
        domain_list = temp_domains_list
        print("Completed checking domains in the memorystore.")

    print("Enriching domains from the DomainTools.")
    logs = []
    all_responses = []

    if len(domain_list) > 100:
        start_len = 0
        end_len = 100
        queue_len = len(domain_list)
        while queue_len > 0:
            queued_domains_part = domain_list[start_len:end_len]
            if len(queued_domains_part) > 0:
                try_count = 0
                max_retries = 2
                while try_count < max_retries:
                    try:
                        response = domain_tool_client_object.enrich(queued_domains_part)
                        break
                    except NotAuthorizedException as e:
                        raise e
                    except ServiceUnavailableException as e:
                        print(f"Attempt {try_count + 1} failed: {e}")
                        try_count += 1
                        if try_count < max_retries:
                            print("Retrying in 30 seconds...")
                            time.sleep(30)
                        else:
                            print(
                                "API call to DomainTools failed. Rate limit exceeded."
                            )
                            raise e
                    except Exception as e:
                        raise e
                all_responses.append(response)

            queue_len -= 100
            start_len = end_len

            if queue_len > 100:
                end_len = start_len + 100
            else:
                end_len = start_len + queue_len
    else:
        if len(domain_list) > 0:
            try_count = 0
            max_retries = 2
            while try_count < max_retries:
                try:
                    response = domain_tool_client_object.enrich(domain_list)
                    break
                except NotAuthorizedException as e:
                    raise e
                except ServiceUnavailableException as e:
                    print(f"Attempt {try_count + 1} failed: {e}")
                    try_count += 1
                    if try_count < max_retries:
                        print("Retrying in 30 seconds...")
                        time.sleep(30)
                    else:
                        print("API call to DomainTools failed. Rate limit exceeded.")
                        raise e
                except Exception as e:
                    raise e
            all_responses.append(response)
    print("Completed enriching domains from the DomainTools.")

    if function_mode == "monitoring_domain":
        timestamp_monitoring_list = datetime.now().strftime("%Y-%m-%dT%H:%M:%S.%fZ")

    for response in all_responses:
        for val in response.get("results"):
            logs.append(val)
            if function_mode == "bulk_enrichment":
                continue
            if function_mode == "monitoring_domain":
                val["monitor_domain"] = True
                val["timestamp"] = timestamp_monitoring_list
                val["monitoring_domain_list_name"] = reference_list_name
            principal_hostname = val.get("domain")
            components_array = val.get("domain_risk", {}).get("components", [])
            evidence = ""
            if len(components_array) > 0:
                for val in components_array:
                    if "provisional" in val.get("evidence", []):
                        evidence = "provisional"
                        break
            data_updated_time = val.get("data_updated_timestamp")
            current_timestamp = datetime.now().strftime("%Y-%m-%dT%H:%M:%S.%f")
            # Prepare a dictionary to store in the Redis Hash
            data_to_cache = {
                "value": principal_hostname,
                "created_timestamp": str(current_timestamp),
                "data_updated_time": str(data_updated_time),
            }

            # Use the Redis HMSET command to set the dictionary in the Redis Hash
            client.hmset(principal_hostname, data_to_cache)
            if evidence == "provisional":
                ttl = int(provisional_ttl) * 86400  # no of seconds in a day = 86400
            else:
                ttl = int(non_provisional_ttl) * 86400

            # Set the TTL for the key
            client.expire(principal_hostname, ttl)
    print("Completed adding domains in the memorystore.")

    print(f"Total {len(logs)} number of data fetched from DomainToools.")

    if logs:
        try:
            print("Ingesting enriched domain logs into Chronicle.")
            ingest.ingest(logs, chronicle_label)
            print("Completed ingesting enriched domain logs into Chronicle.")
        except Exception as error:
            raise RuntimeError(f"Unable to push data to Chronicle. {error}") from error


def generate_dummy_events(domains_tags, param_type, reference_list_name):
    """Generte dummy events for allow list and monitor domains

    Args:
        domains_tags (list): List of domains or tags
        param_type (str): would be allow_list or monitoring_tags
        reference_list_name (str): reference list of allow list or monitoring tags

    Returns:
        list: List of dummy events
    """
    dummy_event_list = []
    current_timestamp = datetime.now().strftime("%Y-%m-%dT%H:%M:%S.%fZ")
    for field in domains_tags:
        temp_event = {"timestamp": current_timestamp}
        if param_type == "allow_list":
            temp_event["domain"] = field
            temp_event["allow_domain"] = True
            temp_event["allow_list_name"] = reference_list_name
        elif param_type == "monitoring_tags":
            temp_event["tag_name"] = field
            temp_event["monitor_tag"] = True
            temp_event["monitoring_tag_list_name"] = reference_list_name
        dummy_event_list.append(temp_event)
    return dummy_event_list


def entry(
    allow_list=False,
    monitoring_list=False,
    monitoring_tags=False,
    bulk_enrichment=False,
    mode="scheduler",
):
    """_summary_

    Args:
        allow_list (bool, optional): Value of Allow List Parameter. Defaults to False.
        monitoring_list (bool, optional): Value of Monitoring List Parameter. Defaults to False.
        monitoring_tags (bool, optional): Value of Monitoring Tags Parameter. Defaults to False.
        bulk_enrichment (bool, optional): Value of Bulk Enrichment Parameter. Defaults to False.
        mode (str, optional): Value of function mode. Defaults to "scheduler".
    """
    chronicle_label = utils.get_env_var(ENV_CHRONICLE_LOG_TYPE)
    if mode == "scheduler":
        print("Fetching logs from Chronicle.")
        gcp_bucket_name = utils.get_env_var(env_constants.ENV_GCP_BUCKET_NAME)
        storage_client = storage.Client()
        current_bucket = storage_client.get_bucket(gcp_bucket_name)
        try:
            blob = current_bucket.blob(
                utils.get_env_var(
                    ENV_LOG_TYPE_FILE_PATH, required=False, default="temp"
                )
            )
            if blob.exists():
                log_types = blob.download_as_text()
            else:
                log_types = ""
                print(
                    "Log type file is not provided in the bucket. Considering all log type to fetch logs from Chronicle."
                )
        except Exception as e:
            print("An error occurred:", e)
            return "Ingestion not Completed"
        object_fetch_log = fetch_logs.FetchLogs(log_types)
        try:
            (
                domain_list,
                checkpoint_blob,
                new_checkpoint,
            ) = object_fetch_log.fetch_data_and_checkpoint()
        except ValueError:
            return "Ingestion not Completed"
        except Exception as err:
            print("Error in fetching log: ", err)
            return "Ingestion not Completed"
        print("Completed fetching logs from Chronicle.")

        if not domain_list:
            print("No domains found in the fetched logs from Chronicle.")
            with checkpoint_blob.open(mode="w", encoding="utf-8") as json_file:
                json_file.write(json.dumps(new_checkpoint))
            print("The checkpoint is updated to {}.".format(new_checkpoint.get("time")))
            return "Ingestion not Completed"
        try:
            get_and_ingest_logs(chronicle_label, domain_list, "scheduler")
        except Exception:
            print("Error: ", e)
            return "Ingestion not Completed"
        with checkpoint_blob.open(mode="w", encoding="utf-8") as json_file:
            json_file.write(json.dumps(new_checkpoint))
        print("The checkpoint is updated to {}.".format(new_checkpoint.get("time")))
        return "Ingestion Completed"
    else:
        if monitoring_list:
            monitoring_list_name = utils.get_env_var(
                ENV_MONITORING_LIST, required=False, default=""
            )
            if monitoring_list_name != "":
                try:
                    monitoring_list_domains = ingest.get_reference_list(
                        monitoring_list_name
                    )
                    if not monitoring_list_domains:
                        print("No domain found in the {}".format(monitoring_list_name))
                    else:
                        get_and_ingest_logs(
                            chronicle_label,
                            monitoring_list_domains,
                            "monitoring_domain",
                            monitoring_list_name,
                        )
                except Exception as error:
                    print("Unable to fetch reference list. Error:", error)
            else:
                print(
                    "Monitoring List reference list name is not provided in environment variable."
                )
        if bulk_enrichment:
            bulk_enrichment_name = utils.get_env_var(
                ENV_BULK_ENRICHMENT, required=False, default=""
            )
            if bulk_enrichment_name != "":
                try:
                    bulk_enrichment_domains = ingest.get_reference_list(
                        bulk_enrichment_name
                    )
                    if not bulk_enrichment_domains:
                        print("No domain found in the {}".format(bulk_enrichment_name))
                    else:
                        get_and_ingest_logs(
                            chronicle_label, bulk_enrichment_domains, "bulk_enrichment"
                        )
                except Exception as error:
                    print("Unable to fetch reference list. Error:", error)
            else:
                print(
                    "Bulk Enrichment reference list name is not provided in environment variable."
                )
        if allow_list:
            allow_list_name = utils.get_env_var(
                ENV_ALLOW_LIST, required=False, default=""
            )
            if allow_list_name != "":
                try:
                    allow_list_domains = ingest.get_reference_list(allow_list_name)
                    if not allow_list_domains:
                        print("No domain found in the {}".format(allow_list_name))
                        allow_list_dummy_events = []
                    else:
                        allow_list_dummy_events = generate_dummy_events(
                            allow_list_domains, "allow_list", allow_list_name
                        )
                    if allow_list_dummy_events:
                        try:
                            print("Start ingesting allow list dummy log into Chronicle.")
                            ingest.ingest(allow_list_dummy_events, chronicle_label)
                            print("End ingesting allow list dummy log into Chronicle.")
                        except Exception as error:
                            print("Unable to push data to Chronicle. Error:", error)
                            return "Ingestion not completed"
                except Exception as error:
                    print("Unable to fetch reference list. Error:", error)
            else:
                print("Allow List reference list name is not provided in environment variable.")
        if monitoring_tags:
            monitoring_tags_name = utils.get_env_var(
                ENV_MONITORING_TAGS, required=False, default=""
            )
            if monitoring_tags_name != "":
                try:
                    monitoring_tags_list = ingest.get_reference_list(
                        monitoring_tags_name
                    )
                    if not monitoring_tags_list:
                        print("No domain found in the {}.".format(monitoring_tags_name))
                        monitoring_tags_dummy_events = []
                    else:
                        monitoring_tags_dummy_events = generate_dummy_events(
                            monitoring_tags_list, "monitoring_tags", monitoring_tags_name
                        )
                    if monitoring_tags_dummy_events:
                        try:
                            print(
                                "Start ingesting monitoring tags dummy log into Chronicle."
                            )
                            ingest.ingest(monitoring_tags_dummy_events, chronicle_label)
                            print(
                                "End ingesting monitoring tags dummy log into Chronicle."
                            )
                        except Exception as error:
                            print("Unable to push data to Chronicle. Error:", error)
                            return "Ingestion not completed"
                except Exception as error:
                    print("Unable to fetch reference list. Error:", error)
            else:
                print(
                    "Monitoring Tag reference list name is not provided in environment variable."
                )
        return "Ingestion Completed"


def check_valid_parameter(parameter_name, parameter):
    """Check for valid parameter

    Args:
        parameter_name (str): parameter name to check
        parameter (str): parameter value

    Returns:
        bool: return True or False
    """
    if str(parameter) == "true" or str(parameter) == "True":
        return True
    elif str(parameter) == "False" or str(parameter) == "false":
        return False
    else:
        print(f"Please provide boolean value for {parameter_name} parameter.")
        return False


def main(request) -> str:
    """Entry point for the script."""
    if request.data:
        try:
            request_body = json.loads(request.data)
        except json.decoder.JSONDecodeError:
            print("Please pass a valid json as parameter.")
            return "Ingestion not completed due to error in parameter.\n"
        print("Running in Adhoc mode.")
        allow_list = False
        monitoring_list = False
        monitoring_tags = False
        bulk_enrichment = False
        for key in request_body.keys():
            if key == "allow_list":
                allow_list = request_body["allow_list"]
                allow_list = check_valid_parameter("allow_list", allow_list)
            elif key == "monitoring_list":
                monitoring_list = request_body["monitoring_list"]
                monitoring_list = check_valid_parameter(
                    "monitoring_list", monitoring_list
                )
            elif key == "monitoring_tags":
                monitoring_tags = request_body["monitoring_tags"]
                monitoring_tags = check_valid_parameter(
                    "monitoring_tags", monitoring_tags
                )
            elif key == "bulk_enrichment":
                bulk_enrichment = request_body["bulk_enrichment"]
                bulk_enrichment = check_valid_parameter(
                    "bulk_enrichment", bulk_enrichment
                )
            else:
                print(f"Provided invalid key: {key}.")
        if allow_list or monitoring_list or monitoring_tags or bulk_enrichment:
            return entry(
                allow_list,
                monitoring_list,
                monitoring_tags,
                bulk_enrichment,
                mode="adhoc",
            )
        print("Provide valid parameters for adhoc.")
        return "Provide valid parameters for adhoc.\n"
    print("Running in Scheduler mode.")
    return entry()
