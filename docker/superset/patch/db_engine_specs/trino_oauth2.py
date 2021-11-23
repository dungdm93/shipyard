from trino.auth import Authentication

from superset.extensions import cache_manager
from authlib.integrations.requests_client import OAuth2Session

token_cache_key = "TOKEN_OAUTH2_TOKEN_KEY"


class TrinoOAuth2Authentication(Authentication):
    def __init__(
        self,
        client_id: str,
        client_secret: str,
        token_endpoint: str,
    ) -> None:
        self.client = OAuth2Session(
            client_id=client_id,
            client_secret=client_secret,
            token_endpoint=token_endpoint,
            verify=False,
        )
        self.client.update_token = TrinoOAuth2Authentication.update_token(self.client)

    def set_client_session(self, client_session):
        pass

    def set_http_session(self, http_session):
        if not self.client.token:
            self.initialize_token(self.client)
        http_session.auth = self.client.token_auth
        return http_session

    def setup(self, trino_client):
        self.set_client_session(trino_client.client_session)
        self.set_http_session(trino_client.http_session)

    def get_exceptions(self):
        return ()

    def handle_error(self, handle_error):
        pass

    @staticmethod
    def update_token(client):
        def func(token, refresh_token=None, access_token=None):
            client.token = token
            client.verify = False

        return func

    @staticmethod
    def initialize_token(client):
        token = cache_manager.cache.get(token_cache_key)
        if token is None:
            token = client.fetch_token(grant_type="client_credentials", verify=False)
            cache_manager.cache.set(key=token_cache_key, value=token, timeout=600)
        client.update_token(token)
