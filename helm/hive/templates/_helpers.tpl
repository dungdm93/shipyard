{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "hive.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "hive.fullname" -}}
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
{{- define "hive.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "hive.labels" -}}
helm.sh/chart: {{ include "hive.chart" . }}
{{ include "hive.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "hive.selectorLabels" -}}
app.kubernetes.io/name: {{ include "hive.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "hive.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "hive.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Hive volumeMounts
*/}}
{{- define "hive.volumeMounts" -}}
- name: hadoop-config
  mountPath: {{ .Values.hadoopConfig.path }}
- name: hive-config
  mountPath: {{ .Values.hiveConfig.path }}
- name: hive-scripts
  mountPath: /usr/local/scripts/
{{- if .Values.metrics.enabled }}
- name: jmx-exporter
  mountPath: /jmx-exporter
- name: hive-metrics
  mountPath: /jmx-exporter/conf
{{- end }}
{{- end -}}

{{/*
Hive volumes
*/}}
{{- define "hive.volumes" -}}
- name: hadoop-config
  configMap:
    name: {{ include "hive.fullname" . }}-hadoop-config
- name: hive-config
  configMap:
    name: {{ include "hive.fullname" . }}-hive-config
- name: hive-scripts
  configMap:
    name: {{ include "hive.fullname" . }}-hive-scripts
    defaultMode: 0755
{{- if .Values.metrics.enabled }}
- name: jmx-exporter
  emptyDir: {}
- name: hive-metrics
  configMap:
    name: {{ include "hive.fullname" . }}-metrics
{{- end -}}
{{- end -}}

{{/*
Checksum pod annotations
*/}}
{{- define "hive.checksum" -}}
checksum/hadoop-config: {{ include (print $.Template.BasePath "/configs/hadoop-config.yaml") . | sha256sum }}
checksum/hive-config:   {{ include (print $.Template.BasePath "/configs/hive-config.yaml") .   | sha256sum }}
checksum/hive-env:      {{ include (print $.Template.BasePath "/configs/hive-env.yaml") .      | sha256sum }}
checksum/hive-scripts:  {{ include (print $.Template.BasePath "/configs/hive-scripts.yaml") .  | sha256sum }}
{{- end -}}

{{/*
Hadoop optional tools mapping
*/}}
{{- define "hive.hdToolMap" -}}
s3a:   hadoop-aws
wasb:  hadoop-azure
adl:   hadoop-azure-datalake
swift: hadoop-openstack
oss:   hadoop-aliyun
{{- end -}}

{{/*
Database driver mapping
*/}}
{{- define "hive.dbDriverMap" -}}
postgres: org.postgresql.Driver
mysql:    com.mysql.cj.jdbc.Driver
# mysql-8:  com.mysql.cj.jdbc.Driver
# mysql-5:  com.mysql.jdbc.Driver
mssql:    com.microsoft.sqlserver.jdbc.SQLServerDriver
oracle:   oracle.jdbc.OracleDriver
{{- end -}}

{{/*
Database port mapping
*/}}
{{- define "hive.dbPortMap" -}}
postgres: 5432
mysql:    3306
mssql:    1433
oracle:   1521
{{- end -}}

{{/*
Database connection URL
*/}}
{{- define "hive.dbConnectionURL" -}}
{{- $dbPortMap := include "hive.dbPortMap" . | fromYaml }}
{{- if .url -}}
{{ .url }}
{{- else if eq .type "postgres" -}}
jdbc:postgresql://{{.host}}:{{.port | default (index $dbPortMap .type)}}/{{.database}}
{{- else if eq .type "mysql" -}}
jdbc:mysql://{{.host}}:{{.port | default (index $dbPortMap .type)}}/{{.database}}
{{- else if eq .type "mssql" -}}
jdbc:sqlserver://{{.host}}:{{.port | default (index $dbPortMap .type)}};databaseName={{.database}}
{{- else if eq .type "oracle" -}}
jdbc:oracle:thin://{{.host}}:{{.port | default (index $dbPortMap .type)}}/{{.database}}
{{- else }}
{{- fail (printf "unknow db type %s, use .url instead" .type) }}
{{- end -}}
{{- end -}}

{{/*
Remove empty-value entry from dict
*/}}
{{- define "dict-cleanup" -}}
{{- $dict := . }}
{{- range $k, $v := $dict -}}
  {{- if not $v -}}
    {{- $_ := unset $dict $k }}
  {{- end -}}
{{- end -}}
{{- end -}}

{{- define "hive.initContainers.jmxAgents" -}}
- name: jmx-agent
  image: "bitnami/jmx-exporter:0.17.0"
  imagePullPolicy: IfNotPresent
  command:
    - cp
    - /opt/bitnami/jmx-exporter/jmx_prometheus_javaagent.jar
    - /jmx-exporter/jmx_prometheus_javaagent.jar
  volumeMounts:
    - name: jmx-exporter
      mountPath: /jmx-exporter
{{- end -}}
