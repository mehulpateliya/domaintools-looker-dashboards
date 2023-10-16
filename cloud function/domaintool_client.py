import requests

from domaintools.exceptions import (
    NotAuthorizedException,
    ServiceUnavailableException,
)

from domaintools import API
from domaintools import __version__ as dt_api_version

import dt_exception_messages

class DomainToolClient:

	def __init__(self, domaintool_user: str, domaintool_password: str) -> None:
	# def __init__(self) -> None:
		self.domaintool_user = domaintool_user
		self.domaintool_password = domaintool_password
		self.api = self.generate_api()

	def enrich(self, queued_domains):
		"""query Iris Enrich API for batch of domains
			:param queued_domains: list of domain
			:return: iris data
		"""

		try:
			response = self.api.iris_enrich(*list(queued_domains)).response()
		except NotAuthorizedException as e:
			print(f"error: {e}")
			raise Exception(dt_exception_messages.not_autorized)
		except ServiceUnavailableException as e:
			raise Exception(dt_exception_messages.service_not_available)
		except requests.exceptions.ProxyError as e:
			print(f"error: {e}")
		except requests.exceptions.SSLError as e:
			print(f"error: {e}")
		except Exception as e:
			print(f"error: {e}")
		return response
	
	def generate_api(self):
		return API(
            self.domaintool_user,
            self.domaintool_password,
			# "dnunes_chronicle_testing",
			# "a4e0c-11012-9732c-dc7cc-24174",
            app_partner="Test",
            app_name="test_name",
            app_version=None,
            api_version=dt_api_version,
            proxy_url=None,
            verify_ssl=False,
            always_sign_api_key=True,
        )