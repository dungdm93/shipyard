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
Checksum pod annotations
*/}}
{{- define "hive.checksum" -}}
checksum/hive-config:   {{ include (print $.Template.BasePath "/configs/hive-config.yaml") .   | sha256sum }}
checksum/hadoop-config: {{ include (print $.Template.BasePath "/configs/hadoop-config.yaml") . | sha256sum }}
{{- end -}}

{{/*
Database driver mapping
*/}}
{{- define "hive.dbDriverMap" -}}
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
{{- define "hive.dbConnectionURL" -}}
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
