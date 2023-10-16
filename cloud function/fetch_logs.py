from google.oauth2 import service_account
from googleapiclient import _auth
import json
from google.cloud import storage
from common import utils
from common import env_constants
from datetime import datetime, timedelta
import time
import redis

BACKSTORY_API_V1_URL = "https://backstory.googleapis.com/v1"

SCOPES = ["https://www.googleapis.com/auth/chronicle-backstory"]

SERVICE_ACCOUNT_FILE = "CHRONICLE_CREDS_FILE"

LIST_USER_ALIASES_URL = ""



class fechLogs:

    def __init__(self, parser_label: str) -> None:
        self.parser_label = parser_label
        

    def fetch_data(self) -> list[str]:
        
        labels = self.divide_lable()
        parse_query = "("
        label_size = len(labels)

        for val in range(len(labels)):
            parse_query += 'metadata.log_type+%3D+"{}"'.format(labels[val])
            if val < label_size-1:
                parse_query += "+or+"
        parse_query += ")"

        # client = redis.StrictRedis(host=redis_host, port=redis_port, decode_responses=True)

        parse_query += '%20AND%20(hostname%20%3D%20%2F%5E(%3F:https%3F:%5C%2F%5C%2F)%3F(%3F:%5B%5E@%5C%2F%5Cn%5D%2B@)%3F(%3F:www%5C.)%3F(%5B%5E:%5C%2F%3F%5Cn%5D%2B)%2F%20or%20domain%20%3D%20%2F%5E(%3F:https%3F:%5C%2F%5C%2F)%3F(%3F:%5B%5E@%5C%2F%5Cn%5D%2B@)%3F(%3F:www%5C.)%3F(%5B%5E:%5C%2F%3F%5Cn%5D%2B)%2F%20or%20principal.url%20%3D%20%2F%5E(%3F:https%3F:%5C%2F%5C%2F)%3F(%3F:%5B%5E@%5C%2F%5Cn%5D%2B@)%3F(%3F:www%5C.)%3F(%5B%5E:%5C%2F%3F%5Cn%5D%2B)%2F%20or%20about.url%20%3D%20%2F%5E(%3F:https%3F:%5C%2F%5C%2F)%3F(%3F:%5B%5E@%5C%2F%5Cn%5D%2B@)%3F(%3F:www%5C.)%3F(%5B%5E:%5C%2F%3F%5Cn%5D%2B)%2F%20or%20src.url%20%3D%20%2F%5E(%3F:https%3F:%5C%2F%5C%2F)%3F(%3F:%5B%5E@%5C%2F%5Cn%5D%2B@)%3F(%3F:www%5C.)%3F(%5B%5E:%5C%2F%3F%5Cn%5D%2B)%2F%20or%20target.url%20%3D%20%2F%5E(%3F:https%3F:%5C%2F%5C%2F)%3F(%3F:%5B%5E@%5C%2F%5Cn%5D%2B@)%3F(%3F:www%5C.)%3F(%5B%5E:%5C%2F%3F%5Cn%5D%2B)%2F%20or%20intermediary.url%20%3D%20%2F%5E(%3F:https%3F:%5C%2F%5C%2F)%3F(%3F:%5B%5E@%5C%2F%5Cn%5D%2B@)%3F(%3F:www%5C.)%3F(%5B%5E:%5C%2F%3F%5Cn%5D%2B)%2F%20or%20observer.url%20%3D%20%2F%5E(%3F:https%3F:%5C%2F%5C%2F)%3F(%3F:%5B%5E@%5C%2F%5Cn%5D%2B@)%3F(%3F:www%5C.)%3F(%5B%5E:%5C%2F%3F%5Cn%5D%2B)%2F%20or%20metadata.url_back_to_product%20%3D%20%2F%5E(%3F:https%3F:%5C%2F%5C%2F)%3F(%3F:%5B%5E@%5C%2F%5Cn%5D%2B@)%3F(%3F:www%5C.)%3F(%5B%5E:%5C%2F%3F%5Cn%5D%2B)%2F%20or%20security_result.url_back_to_product%20%3D%20%2F%5E(%3F:https%3F:%5C%2F%5C%2F)%3F(%3F:%5B%5E@%5C%2F%5Cn%5D%2B@)%3F(%3F:www%5C.)%3F(%5B%5E:%5C%2F%3F%5Cn%5D%2B)%2F)'
        gcp_bucket_name = utils.get_env_var(env_constants.ENV_GCP_BUCKET_NAME)
        storage_client = storage.Client()
        current_bucket = storage_client.get_bucket(gcp_bucket_name)
        blob = current_bucket.blob("DomainTools/checkpoint.json")
        try:
            with blob.open(mode="r") as json_file:
                checkpoint_data = json.load(json_file)
                if (checkpoint_data.get('time') == ""):
                    start_time = datetime.now()
                    dt_str = start_time.strftime("%Y-%m-%d %H:%M:%S")
                    new_data = {"time": dt_str}
                    with blob.open(mode="w", encoding="utf-8") as json_file:
                        json_file.write(json.dumps(new_data))
                else:
                    start_time = datetime.strptime(checkpoint_data.get('time'), "%Y-%m-%d %H:%M:%S")
        except Exception:  
            pass
        end_time = start_time + timedelta(minutes=1)

        query_start_time = f"{start_time.year}-{start_time.month}-{start_time.day}T{start_time.hour}%3A{start_time.minute}%3A{start_time.second}Z"
        query_end_time = f"{end_time.year}-{end_time.month}-{end_time.day}T{end_time.hour}%3A{end_time.minute}%3A{end_time.second}Z"


        LIST_USER_ALIASES_URL = '{}/events:udmSearch?query={}&time_range.start_time={}&time_range.end_time={}'.format(BACKSTORY_API_V1_URL, parse_query, query_start_time, query_end_time)

        print("Start fetching logs from chronicle")
        service_account_json = json.loads(utils.get_env_var(SERVICE_ACCOUNT_FILE, is_secret=True))
        credentials = service_account.Credentials.from_service_account_info(service_account_json, scopes=SCOPES)
        http_client = _auth.authorized_http(credentials)

        response = http_client.request(LIST_USER_ALIASES_URL, "GET")
        print("End fetching logs from chronicle")

        if response[0].status == 200:
            aliases = response[1]

            # List of aliases returned for further processing
            print("Start fetching domains from logs")
            domain_list = set()
            another_list = set()
            tmp_fields = set()
            data = json.loads(aliases.decode("utf-8"))
            temp_log_count = 0
            if data.get("events"):
              # check reading for memorystore
              # for val in data["events"]:
              #   principal_hostname = val.get("udm").get("principal").get("hostname")
              #   domain_list.add(principal_hostname)
              # print("Start reading from memorystore")
              # for val in domain_list:
              #   cached_data = client.hgetall(val)
              #   if not cached_data:
              #     another_list.add(val)
              # print("End reading from memorystore")

              for val in data["events"]:
                  temp_log_count += 1
                  principal_hostname = val.get("udm", {}).get("principal", {}).get("hostname")
                  src_hostname = val.get("udm", {}).get("src", {}).get("hostname")
                  target_hostname = val.get("udm", {}).get("target", {}).get("hostname")
                  intermediary_hostname = val.get("udm", {}).get("intermediary", [{}])[0].get("hostname")
                  observer_hostname = val.get("udm", {}).get("observer", {}).get("hostname")
                  principal_asset_hostname = val.get("udm", {}).get("principal", {}).get("asset", {}).get("hostname")
                  src_asset_hostname = val.get("udm", {}).get("src", {}).get("asset", {}).get("hostname")
                  target_asset_hostname = val.get("udm", {}).get("target", {}).get("asset", {}).get("hostname")

                  network_dns_domain = val.get("udm", {}).get("network", {}).get("dns_domain")
                  network_dns_questions_name = val.get("udm", {}).get("network", {}).get("dns", {}).get("questions", [{}])[0].get("name")
                  principal_administrative_domain = val.get("udm", {}).get("principal", {}).get("administrative_domain")
                  target_administrative_domain = val.get("udm", {}).get("target", {}).get("administrative_domain")
                  about_administrative_domain = val.get("udm", {}).get("about", [{}])[0].get("administrative_domain")
                  target_hostname = val.get("udm", {}).get("target", {}).get("hostname")
                  target_asset_hostname = val.get("udm", {}).get("target", {}).get("asset", {}).get("hostname")
                  principal_asset_network_domain = val.get("udm", {}).get("principal", {}).get("asset", {}).get("network_domain")
                  target_asset_network_domain = val.get("udm", {}).get("target", {}).get("asset", {}).get("network_domain")
                  about_asset_network_domain = val.get("udm", {}).get("about", [{}])[0].get("asset", {}).get("network_domain")

                  fields = [
                      principal_hostname, src_hostname, target_hostname, intermediary_hostname,
                      observer_hostname, principal_asset_hostname, src_asset_hostname,
                      target_asset_hostname, network_dns_domain, network_dns_questions_name,
                      principal_administrative_domain, target_administrative_domain,
                      about_administrative_domain, target_hostname, target_asset_hostname,
                      principal_asset_network_domain, target_asset_network_domain,
                      about_asset_network_domain
                  ]
                  for field in fields:
                    if field is not None:
                      tmp_fields.add(field)
            print("End fetching domains from logs")
            
            print("Start checking in memorystore")

            # for field in tmp_fields:
            #   cached_data = client.hgetall(field)
            #   # print("Complete checking data in cache")
            #   if not cached_data:
            #     # Add the principal_hostname to the domain_list
            #     domain_list.add(field)

            print("End checking in memorystore")   
            
            print(f"Total {temp_log_count} of log fetched from chronicle.")

            new_dt_str = end_time.strftime("%Y-%m-%d %H:%M:%S")
            new_checkpoint = {"time": new_dt_str}
            with blob.open(mode="w", encoding="utf-8") as json_file:
                json_file.write(json.dumps(new_checkpoint))

            print(domain_list)
            return list(domain_list)
        else:
            # An error occurred. See the response for details.
            err = response[1]
            print(err)
            return []




    def divide_lable(self) -> list[str]:
        parser_labels = [label.strip() for label in self.parser_label.split(",")]
        return parser_labels