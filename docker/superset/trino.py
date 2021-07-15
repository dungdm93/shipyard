from datetime import datetime
from typing import Any, Dict, Optional, TYPE_CHECKING
from urllib import parse

from sqlalchemy.engine.url import URL
from trino.auth import Authentication

from superset.db_engine_specs.base import BaseEngineSpec
from superset.utils import core as utils
from superset.extensions import cache_manager

if TYPE_CHECKING:
    from superset.models.core import Database

token_cache_key = "TOKEN_OAUTH2_TOKEN_KEY"


class OAuth2Authentication(Authentication):
    def __init__(
        self,
        client_id: str,
        client_secret: str,
        token_endpoint: str,
    ) -> None:
        from authlib.integrations.requests_client import OAuth2Session

        self.client = OAuth2Session(
            client_id=client_id,
            client_secret=client_secret,
            token_endpoint=token_endpoint,
            verify=False
        )
        self.client.update_token = OAuth2Authentication.update_token(self.client)

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
            token = client.fetch_token(grant_type='client_credentials', verify=False)
            cache_manager.cache.set(key=token_cache_key, value=token, timeout=600)
        client.update_token(token)


class TrinoEngineSpec(BaseEngineSpec):
    engine = "trino"
    engine_name = "Trino"

    # pylint: disable=line-too-long
    _time_grain_expressions = {
        None: "{col}",
        "PT1S": "date_trunc('second', CAST({col} AS TIMESTAMP))",
        "PT1M": "date_trunc('minute', CAST({col} AS TIMESTAMP))",
        "PT1H": "date_trunc('hour', CAST({col} AS TIMESTAMP))",
        "P1D": "date_trunc('day', CAST({col} AS TIMESTAMP))",
        "P1W": "date_trunc('week', CAST({col} AS TIMESTAMP))",
        "P1M": "date_trunc('month', CAST({col} AS TIMESTAMP))",
        "P0.25Y": "date_trunc('quarter', CAST({col} AS TIMESTAMP))",
        "P1Y": "date_trunc('year', CAST({col} AS TIMESTAMP))",
        # "1969-12-28T00:00:00Z/P1W",  # Week starting Sunday
        # "1969-12-29T00:00:00Z/P1W",  # Week starting Monday
        # "P1W/1970-01-03T00:00:00Z",  # Week ending Saturday
        # "P1W/1970-01-04T00:00:00Z",  # Week ending Sunday
    }

    @classmethod
    def convert_dttm(cls, target_type: str, dttm: datetime) -> Optional[str]:
        tt = target_type.upper()
        if tt == utils.TemporalType.DATE:
            value = dttm.date().isoformat()
            return f"from_iso8601_date('{value}')"
        if tt == utils.TemporalType.TIMESTAMP:
            value = dttm.isoformat(timespec="microseconds")
            return f"from_iso8601_timestamp('{value}')"
        return None

    @classmethod
    def epoch_to_dttm(cls) -> str:
        return "from_unixtime({col})"

    @classmethod
    def adjust_database_uri(
        cls, uri: URL, selected_schema: Optional[str] = None
    ) -> None:
        database = uri.database
        if selected_schema and database:
            selected_schema = parse.quote(selected_schema, safe="")
            database = database.split("/")[0] + "/" + selected_schema
            uri.database = database

    @staticmethod
    def get_extra_params(database: "Database") -> Dict[str, Any]:
        extra: Dict[str, Any] = BaseEngineSpec.get_extra_params(database)
        engine_params: Dict[str, Any] = extra.setdefault("engine_params", {})
        connect_args: Dict[str, Any] = engine_params.setdefault("connect_args", {})

        if database.server_cert:
            connect_args["http_scheme"] = "https"
            connect_args["verify"] = utils.create_ssl_cert_file(database.server_cert)

        return extra

    @staticmethod
    def get_encrypted_extra_params(database: "Database") -> Dict[str, Any]:
        extra: Dict[str, Any] = BaseEngineSpec.get_encrypted_extra_params(database)

        auth_method = extra.pop("auth_method", None)
        auth_params = extra.pop("auth_params", {})
        if not auth_method:
            return extra

        connect_args = extra.setdefault("connect_args", {})
        connect_args["http_scheme"] = "https"
        connect_args["verify"] = False
        if auth_method == "kerberos":
            from trino.auth import KerberosAuthentication
            connect_args["auth"] = KerberosAuthentication(**auth_params)
        elif auth_method == "oauth2_client_credentials":
            auth = OAuth2Authentication(**auth_params)
            print(id(auth))
            connect_args["auth"] = auth
        return extra
