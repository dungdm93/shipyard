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
Checksum pod annotations
*/}}
{{- define "airflow.checksum" -}}
checksum/airflow-config: {{ include (print $.Template.BasePath "/commons/airflow-config.yaml") . | sha256sum }}
{{- if eq .Values.dags.fetcher "git" }}
checksum/gitsync-config: {{ include (print $.Template.BasePath "/commons/gitsync-config.yaml") . | sha256sum }}
{{- if .Values.dags.git.auth.sshKey }}
checksum/gitsync-sshkey:  {{ include (print $.Template.BasePath "/commons/gitsync-sshkey.yaml") .  | sha256sum }}
{{- end }}
{{- end }}
{{- end -}}

{{/*
Get airflow dags folder
*/}}
{{- define "airflow.dags.folder" -}}
{{- if eq .fetcher "git" -}}
  {{- clean (printf "%s/repo/%s" .path .git.subPath) }}
{{- else -}}
  {{- .path }}
{{- end -}}
{{- end -}}

{{/*
git-sync sidecar container
*/}}
{{- define "airflow.gitsync.sidecar" -}}
{{- $gitsync := .Values.dags.git -}}
- name: git-sync
  image: "{{ $gitsync.image.repository }}:{{ $gitsync.image.tag }}"
  imagePullPolicy: IfNotPresent
  envFrom:
    - secretRef:
        name: {{ include "airflow.fullname" . }}-gitsync
  volumeMounts:
    - name: airflow-dags
      mountPath: /git
    {{- if or $gitsync.auth.sshKey $gitsync.auth.externalSshKeySecret.name }}
    - name: airflow-gitsync-sshkey
      mountPath: /etc/git-secret/ssh
      subPath:   gitSshKey
    {{- end }}
{{- end -}}

{{/*
git-sync init container
*/}}
{{- define "airflow.gitsync.init" -}}
{{- $gitsync := .Values.dags.git -}}
- name: git-sync-init
  image: "{{ $gitsync.image.repository }}:{{ $gitsync.image.tag }}"
  imagePullPolicy: IfNotPresent
  env:
    - name: GIT_SYNC_ONE_TIME
      value: "true"
  envFrom:
    - secretRef:
        name: {{ include "airflow.fullname" . }}-gitsync
  volumeMounts:
    - name: airflow-dags
      mountPath: /git
    {{- if or $gitsync.auth.sshKey $gitsync.auth.externalSshKeySecret.name }}
    - name: airflow-gitsync-sshkey
      mountPath: /etc/git-secret/ssh
      subPath:   gitSshKey
    {{- end }}
{{- end -}}

{{/*
log-groomer sidecar container
*/}}
{{- define "airflow.logGroomer.sidecar" -}}
{{- $logGroomer := .Values.logGroomer -}}
{{- if not $logGroomer.image }}
  {{- $_ := set $logGroomer "image" .Values.commons.image }}
{{- end }}
- name: log-groomer
  image: "{{ $logGroomer.image.repository }}:{{ $logGroomer.image.tag }}"
  imagePullPolicy: {{ .Values.imagePullPolicy }}
  {{- with $logGroomer.command }}
  command:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with $logGroomer.args }}
  args:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  volumeMounts:
    {{- include "airflow.volumeMounts" . | nindent 4 }}
  resources:
    {{- toYaml $logGroomer.resources | nindent 4 }}
  securityContext:
    {{- toYaml $logGroomer.securityContext | nindent 4 }}
{{- end -}}

{{/*
Airflow normalize executor
*/}}
{{- define "airflow.normalizeExecutor" -}}
{{- $executor := .Values.executor | lower | trimSuffix "executor" -}}
{{- $executor | title }}Executor
{{- end -}}

{{/*
Airflow database connection url
*/}}
{{- define "airflow.database" -}}
{{- if .Values.postgresql.enabled -}}
  {{- $pg := .Values.postgresql }}
  {{- $pgHost := include "call-nested" (list . "postgresql" "common.names.fullname") }}
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
  {{- $redisHost := include "call-nested" (list . "redis" "common.names.fullname") }}
  {{- if not $redis.sentinel.enabled -}}
    {{- $redisHost = printf "%s-master" $redisHost }}
  {{- end -}}
  {{- $redisPort := $redis.sentinel.enabled | ternary $redis.sentinel.service.ports.redis $redis.master.service.ports.redis }}
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
{{- define "call-nested" -}}
{{- $dot := index . 0 }}
{{- $subchart := index . 1 | splitList "." }}
{{- $template := index . 2 }}
{{- $values := $dot.Values }}
{{- range $subchart }}
{{- $values = index $values . }}
{{- end }}
{{- include $template (dict "Chart" (dict "Name" (last $subchart)) "Values" $values "Release" $dot.Release "Capabilities" $dot.Capabilities) }}
{{- end -}}

