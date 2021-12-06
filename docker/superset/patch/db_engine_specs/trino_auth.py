from authlib.integrations.requests_client import OAuth2Session
from authlib.oauth2.rfc6749 import OAuth2Token
from trino.auth import Authentication

from superset.extensions import cache_manager


def extract_timeout_from_token(token: OAuth2Token) -> int:
    if "refresh_token" in token:
        if "refresh_expires_in" in token:
            return token.get("refresh_expires_in")
        else:
            # from authlib.jose import jwt
            import jwt
            refresh_token: str = token.get("refresh_token")
            payload = jwt.decode(refresh_token, key="", verify=False)
            if "exp" in payload:
                from time import time
                return int(payload.get("exp") - time())

    if "expires_at" in token:
        from time import time
        return int(token.get("expires_at") - time())
    elif "expires_in" in token:
        return token.get("expires_in")
    else:
        return 600  # 10min


class OAuth2ClientCredentialAuthentication(Authentication):
    """
    See:
    * :class:`authlib.integrations.requests_client.oauth2_session.OAuth2Auth`
    * :class:`authlib.oauth2.client.OAuth2Client`
    """

    def __init__(
        self,
        client_id: str,
        client_secret: str,
        token_endpoint: str,
        **kwargs
    ) -> None:
        client_kwargs = kwargs.copy()
        client_kwargs.update(
            client_id=client_id,
            client_secret=client_secret,
            token_endpoint=token_endpoint,
        )
        self._cache_key = "trino.oauth2.client_credentials." + \
                          str(hash(frozenset(client_kwargs.items())))

        # patch(1/2) `update_session_configure` in OAuth2Session.__init__
        session_configs = {}
        for k in OAuth2Session.SESSION_REQUEST_PARAMS:
            if k in client_kwargs:
                session_configs[k] = client_kwargs.pop(k)
        self.client = OAuth2Session(**client_kwargs)
        # patch(2/2) `update_session_configure` in OAuth2Session.__init__
        for k, v in session_configs.items():
            setattr(self.client, k, v)

        self.client.update_token = self.update_token()

    def set_client_session(self, client_session):
        pass

    def set_http_session(self, http_session):
        if not self.client.token:
            self.initialize_token()
        http_session.auth = self.client.token_auth
        return http_session

    def setup(self, trino_client):
        self.set_client_session(trino_client.client_session)
        self.set_http_session(trino_client.http_session)

    def get_exceptions(self):
        return ()

    def handle_error(self, handle_error):
        pass

    def update_token(self):
        def func(token: OAuth2Token,
                 refresh_token: str = None,
                 access_token: str = None):
            timeout = extract_timeout_from_token(token)
            cache_manager.cache.set(key=self._cache_key, value=token, timeout=timeout)

            self.client.token = token

        return func

    def initialize_token(self):
        token: OAuth2Token = cache_manager.cache.get(self._cache_key)
        if token is None:
            token = self.client.fetch_token(grant_type="client_credentials")
            self.client.update_token(token)

        self.client.token = token
