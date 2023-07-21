import logging
from urllib.parse import *

# https://docs.python.org/3/library/logging.html#logrecord-attributes
logging.basicConfig(level=logging.INFO, format='[%(asctime)s] [%(levelname)-5s] %(name)-15s:%(lineno)d: %(message)s')
LOG_LEVEL = 'INFO'

SECRET_KEY = {{ .Values.superset.secretKey | default (randAlphaNum 32) | quote }}
SUPERSET_WEBSERVER_PROTOCOL = 'http'
SUPERSET_WEBSERVER_ADDRESS = '0.0.0.0'
SUPERSET_WEBSERVER_PORT = 8088
ENABLE_PROXY_FIX = True
WEBDRIVER_BASEURL = 'http://{{ include "superset.fullname" . }}-webserver:8088/'

{{ $pg  := .Values.postgresql -}}
{{ if $pg.enabled -}}
SQLA_TYPE     = "postgresql"
SQLA_HOST     = {{ include "call-nested" (list . "postgresql" "postgresql.primary.fullname") | quote }}
SQLA_PORT     = {{ include "call-nested" (list . "postgresql" "postgresql.service.port") | quote }}
SQLA_USERNAME = {{ include "call-nested" (list . "postgresql" "postgresql.username") | quote }}
SQLA_PASSWORD = "{{ $pg.auth.password }}"
SQLA_DATABASE = {{ include "call-nested" (list . "postgresql" "postgresql.database") | quote }}
{{- else -}}
{{ $xdb := .Values.externalDatabase -}}
SQLA_TYPE     = {{ $xdb.type | quote }}
SQLA_HOST     = {{ $xdb.host | quote }}
SQLA_PORT     = {{ $xdb.port | quote }}
SQLA_USERNAME = {{ $xdb.username | quote }}
SQLA_PASSWORD = {{ $xdb.password | quote }}
SQLA_DATABASE = {{ $xdb.database | quote }}
{{- end }}

SQLALCHEMY_DATABASE_URI = f'{SQLA_TYPE}://{SQLA_USERNAME}:{SQLA_PASSWORD}@{SQLA_HOST}:{SQLA_PORT}/{SQLA_DATABASE}'

{{- if or .Values.redis.enabled .Values.externalRedis.enabled }}
    {{- $redisHost := ""  }}
    {{- $redisPort := ""  }}
    {{- $redisPassword := ""  }}

    {{- if .Values.redis.enabled -}}
        {{- $redis := .Values.redis -}}
        {{- $redisHost = include "common.names.fullname" .Subcharts.redis }}
        {{- if not $redis.sentinel.enabled -}}
            {{- $redisHost = printf "%s-master" $redisHost }}
        {{- end -}}
        {{- $redisPort = $redis.sentinel.enabled | ternary $redis.sentinel.service.ports.redis $redis.master.service.ports.redis }}
        {{- $redisPassword = include "redis.password" .Subcharts.redis }}
    {{- else }}
        {{- $redis := .Values.externalRedis -}}
        {{- $redisHost = $redis.host }}
        {{- $redisPort = $redis.port }}
        {{- $redisPassword = $redis.password }}
    {{- end }}

from cachelib.redis import RedisCache
from celery.schedules import crontab

REDIS_HOST = '{{ $redisHost }}'
REDIS_PORT = '{{ $redisPort }}'
REDIS_PASSWORD = '{{ $redisPassword }}'
REDIS_AUTHORITY = f':{REDIS_PASSWORD}@' if REDIS_PASSWORD else ''

class CeleryConfig:
    BROKER_URL = f'redis://{REDIS_AUTHORITY}{REDIS_HOST}:{REDIS_PORT}/0' # _kombu.binding.
    CELERY_IMPORTS = (
        'superset.sql_lab',
        'superset.tasks',
        'superset.tasks.thumbnails',
    )
    CELERY_RESULT_BACKEND = f'redis://{REDIS_AUTHORITY}{REDIS_HOST}:{REDIS_PORT}/1'  # celery-task-meta-
    CELERYD_LOG_LEVEL = 'INFO'
    CELERYD_PREFETCH_MULTIPLIER = 10
    CELERY_ACKS_LATE = True
    CELERY_ANNOTATIONS = {
        'sql_lab.get_sql_results': {
            'rate_limit': '100/s'
        },
        'email_reports.send': {
            'rate_limit': '1/s',
            'time_limit': 120,
            'soft_time_limit': 150,
            'ignore_result': True,
        },
    }
    CELERYBEAT_SCHEDULE = {
        'email_reports.schedule_hourly': {
            'task': 'email_reports.schedule_hourly',
            'schedule': crontab(minute=1, hour='*'),
        },
        'reports.scheduler': {
            'task': 'reports.scheduler',
            'schedule': crontab(minute="*", hour="*"),
        },
        'cache-warmup-hourly': {
            'task': 'cache-warmup',
            'schedule': crontab(minute=0, hour='*'),  # hourly
            'kwargs': {
                'strategy_name': 'top_n_dashboards',
                'top_n': 5,
                'since': '7 days ago',
            },
        },
        "reports.prune_log": {
            "task": "reports.prune_log",
            "schedule": crontab(minute=0, hour=0),
        },
    }


CELERY_CONFIG = CeleryConfig
RESULTS_BACKEND = RedisCache(
    host=REDIS_HOST,
    port=REDIS_PORT,
    password=REDIS_PASSWORD,
    db=2,
    key_prefix='superset.results.'
)
{{- end }}

TALISMAN_ENABLED = True
TALISMAN_CONFIG = {
    "content_security_policy": {
        "default-src": ["'self'", "'unsafe-inline'", "'unsafe-eval'"],
        "img-src": ["'self'", "data:"],
        "worker-src": ["'self'", "blob:"],
        "connect-src": ["'self'", "https://api.mapbox.com", "https://events.mapbox.com"],
        "object-src": "'none'",
    }
}

{{ if .Values.superset.extraSupersetConfig -}}
{{ tpl .Values.superset.extraSupersetConfig . }}
{{- end }}
