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
ENV_PARSER_LABEL_FILE_PATH = "PARSER_LABEL_FILE_PATH"
ENV_PROVISIONAL_TTL = "PROVISIONAL_TTL"
ENV_NON_PROVISIONAL_TTL = "NON_PROVISIONAL_TTL"
ENV_ALLOW_LIST = "ALLOW_LIST"


client = redis.StrictRedis(host=utils.get_env_var(env_constants.ENV_REDIS_HOST), port=utils.get_env_var(env_constants.ENV_REDIS_PORT, required=False, default=6379), decode_responses=True)


def get_and_ingest_logs(
      chronicle_label: str,
      domain_list: list[str]
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
      principal_hostname = val.get("domain")
      risk_score_status = val.get("risk_score_status")
      # print("Start Adding data in cache: ", principal_hostname)
      data_updated_time = val.get("data_updated_timestamp")
      current_timestamp = datetime.now().strftime("%Y-%m-%dT%H:%M:%S.%f")

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

def main(request) -> str:
  """Entry point for the script.

  """
  print(f"Start process of log fetching")
  chronicle_label = utils.get_env_var(ENV_CHRONICLE_DATA_TYPE)
  gcp_bucket_name = utils.get_env_var(env_constants.ENV_GCP_BUCKET_NAME)
  storage_client = storage.Client()
  current_bucket = storage_client.get_bucket(gcp_bucket_name)
  try:
    blob = current_bucket.blob(utils.get_env_var(ENV_PARSER_LABEL_FILE_PATH))
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
    get_and_ingest_logs(chronicle_label, domain_list)
    print("Completed execution of ingestion scripts in time")
  return "Ingestion Completed"
