"""main.py"""
import time
from datetime import datetime
import json
import redis
import domaintool_client
from google.cloud import storage
import fetch_logs
from common import ingest
from common import utils
from common import env_constants
from domaintools.exceptions import (
    NotAuthorizedException,
    ServiceUnavailableException,
)

# Environment variable constants
ENV_DOMAINTOOLS_API_USERNAME = "DOMAINTOOLS_API_USERNAME"
ENV_DOMAINTOOLS_API_KEY = "DOMAINTOOLS_API_KEY"
ENV_CHRONICLE_DATA_TYPE = "CHRONICLE_DATA_TYPE"
ENV_LOG_TYPE_FILE_PATH = "LOG_TYPE_FILE_PATH"
ENV_PROVISIONAL_TTL = "PROVISIONAL_TTL"
ENV_NON_PROVISIONAL_TTL = "NON_PROVISIONAL_TTL"
ENV_ALLOW_LIST = "ALLOW_LIST"


client = redis.StrictRedis(
    host=utils.get_env_var(env_constants.ENV_REDIS_HOST),
    port=utils.get_env_var(env_constants.ENV_REDIS_PORT, required=False, default=6379),
    decode_responses=True,
)


def get_and_ingest_logs(chronicle_label: str, domain_list: list[str]) -> None:
    """Fetch logs from the DomainTools platform and ingest it to Chronicle.

    Args:
      chronicle_label (str): Chronicle label in which data will be ingested.

    Raises:
      RuntimeError: When logs could not be pushed to the Chronicle.
    """
    domaintool_user = utils.get_env_var(ENV_DOMAINTOOLS_API_USERNAME, is_secret=True)
    domaintool_password = utils.get_env_var(ENV_DOMAINTOOLS_API_KEY, is_secret=True)

    try:
        provisional_ttl = utils.get_env_var(ENV_PROVISIONAL_TTL, required=False, default=1)
        provisional_ttl = int(provisional_ttl)
        non_provisional_ttl = utils.get_env_var(
            ENV_NON_PROVISIONAL_TTL, required=False, default=30
        )
        non_provisional_ttl = int(non_provisional_ttl)
    except ValueError as e:
        print("Error occurred while storing domains in the memory store. An invalid value is provided for the TTL in the environment variable.")
        raise e

    domain_tool_client_object = domaintool_client.DomainToolClient(
        domaintool_user, domaintool_password
    )

    # skip domains which are present in allow_list
    allow_list_name = utils.get_env_var(ENV_ALLOW_LIST, required=False, default="")
    if allow_list_name != "":
        try:
            allow_list_domains = ingest.get_reference_list(allow_list_name)
        except Exception as error:
            print("Unable to fetch reference list. Error", error)
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
                        raise e
                    except Exception as e:
                        print(f"Attempt {try_count + 1} failed: {e}")
                        try_count += 1
                        if try_count < max_retries:
                            print("Retrying in 30 seconds...")
                            time.sleep(30)
                        else:
                            print("API call to DomainTools failed. Rate limit exceeded.")
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
                    raise e
                except Exception as e:
                    print(f"Attempt {try_count + 1} failed: {e}")
                    try_count += 1
                    if try_count < max_retries:
                        print("Retrying in 30 seconds...")
                        time.sleep(30)
                    else:
                        print("API call to DomainTools failed. Rate limit exceeded.")
                        raise e
            all_responses.append(response)
    print("Completed enriching domains from the DomainTools.")

    for response in all_responses:
        for val in response.get("results"):
            logs.append(val)
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


def main(request) -> str:
    """Entry point for the script."""
    print("Fetching logs from Chronicle.")
    chronicle_label = utils.get_env_var(ENV_CHRONICLE_DATA_TYPE)
    gcp_bucket_name = utils.get_env_var(env_constants.ENV_GCP_BUCKET_NAME)
    storage_client = storage.Client()
    current_bucket = storage_client.get_bucket(gcp_bucket_name)
    try:
        blob = current_bucket.blob(
            utils.get_env_var(ENV_LOG_TYPE_FILE_PATH, required=False, default="temp")
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
        domain_list, checkpoint_blob, new_checkpoint = object_fetch_log.fetch_data()
    except ValueError:
        return "Ingestion not Completed"
    except RuntimeError as err:
        print("Error in fetching log: ", err)
        return "Ingestion not Completed"
    print("Completed fetching logs from Chronicle.")

    if not domain_list:
        print("No domains found in the fetched logs from Chronicle.")
        with checkpoint_blob.open(mode="w", encoding="utf-8") as json_file:
            json_file.write(json.dumps(new_checkpoint))
        print("The checkpoint is updated to {}.".format(new_checkpoint.get('time')))
        return "Ingestion not Completed"
    try:
        get_and_ingest_logs(chronicle_label, domain_list)
    except Exception:
        return "Ingestion not Completed"
    with checkpoint_blob.open(mode="w", encoding="utf-8") as json_file:
        json_file.write(json.dumps(new_checkpoint))
    print("The checkpoint is updated to {}.".format(new_checkpoint.get('time')))
    return "Ingestion Completed"
