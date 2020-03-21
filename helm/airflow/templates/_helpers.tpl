{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "airflow.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "airflow.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "airflow.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "airflow.labels" -}}
helm.sh/chart: {{ include "airflow.chart" . }}
{{ include "airflow.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "airflow.selectorLabels" -}}
app.kubernetes.io/name: {{ include "airflow.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "airflow.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "airflow.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Checksum pod annotations
*/}}
{{- define "airflow.checksum" -}}
{{- end -}}

{{/*
git-sync container
*/}}
{{- define "airflow.gitsync" -}}
- name: git-sync
  image: {{ .Values.dags.git.syncImage }}
  imagePullPolicy: IfNotPresent
  envFrom:
    - secretRef:
        name: {{ include "airflow.fullname" . }}-gitsync
  volumeMounts:
    - name: airflow-dags
      mountPath: {{ .Values.dags.path }}
{{- end -}}

{{/*
Airflow database connection url
*/}}
{{- define "airflow.database" -}}
{{- if .Values.postgresql.enabled -}}
  {{- $pg := .Values.postgresql }}
  {{- $pgHost := include "call-nested" (list . "postgresql" "postgresql.fullname") }}
  {{- printf "postgresql+psycopg2://%s:%s@%s:%s/%s" $pg.postgresqlUsername $pg.postgresqlPassword $pgHost (toString $pg.service.port) $pg.postgresqlDatabase -}}
{{- else -}}
  {{- .Values.externalDatabase }}
{{- end -}}
{{- end -}}

{{/*
Airflow celery broker connection url
*/}}
{{- define "airflow.celeryBroker" -}}
{{- if .Values.redis.enabled -}}
  {{- $redis := .Values.redis }}
  {{- $redisHost := include "call-nested" (list . "redis" "redis.fullname") }}
  {{- if not $redis.sentinel.enabled -}}
    {{- $redisHost = printf "%s-master" $redisHost }}
  {{- end -}}
  {{- $redisPort := $redis.sentinel.enabled | ternary $redis.sentinel.service.redisPort $redis.master.service.port }}
  {{- $redisAuthority := (empty $redis.password) | ternary "" (printf ":%s@" $redis.password) }}
  {{- printf "redis://%s%s:%s/0" $redisAuthority $redisHost (toString $redisPort) -}}
{{- else -}}
  {{- .Values.externalCeleryBroker }}
{{- end -}}
{{- end -}}

{{/*
Airflow celery broker connection url
*/}}
{{- define "airflow.celeryResultBackend" -}}
  {{- $dbUrlParts := urlParse (include "airflow.database" .) }}
  {{- $scheme := regexReplaceAll "(\\w+)(\\+\\w+)?" $dbUrlParts.scheme "db+${1}" }}
  {{- $_ := set $dbUrlParts "scheme" $scheme }}
  {{- urlJoin $dbUrlParts }}
{{- end -}}

{{/*
Execute a template in a subchart:
https://github.com/helm/helm/issues/4535#issuecomment-477778391
https://stackoverflow.com/a/52024583
*/}}
{{- define "call-nested" }}
{{- $dot := index . 0 }}
{{- $subchart := index . 1 | splitList "." }}
{{- $template := index . 2 }}
{{- $values := $dot.Values }}
{{- range $subchart }}
{{- $values = index $values . }}
{{- end }}
{{- include $template (dict "Chart" (dict "Name" (last $subchart)) "Values" $values "Release" $dot.Release "Capabilities" $dot.Capabilities) }}
{{- end }}

{{/*
Airflow volumeMounts
*/}}
{{- define "airflow.volumeMounts" -}}
- name: airflow-config
  mountPath: /opt/airflow/airflow.cfg
  subPath:   airflow.cfg
{{- if list "git" "mount" | has .Values.dags.fetcher }}
- name: airflow-dags
  mountPath: {{ .Values.dags.path }}
{{- end }}
{{- $logsUrl := urlParse .Values.logs.path }}
{{- if and (or (not $logsUrl.scheme) (eq $logsUrl.scheme "file")) .Values.logs.persistence.enabled }}
- name: airflow-logs
  mountPath: {{ $logsUrl.path }}
  {{- with .Values.logs.persistence.subPath }}
  subPath: {{ . }}
  {{- end }}
  {{- with .Values.logs.persistence.subPathExpr }}
  subPathExpr: {{ . }}
  {{- end }}
{{- end }}
{{- end -}}

{{/*
Airflow volumes
*/}}
{{- define "airflow.volumes" -}}
- name: airflow-config
  configMap:
    name: {{ include "airflow.fullname" . }}-configs
{{- if list "git" "mount" | has .Values.dags.fetcher }}
- name: airflow-dags
  emptyDir: {}
  # TODO implement
{{- end }}
{{- $logsUrl := urlParse .Values.logs.path }}
{{- if and (or (not $logsUrl.scheme) (eq $logsUrl.scheme "file")) .Values.logs.persistence.enabled }}
- name: airflow-logs
  emptyDir: {}
{{- end }}
{{- end -}}
