import domaintool_client
from google.cloud import storage
import fetch_logs
from common import ingest
from common import utils
from common import env_constants
import redis
from datetime import datetime
from google.auth.transport import requests as Requests
from google.oauth2 import service_account



# Environment variable constants
ENV_DOMAINTOOL_USER = "DOMAINTOOL_USER"
ENV_DOMAINTOOL_PASSWORD = "DOMAINTOOL_PASSWORD"
ENV_CHRONICLE_DATA_TYPE = "CHRONICLE_DATA_TYPE"
ENV_PARSER_LABEL = "PARSER_LABEL"
ENV_PROVISIONAL_TTL = "PROVISIONAL_TTL"
ENV_NON_PROVISIONAL_TTL = "NON_PROVISIONAL_TTL"
ENV_ALLOW_LIST = "ALLOW_LIST"
ENV_MONITORING_LIST = "MONITORING_LIST"
ENV_MONITORING_TAGS = "MONITORING_TAGS"
ENV_BULK_ENRICHMENT = "BULK_ENRICHMENT"


client = redis.StrictRedis(host=utils.get_env_var(env_constants.ENV_REDIS_HOST), port=utils.get_env_var(env_constants.ENV_REDIS_PORT, required=False, default=6379), decode_responses=True)


def get_and_ingest_logs(
      chronicle_label: str,
      domain_list: list[str],
      function_type: str
) -> None:
  """Fetch logs from the DomainTools platform and ingest it to Chronicle.

  Args:
    chronicle_label (str): Chronicle label in which data will be ingested.

  Raises:
    RuntimeError: When logs could not be pushed to the Chronicle.
  """
  print("Start fetching cred from the secret manager")
  domaintool_user = utils.get_env_var(ENV_DOMAINTOOL_USER, is_secret=True)
  domaintool_password = utils.get_env_var(ENV_DOMAINTOOL_PASSWORD, is_secret=True)
  print("End fetching cred from the secret manager")

  print("Fetch TTL information from environment variables")
  provisional_ttl = utils.get_env_var(ENV_PROVISIONAL_TTL)
  non_provisional_ttl = utils.get_env_var(ENV_NON_PROVISIONAL_TTL)

  domain_tool_client_object = domaintool_client.DomainToolClient(domaintool_user, domaintool_password)
  if function_type == "scheduler":
    # skip domains which are present in allow_list
    allow_list_name = utils.get_env_var(ENV_ALLOW_LIST)
    try:
      allow_list_domains = ingest.get_reference_list(allow_list_name)
    except Exception as error:
      print("Unable to fetch reference list. Error", error)
      allow_list_domains = []

    # skip domains which is already present in redis
    for domain in domain_list:
      data = client.hget(domain, 'value')
      if data or (domain in allow_list_domains):
        domain_list.remove(domain)

  # domain_tool_client_object = domaintool_client.DomainToolClient()

  print("Start fetching Data from DomainTool")
  logs = []
  all_responses = []

  if len(domain_list) > 100:
    start_len = 0
    end_len = 100
    queue_len = len(domain_list)
    while queue_len > 0:
      queued_domains_part = domain_list[start_len:end_len]
      if queued_domains_part > 0:
        response = domain_tool_client_object.enrich(queued_domains_part)
        all_responses.append(response)
      
      queue_len -= 100
      start_len = end_len

      if queue_len > 100:
        end_len = start_len + 100
      else:
        end_len = start_len + queue_len
  else:
    if len(domain_list) > 0:
      response = domain_tool_client_object.enrich(domain_list)
      all_responses.append(response)
  print("End fetching Data from DomainTool")

  print("Start adding data to the memorystore.")
  for response in all_responses:
    for val in response.get("results"):
      logs.append(val)
      if function_type == "bulk_enrichment":
        continue
      principal_hostname = val.get("domain")
      risk_score_status = val.get("risk_score_status")
      # print("Start Adding data in cache: ", principal_hostname)
      data_updated_time = val.get("data_updated_timestamp")
      current_timestamp = datetime.now().strftime("%Y-%m-%dT%H:%M:%S.%f")
      if function_type == "monitoring_domain":
        val['monitor_domain'] = True
        val['timestamp'] = current_timestamp

      # Prepare a dictionary to store in the Redis Hash
      data_to_cache = {
          "value": principal_hostname,
          "created_timestamp": str(current_timestamp),
          "data_updated_time": str(data_updated_time)
      }
  
      # Use the Redis HMSET command to set the dictionary in the Redis Hash
      client.hmset(principal_hostname, data_to_cache)
      if risk_score_status == "provisional":
        ttl = int(provisional_ttl) * 86400  # no of seconds in a day = 86400
      else:
        ttl = int(non_provisional_ttl) * 86400
      
      # Set the TTL for the key
      client.expire(principal_hostname, ttl)
      # print("End Adding data in cache ", principal_hostname)
  print("End adding data to the memorystore")

  print(f"Total {len(logs)} number of data fetched from DomainToools.")

  if logs:
    try:
      print("Start ingesting log into chronicle")
      ingest.ingest(logs, chronicle_label)
      print("End ingesting log into chronicle")
    except Exception as error:
      raise RuntimeError(f"Unable to push data to Chronicle. {error}") from error

