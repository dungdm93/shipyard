import logging
from urllib.parse import *

# https://docs.python.org/3/library/logging.html#logrecord-attributes
logging.basicConfig(level=logging.INFO, format='[%(asctime)s] [%(levelname)-5s] %(name)-15s:%(lineno)d: %(message)s')

SECRET_KEY = {{ .Values.superset.secretKey | default (randAlphaNum 32) | quote }}
SUPERSET_WEBSERVER_PROTOCOL = 'http'
SUPERSET_WEBSERVER_ADDRESS = '0.0.0.0'
SUPERSET_WEBSERVER_PORT = 8088
ENABLE_PROXY_FIX = True
WEBDRIVER_BASEURL = 'http://{{ include "superset.fullname" . }}-webserver:8088/'

{{ $pg  := .Values.postgresql -}}
{{ if $pg.enabled -}}
SQLA_TYPE     = "postgresql"
SQLA_HOST     = {{ include "call-nested" (list . "postgresql" "postgresql.fullname") | quote }}
SQLA_PORT     = {{ include "call-nested" (list . "postgresql" "postgresql.port")     | quote }}
SQLA_USERNAME = {{ include "call-nested" (list . "postgresql" "postgresql.username") | quote }}
SQLA_PASSWORD = {{ include "call-nested" (list . "postgresql" "postgresql.password") | quote }}
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

{{ $redis  := .Values.redis -}}
{{ if $redis.enabled -}}
from cachelib.redis import RedisCache
from celery.schedules import crontab

REDIS_HOST = '{{ printf "%s-master" (include "call-nested" (list . "redis" "redis.fullname")) }}'
REDIS_PORT = '{{ $redis.master.service.port }}'
{{ if $redis.usePassword -}}
REDIS_PASSWORD = '{{ include "call-nested" (list . "redis" "redis.password") }}'
{{- else -}}
REDIS_PASSWORD = None
{{- end }}
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
        'cache-warmup-hourly': {
            'task': 'cache-warmup',
            'schedule': crontab(minute=0, hour='*'),  # hourly
            'kwargs': {
                'strategy_name': 'top_n_dashboards',
                'top_n': 5,
                'since': '7 days ago',
            },
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

{{ if .Values.superset.extraSupersetConfig -}}
{{ tpl .Values.superset.extraSupersetConfig . }}
{{- end }}
