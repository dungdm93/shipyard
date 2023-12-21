# ===== Webserver =====
# https://superset.apache.org/docs/frequently-asked-questions#why-are-my-queries-timing-out
SUPERSET_WEBSERVER_TIMEOUT = 900  # 15 minutes
UPLOAD_FOLDER = "/opt/superset/static/uploads/"
IMG_UPLOAD_FOLDER = "/opt/superset/static/uploads/"

MAPBOX_API_KEY = {{ fetchSecretValue "ref+vault://secret/gitops/superset/external/mapbox#/api_key" | quote }}
SLACK_API_TOKEN = {{ fetchSecretValue "ref+vault://secret/gitops/superset/external/slack#/api_token" | quote }}

# ===== Caching =====
# https://flask-caching.readthedocs.io/en/latest/#configuring-flask-caching

__redis_cache = {
    "CACHE_TYPE": "RedisCache",
    "CACHE_DEFAULT_TIMEOUT": 60 * 60 * 24,  # 1 day
    "CACHE_REDIS_HOST": REDIS_HOST,
    "CACHE_REDIS_PORT": REDIS_PORT,
    "CACHE_REDIS_PASSWORD": REDIS_PASSWORD,
}

# Caching for Superset's own metadata
CACHE_CONFIG = {
    **__redis_cache,
    "CACHE_REDIS_DB": "3",
    "CACHE_KEY_PREFIX": "superset.metadata.",
}

# Caching for charting data queried from datasources
DATA_CACHE_CONFIG = {
    **__redis_cache,
    "CACHE_REDIS_DB": "4",
    "CACHE_KEY_PREFIX": "superset.query.",
}

THUMBNAIL_CACHE_CONFIG = {
    **__redis_cache,
    "CACHE_REDIS_DB": "5",
    "CACHE_KEY_PREFIX": "superset.thumbnail.",
}

FILTER_STATE_CACHE_CONFIG = {
    **__redis_cache,
    "CACHE_REDIS_DB": "6",
    "CACHE_KEY_PREFIX": "superset.filter_state.",
}

EXPLORE_FORM_DATA_CACHE_CONFIG = {
    **__redis_cache,
    "CACHE_REDIS_DB": "6",
    "CACHE_KEY_PREFIX": "superset.explore.",
}

# ===== Optional Feature =====
FEATURE_FLAGS = {
    "THUMBNAILS": True,
    "ALERT_REPORTS": True,
    "ALERTS_ATTACH_REPORTS": True,
    "EMBEDDED_SUPERSET": True,
    "ENABLE_TEMPLATE_PROCESSING": True,
    "DASHBOARD_RBAC": True,
    "DASHBOARD_CROSS_FILTERS": True,
}

# ===== Security =====
# https://flask-appbuilder.readthedocs.io/en/latest/security.html
from flask_appbuilder.security.manager import AUTH_OAUTH

AUTH_TYPE = AUTH_OAUTH
AUTH_USER_REGISTRATION = True
AUTH_USER_REGISTRATION_ROLE = "Public"

keycloak_endpoint = "https://keycloak.dungdm93.me"
keycloak_realm = "kit106"

# def compliance_fix_self_signed_ca(session):
#     session.verify = "/etc/pki/k8s/ca.crt"

OAUTH_PROVIDERS = [
    {
        "name": "keycloak",
        "icon": "fa-key",
        "token_key": "access_token",
        "remote_app": {
            "client_id":     {{ fetchSecretValue "ref+vault://secret/gitops/superset/auth#/client_id" | quote }},
            "client_secret": {{ fetchSecretValue "ref+vault://secret/gitops/superset/auth#/client_secret" | quote }},
            "client_kwargs": {
                "scope": "openid email profile"
            },
            "api_base_url": f"{keycloak_endpoint}/realms/{keycloak_realm}/",
            "authorize_url": f"{keycloak_endpoint}/realms/{keycloak_realm}/protocol/openid-connect/auth",
            "access_token_url": f"{keycloak_endpoint}/realms/{keycloak_realm}/protocol/openid-connect/token",
            "jwks_uri": f"{keycloak_endpoint}/realms/{keycloak_realm}/protocol/openid-connect/certs",
            "request_token_url": None, # OAuth 1.0 only
            # "compliance_fix": compliance_fix_self_signed_ca
        },
    },
]

from superset.security import SupersetSecurityManager

class KeyCloakSecurityManager(SupersetSecurityManager):
    logger = logging.getLogger(__name__)

    def oauth_user_info(self, provider, response=None):
        if provider.lower() != "keycloak":
            return self.get_oauth_user_info(provider, response)

        me = self.appbuilder.sm.oauth_remotes[provider].get("protocol/openid-connect/userinfo")
        data = me.json()

        self.logger.debug("User info %s", data)
        return {
            "id":         data["sub"],
            "name":       data["name"],
            "username":   data["preferred_username"],
            "email":      data.get("email"),
            "first_name": data.get("given_name"),
            "last_name":  data.get("family_name"),
        }

CUSTOM_SECURITY_MANAGER = KeyCloakSecurityManager

# ===== Alerts/Reports =====
ENABLE_ALERTS = True
ENABLE_SCHEDULED_EMAIL_REPORTS = True

EMAIL_NOTIFICATIONS = True
SMTP_HOST = "smtp.sendgrid.net"
SMTP_PORT = 587
SMTP_STARTTLS = True
SMTP_SSL = False
SMTP_USER = {{ fetchSecretValue "ref+vault://secret/gitops/superset/external/smtp#/username" | quote }}
SMTP_PASSWORD = {{ fetchSecretValue "ref+vault://secret/gitops/superset/external/smtp#/password" | quote }}
SMTP_MAIL_FROM = "Đặng Minh Dũng <superset@dungdm93.me>"

# ===== Trino Authentication =====
from authlib.integrations.requests_client import OAuth2Session
from authlib.oauth2.rfc6749 import OAuth2Token
from trino.auth import Authentication


def extract_timeout_from_token(token: OAuth2Token) -> int:
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
        self.client = OAuth2Session(
            client_id=client_id,
            client_secret=client_secret,
            token_endpoint=token_endpoint,
            update_token=self._update_token(),
            **kwargs
        )

        param_hash = hash(
            frozenset({
                ("client_id", client_id),
                ("client_secret", client_secret),
                ("token_endpoint", token_endpoint),
                *kwargs.items()
            })
        )
        self._cache_key = f"trino.oauth2.client_credentials.{param_hash}"

    def set_http_session(self, http_session):
        if not self.client.token:
            self._initialize_token()
        http_session.auth = self.client.token_auth
        return http_session

    def _update_token(self):
        from superset.extensions import cache_manager

        def func(token: OAuth2Token,
                 refresh_token: str = None,
                 access_token: str = None):
            timeout = extract_timeout_from_token(token)
            cache_manager.cache.set(key=self._cache_key, value=token, timeout=timeout)

            self.client.token = token

        return func

    def _initialize_token(self):
        from superset.extensions import cache_manager

        token: OAuth2Token = cache_manager.cache.get(self._cache_key)
        if token is None:
            token = self.client.fetch_token(grant_type="client_credentials")
            self.client.update_token(token)

        self.client.token = token


ALLOWED_EXTRA_AUTHENTICATIONS = {
    "trino": {
        "oauth2_client_credential": OAuth2ClientCredentialAuthentication,
    },
}

# ===== Event Logging =====
from superset.stats_logger import StatsdStatsLogger

STATS_LOGGER = StatsdStatsLogger(host="superset-statsd", port=9125, prefix="superset")

# ===== Mix =====
import urllib3
urllib3.disable_warnings()
