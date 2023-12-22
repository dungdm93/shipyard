import os
from flask_appbuilder.security.manager import AUTH_OAUTH

AUTH_ROLE_PUBLIC = "Public"
AUTH_TYPE = AUTH_OAUTH
AUTH_USER_REGISTRATION = True
AUTH_USER_REGISTRATION_ROLE = "Default"

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
            "client_id":     {{ fetchSecretValue "ref+vault://secret/gitops/airflow/auth#/client_id" | quote }},
            "client_secret": {{ fetchSecretValue "ref+vault://secret/gitops/airflow/auth#/client_secret" | quote }},
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

from airflow.www.security import AirflowSecurityManager

class KeyCloakSecurityManager(AirflowSecurityManager):
    import logging
    log = logging.getLogger(__name__)

    def oauth_user_info(self, provider, response=None):
        if provider.lower() != "keycloak":
            return self.get_oauth_user_info(provider, response)

        me = self.appbuilder.sm.oauth_remotes[provider].get("protocol/openid-connect/userinfo")
        data = me.json()

        self.log.debug("User info %s", data)
        return {
            "id":         data["sub"],
            "name":       data["name"],
            "username":   data["preferred_username"],
            "email":      data.get("email"),
            "first_name": data.get("given_name"),
            "last_name":  data.get("family_name"),
        }

SECURITY_MANAGER_CLASS = KeyCloakSecurityManager
SEND_FILE_MAX_AGE_DEFAULT = 86400   # 1d