def generate_dummy_events(domains_tags, param_type):
  dummy_event_list = []
  current_timestamp = datetime.now().strftime("%Y-%m-%dT%H:%M:%S.%f")
  for field in domains_tags:
    temp_event = {
      "timestamp": current_timestamp
    }
    if param_type == "allow_list":
      temp_event["domain"] = field
      temp_event["allow_domain"] = True
    elif param_type == "monitoring_tags":
      temp_event["tag_name"] = field
      temp_event["monitor_tag"] = True
    dummy_event_list.append(temp_event)
  return dummy_event_list

def entry(allow_list=False, monitoring_list=False, monitoring_tags=False, bulk_enrichment=False, function_type="scheduler"):
  print(f"Start process of log fetching")
  chronicle_label = utils.get_env_var(ENV_CHRONICLE_DATA_TYPE)
  if function_type == "scheduler":
    gcp_bucket_name = utils.get_env_var(env_constants.ENV_GCP_BUCKET_NAME)
    storage_client = storage.Client()
    current_bucket = storage_client.get_bucket(gcp_bucket_name)
    try:
      blob = current_bucket.blob("DomainTools/parser_labels.txt")
      parser_labels = blob.download_as_text()
    except Exception as e:
      print("An error occurred:", e)
      return "Ingestion not Completed"
    object_fetch_log = fetch_logs.fechLogs(parser_labels)
    domain_list = object_fetch_log.fetch_data()
    print("End process of log fetching")

    if not domain_list:
      print("No logs found from chronicle")
      return "Ingestion not Completed"
    else:
      print("Started execution of ingestion scripts.")
      get_and_ingest_logs(chronicle_label, domain_list, "scheduler")
      print("Completed execution of ingestion scripts in time")
      return "Ingestion Completed"
  else:
    if monitoring_list:
      monitoring_list_name = utils.get_env_var(ENV_MONITORING_LIST)
      monitoring_list_domains = ingest.get_reference_list(monitoring_list_name)
      get_and_ingest_logs(chronicle_label, monitoring_list_domains, "monitoring_domain")
    if bulk_enrichment:
      bulk_enrichment_name = utils.get_env_var(ENV_BULK_ENRICHMENT)
      bulk_enrichment_domains = ingest.get_reference_list(bulk_enrichment_name)
      get_and_ingest_logs(chronicle_label, bulk_enrichment_domains, "bulk_enrichment")
    if allow_list:
      allow_list_name = utils.get_env_var(ENV_ALLOW_LIST)
      allow_list_domains = ingest.get_reference_list(allow_list_name)
      allow_list_dummy_events = generate_dummy_events(allow_list_domains, "allow_list")
      if allow_list_dummy_events:
        try:
          print("Start ingesting allow list dummy log into chronicle")
          ingest.ingest(allow_list_dummy_events, chronicle_label)
          print("End ingesting allow list dummy log into chronicle")
        except Exception as error:
          raise RuntimeError(f"Unable to push data to Chronicle. {error}") from error
    if monitoring_tags:
      monitoring_tags_name = utils.get_env_var(ENV_MONITORING_TAGS)
      monitoring_tags_list = ingest.get_reference_list(monitoring_tags_name)
      monitoring_tags_dummy_events = generate_dummy_events(monitoring_tags_list, "monitoring_tags")
      if monitoring_tags_dummy_events:
        try:
          print("Start ingesting monitoring tags dummy log into chronicle")
          ingest.ingest(monitoring_tags_dummy_events, chronicle_label)
          print("End ingesting monitoring tags dummy log into chronicle")
        except Exception as error:
          raise RuntimeError(f"Unable to push data to Chronicle. {error}") from error
    return "Ingestion Completed"


def main(request) -> str:
  """Entry point for the script.

  """
  request_body = request.get_json()
  adhoc = request_body.get('adhoc')
  if request_body.get('adhoc'):
    print("Adhoc")

    if 'allow_list' in request_body:
      allow_list = request_body['allow_list']
    else:
      allow_list = False
    
    if 'monitoring_list' in request_body:
      monitoring_list = request_body['monitoring_list']
    else:
      monitoring_list = False
    
    if 'monitoring_tags' in request_body:
      monitoring_tags = request_body['monitoring_tags']
    else:
      monitoring_tags = False
    
    if 'bulk_enrichment' in request_body:
      bulk_enrichment = request_body['bulk_enrichment']
    else:
      bulk_enrichment = False

    return entry(allow_list, monitoring_list, monitoring_tags, bulk_enrichment, function_type="adhoc")
  else:
    print("Scheduler")
    return entry()


