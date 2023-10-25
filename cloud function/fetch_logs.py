"""Fetch the logs from chronicle"""
import json
import math
from datetime import datetime, timedelta
from google.oauth2 import service_account
from googleapiclient import _auth
from google.cloud import storage
from common import utils
from common import env_constants

BACKSTORY_API_V1_URL = "https://backstory.googleapis.com/v1"

SCOPES = ["https://www.googleapis.com/auth/chronicle-backstory"]

SERVICE_ACCOUNT_FILE = "CHRONICLE_SERVICE_ACCOUNT"

LIST_USER_ALIASES_URL = ""

ENV_CHECKPOINT_FILE_PATH = "CHECKPOINT_FILE_PATH"
ENV_LOG_FETCH_DURATION = "LOG_FETCH_DURATION"


class FetchLogs:
    """FetchLogs class
    """
    def __init__(self, log_types: str) -> None:
        self.log_types = log_types

    def fetch_data_and_checkpoint(self):
        """Fetch the checkpoint and fetch the data from chronicle
        """
        end_time_duration = int(utils.get_env_var(ENV_LOG_FETCH_DURATION))
        labels = self.divide_lable()
        label_size = len(labels)
        if label_size > 0:
            parse_query = "("
        else:
            parse_query = ""
        for val in range(len(labels)):
            parse_query += 'metadata.log_type+%3D+"{}"'.format(labels[val])
            if val < label_size - 1:
                parse_query += "+or+"
        if label_size > 0:
            parse_query += ")%20AND%20("

        parse_query += "hostname%20%3D%20%2F%5E(%3F:https%3F:%5C%2F%5C%2F)%3F(%3F:%5B%5E@%5C%2F%5Cn%5D%2B@)%3F(%3F:www%5C.)%3F(%5B%5E:%5C%2F%3F%5Cn%5D%2B)%2F%20or%20domain%20%3D%20%2F%5E(%3F:https%3F:%5C%2F%5C%2F)%3F(%3F:%5B%5E@%5C%2F%5Cn%5D%2B@)%3F(%3F:www%5C.)%3F(%5B%5E:%5C%2F%3F%5Cn%5D%2B)%2F%20or%20principal.url%20%3D%20%2F%5E(%3F:https%3F:%5C%2F%5C%2F)%3F(%3F:%5B%5E@%5C%2F%5Cn%5D%2B@)%3F(%3F:www%5C.)%3F(%5B%5E:%5C%2F%3F%5Cn%5D%2B)%2F%20or%20about.url%20%3D%20%2F%5E(%3F:https%3F:%5C%2F%5C%2F)%3F(%3F:%5B%5E@%5C%2F%5Cn%5D%2B@)%3F(%3F:www%5C.)%3F(%5B%5E:%5C%2F%3F%5Cn%5D%2B)%2F%20or%20src.url%20%3D%20%2F%5E(%3F:https%3F:%5C%2F%5C%2F)%3F(%3F:%5B%5E@%5C%2F%5Cn%5D%2B@)%3F(%3F:www%5C.)%3F(%5B%5E:%5C%2F%3F%5Cn%5D%2B)%2F%20or%20target.url%20%3D%20%2F%5E(%3F:https%3F:%5C%2F%5C%2F)%3F(%3F:%5B%5E@%5C%2F%5Cn%5D%2B@)%3F(%3F:www%5C.)%3F(%5B%5E:%5C%2F%3F%5Cn%5D%2B)%2F%20or%20intermediary.url%20%3D%20%2F%5E(%3F:https%3F:%5C%2F%5C%2F)%3F(%3F:%5B%5E@%5C%2F%5Cn%5D%2B@)%3F(%3F:www%5C.)%3F(%5B%5E:%5C%2F%3F%5Cn%5D%2B)%2F%20or%20observer.url%20%3D%20%2F%5E(%3F:https%3F:%5C%2F%5C%2F)%3F(%3F:%5B%5E@%5C%2F%5Cn%5D%2B@)%3F(%3F:www%5C.)%3F(%5B%5E:%5C%2F%3F%5Cn%5D%2B)%2F%20or%20metadata.url_back_to_product%20%3D%20%2F%5E(%3F:https%3F:%5C%2F%5C%2F)%3F(%3F:%5B%5E@%5C%2F%5Cn%5D%2B@)%3F(%3F:www%5C.)%3F(%5B%5E:%5C%2F%3F%5Cn%5D%2B)%2F%20or%20security_result.url_back_to_product%20%3D%20%2F%5E(%3F:https%3F:%5C%2F%5C%2F)%3F(%3F:%5B%5E@%5C%2F%5Cn%5D%2B@)%3F(%3F:www%5C.)%3F(%5B%5E:%5C%2F%3F%5Cn%5D%2B)%2F"
        if label_size > 0:
            parse_query += ")"
        gcp_bucket_name = utils.get_env_var(env_constants.ENV_GCP_BUCKET_NAME)
        storage_client = storage.Client()
        current_bucket = storage_client.get_bucket(gcp_bucket_name)
        blob = current_bucket.blob(
            utils.get_env_var(
                ENV_CHECKPOINT_FILE_PATH, required=False,
                default="checkpoint.json"
            )
        )
        try:
            if blob.exists():
                with blob.open(mode="r") as json_file:
                    checkpoint_data = json.load(json_file)
                    if (
                        checkpoint_data.get("time") is None
                        or checkpoint_data.get("time") == ""
                    ):
                        end_time = datetime.now()
                        start_time = end_time - timedelta(seconds=1)
                    else:
                        try:
                            start_time = datetime.strptime(
                                checkpoint_data.get("time"), "%Y-%m-%d %H:%M:%S"
                            )
                        except ValueError as e:
                            print("Error occurred while fetching events from the Chronicle. Checkpoint time is not in the valid format.")
                            raise e
                        end_time = start_time + timedelta(
                            seconds=end_time_duration)
            else:
                end_time = datetime.now()
                start_time = end_time - timedelta(seconds=1)
        except ValueError as e:
            raise e
        except Exception as err:
            print("Unable to get the file from bucket", err)
            raise err
        return self.fetch_data(parse_query, start_time, end_time, end_time_duration, blob)

    def fetch_data(self, parse_query, start_time, end_time, end_time_duration, blob):
        """Fetch the data from chronicle and extract the domains

        Returns:
            list: list of domains
            blob: blob of the checkpoint file
            dict: new checkpoint
        """
        query_start_time = f"{start_time.year}-{start_time.month}-{start_time.day}T{start_time.hour}%3A{start_time.minute}%3A{start_time.second}Z"
        query_end_time = f"{end_time.year}-{end_time.month}-{end_time.day}T{end_time.hour}%3A{end_time.minute}%3A{end_time.second}Z"

        LIST_USER_ALIASES_URL = "{}/events:udmSearch?query={}&time_range.start_time={}&time_range.end_time={}".format(
            BACKSTORY_API_V1_URL, parse_query, query_start_time, query_end_time
        )

        service_account_json = json.loads(
            utils.get_env_var(SERVICE_ACCOUNT_FILE, is_secret=True)
        )
        credentials = service_account.Credentials.from_service_account_info(
            service_account_json, scopes=SCOPES
        )
        http_client = _auth.authorized_http(credentials)
        try:
            response = http_client.request(LIST_USER_ALIASES_URL, "GET")
        except Exception as e:
            raise e
        if response[0].status == 200:
            aliases = response[1]
            # List of aliases returned for further processing
            domain_list = set()
            data = json.loads(aliases.decode("utf-8"))
            temp_log_count = 0
            if data.get("events"):
                if data.get("moreDataAvailable"):
                    if (start_time + timedelta(seconds=1)) == end_time:
                        print("We are getting more than 10k logs for 1 second.")
                    else:
                        new_end_time_duration = math.ceil(end_time_duration/2)
                        new_end_time = start_time + timedelta(seconds=new_end_time_duration)
                        print("We are getting more than 10k logs. We will consider new end time as", new_end_time)
                        return self.fetch_data(parse_query, start_time, new_end_time, new_end_time_duration, blob)
                    print("Fetching domains from logs fetched from the Chronicle.")
                for val in data["events"]:
                    temp_log_count += 1
                    principal_hostname = (
                        val.get("udm", {}).get("principal", {}).get("hostname")
                    )
                    src_hostname = val.get("udm", {}).get("src", {}).get("hostname")
                    target_hostname = (
                        val.get("udm", {}).get("target", {}).get("hostname")
                    )
                    intermediary_hostname = (
                        val.get("udm", {}).get("intermediary", [{}])[0].get("hostname")
                    )
                    observer_hostname = (
                        val.get("udm", {}).get("observer", {}).get("hostname")
                    )
                    principal_asset_hostname = (
                        val.get("udm", {})
                        .get("principal", {})
                        .get("asset", {})
                        .get("hostname")
                    )
                    src_asset_hostname = (
                        val.get("udm", {})
                        .get("src", {})
                        .get("asset", {})
                        .get("hostname")
                    )
                    target_asset_hostname = (
                        val.get("udm", {})
                        .get("target", {})
                        .get("asset", {})
                        .get("hostname")
                    )

                    network_dns_domain = (
                        val.get("udm", {}).get("network", {}).get("dnsDomain")
                    )
                    network_dns_questions_name = (
                        val.get("udm", {})
                        .get("network", {})
                        .get("dns", {})
                        .get("questions", [{}])[0]
                        .get("name")
                    )
                    principal_administrative_domain = (
                        val.get("udm", {})
                        .get("principal", {})
                        .get("administrativeDomain")
                    )
                    target_administrative_domain = (
                        val.get("udm", {})
                        .get("target", {})
                        .get("administrativeDomain")
                    )
                    about_administrative_domain = None
                    for val in val.get("udm", {}).get("about", [{}]):
                        about_administrative_domain = about_administrative_domain or (
                            val.get("administrativeDomain")
                        )
                    target_hostname = (
                        val.get("udm", {}).get("target", {}).get("hostname")
                    )
                    target_asset_hostname = (
                        val.get("udm", {})
                        .get("target", {})
                        .get("asset", {})
                        .get("hostname")
                    )
                    principal_asset_network_domain = (
                        val.get("udm", {})
                        .get("principal", {})
                        .get("asset", {})
                        .get("networkDomain")
                    )
                    target_asset_network_domain = (
                        val.get("udm", {})
                        .get("target", {})
                        .get("asset", {})
                        .get("networkDomain")
                    )
                    about_asset_network_domain = None
                    for val in val.get("udm", {}).get("about", [{}]):
                        about_asset_network_domain = about_asset_network_domain or (
                            val.get("asset", {}).get("networkDomain")
                        )

                    fields = [
                        principal_hostname,
                        src_hostname,
                        target_hostname,
                        intermediary_hostname,
                        observer_hostname,
                        principal_asset_hostname,
                        src_asset_hostname,
                        target_asset_hostname,
                        network_dns_domain,
                        network_dns_questions_name,
                        principal_administrative_domain,
                        target_administrative_domain,
                        about_administrative_domain,
                        target_hostname,
                        target_asset_hostname,
                        principal_asset_network_domain,
                        target_asset_network_domain,
                        about_asset_network_domain,
                    ]
                    for field in fields:
                        if field is not None:
                            domain_list.add(field)
            print("Completed fetching domains from logs fetched from the Chronicle.")

            print(f"Total {temp_log_count} of log fetched from Chronicle.")

            new_dt_str = end_time.strftime("%Y-%m-%d %H:%M:%S")
            new_checkpoint = {"time": new_dt_str}
            if len(domain_list) > 0:
                print(domain_list)
            return list(domain_list), blob, new_checkpoint
        else:
            # An error occurred. See the response for details.
            err = response[1]
            raise RuntimeError(err)

    def divide_lable(self) -> list[str]:
        """This function takes the string of log types, which are
        comma seperated, and convert that to a list

        Returns:
            list[str]: List of all the log types to consider for fetching
        """
        if self.log_types == "":
            return []
        log_types_list = [label.strip() for label in self.log_types.split(",")]
        return log_types_list