{{/*
Join a list with transformation
*/}}
{{- define "join-transform" -}}
{{- $sep := index . 0 }}
{{- $list := index . 1 }}
{{- $fields := index . 2 }}
{{- $res := list }}
{{- range $e := $list -}}
  {{- range $f := $fields | splitList "." -}}
    {{- if $f }}
      {{- $e = index $e $f }}
    {{- end }}
  {{- end -}}
  {{- $res = append $res $e }}
{{- end -}}
{{- join $sep $res }}
{{- end -}}

{{/*
Airflow volumeMounts
*/}}
{{- define "airflow.volumeMounts" -}}
- name: airflow-config
  mountPath: /opt/airflow/airflow.cfg
  subPath:   airflow.cfg
- name: airflow-config
  mountPath: /opt/airflow/config/airflow_local_settings.py
  subPath:   airflow_local_settings.py
- name: airflow-probes
  mountPath: /opt/airflow/scripts/

{{- if eq .Values.dags.fetcher "git" }}
- name: airflow-dags
  mountPath: {{ .Values.dags.path }}
{{- else if eq .Values.dags.fetcher "volume" }}
- name: airflow-dags
  mountPath: {{ .Values.dags.path }}
  {{- with .Values.dags.volume.subPath }}
  subPath: {{ . }}
  {{- end }}
{{- end }}

{{- $logs := .Values.logs }}
- name: airflow-logs
  mountPath: {{ $logs.baseLogFolder }}
  {{- if and (not $logs.remoteLogConnId) $logs.persistence.enabled $logs.persistence.subPath }}
  subPath: {{ $logs.persistence.subPath }}
  {{- end }}
{{- end -}}

{{/*
Airflow volumes
*/}}
{{- define "airflow.volumes" -}}
- name: airflow-config
  configMap:
    name: {{ include "airflow.fullname" . }}-config
- name: airflow-probes
  configMap:
    name: {{ include "airflow.fullname" . }}-probes

{{- $dags := .Values.dags -}}
{{- if eq $dags.fetcher "git" }}
- name: airflow-dags
  emptyDir: {}
{{- $gitsync := $dags.git -}}
{{- if $gitsync.auth.sshKey }}
- name: airflow-gitsync-sshkey
  secret:
    secretName: {{ include "airflow.fullname" . }}-gitsync-sshkey
{{- else if $gitsync.auth.externalSshKeySecret.name }}
- name: airflow-gitsync-sshkey
  secret:
    secretName:  {{ $gitsync.auth.externalSshKeySecret.name }}
    items:
    - key:  {{ $gitsync.auth.externalSshKeySecret.key | default "gitSshKey" }}
      path: gitSshKey
{{- end }}
{{- else if eq $dags.fetcher "volume" }}
- name: airflow-dags
  persistentVolumeClaim:
    claimName: {{ $dags.volume.existingClaim | default (printf "%s-dags" (include "airflow.fullname" .)) }}
{{- end }}

{{- $logs := .Values.logs }}
{{- if and (not $logs.remoteLogConnId) $logs.persistence.enabled }}
- name: airflow-logs
  persistentVolumeClaim:
    claimName: {{ $logs.persistence.existingClaim | default (printf "%s-logs" (include "airflow.fullname" .)) }}
{{- else if and (not $logs.remoteLogConnId) $logs.ephemeral.enabled }}
- name: airflow-logs
  ephemeral:
    volumeClaimTemplate:
      spec:
        accessModes:
        - {{ $logs.ephemeral.accessMode }}
        resources:
          requests:
            storage: {{ $logs.ephemeral.size }}
        storageClassName: {{ $logs.ephemeral.storageClass }}
{{- else }}
- name: airflow-logs
  emptyDir: {}
{{- end }}
{{- end -}}
