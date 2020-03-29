{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "hive-metastore.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "hive-metastore.fullname" -}}
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
{{- define "hive-metastore.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "hive-metastore.labels" -}}
helm.sh/chart: {{ include "hive-metastore.chart" . }}
{{ include "hive-metastore.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "hive-metastore.selectorLabels" -}}
app.kubernetes.io/name: {{ include "hive-metastore.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "hive-metastore.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "hive-metastore.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Checksum pod annotations
*/}}
{{- define "hive-metastore.checksum" -}}
checksum/hive-config:   {{ include (print $.Template.BasePath "/hive-config.yaml") .   | sha256sum }}
checksum/hadoop-config: {{ include (print $.Template.BasePath "/hadoop-config.yaml") . | sha256sum }}
{{- end -}}

{{/*
Database driver mapping
*/}}
{{- define "hive-metastore.dbDriverMap" -}}
postgres: org.postgresql.Driver
mysql:    com.mysql.cj.jdbc.Driver
// mysql-8:  com.mysql.cj.jdbc.Driver
// mysql-5:  com.mysql.jdbc.Driver
mssql:    com.microsoft.sqlserver.jdbc.SQLServerDriver
oracle:   oracle.jdbc.OracleDriver
{{- end -}}

{{/*
Database connection URL
*/}}
{{- define "hive-metastore.dbConnectionURL" -}}
{{- if .url -}}
{{ .url }}
{{- else if eq .type "postgres" -}}
jdbc:postgresql://{{.host}}:{{.port | default 5432}}/{{.database}}
{{- else if eq .type "mysql" -}}
jdbc:mysql://{{.host}}:{{.port | default 3306}}/{{.database}}
{{- else if eq .type "mssql" -}}
jdbc:sqlserver://{{.host}}:{{.port | default 1433}};databaseName={{.database}}
{{- else if eq .type "oracle" -}}
jdbc:oracle:thin://{{.host}}:{{.port | default 1521}}/{{.database}}
{{- else }}
{{- fail (printf "unknow db type %s, use .url instead" .type) }}
{{- end -}}
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
