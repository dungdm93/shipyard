{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "presto.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "presto.fullname" -}}
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
{{- define "presto.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "presto.labels" -}}
helm.sh/chart: {{ include "presto.chart" . }}
{{ include "presto.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "presto.selectorLabels" -}}
app.kubernetes.io/name: {{ include "presto.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "presto.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "presto.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Presto volumeMounts
*/}}
{{- define "presto.volumeMounts" -}}
- name: presto-config
  mountPath: /etc/presto/config.properties
  subPath: config.properties
- name: presto-properties
  mountPath: /etc/presto
- name: presto-catalog
  mountPath: /etc/presto/catalog
{{- end -}}

{{/*
Presto volumes
*/}}
{{- define "presto.volumes" -}}
- name: presto-properties
  configMap:
    name: {{ include "presto.fullname" . }}-properties
- name: presto-catalog
  configMap:
    name: {{ include "presto.fullname" . }}-catalog
{{- end -}}

{{/*
Checksum pod annotations
*/}}
{{- define "presto.checksum" -}}
checksum/presto-properties: {{ include (print $.Template.BasePath "/commons/presto-properties.yaml") . | sha256sum }}
checksum/presto-config:     {{ include (print $.Template.BasePath "/commons/presto-config.yaml") .     | sha256sum }}
checksum/presto-catalog:    {{ include (print $.Template.BasePath "/commons/presto-catalog.yaml") .    | sha256sum }}
{{- end -}}

{{/*
Remove entry with empty value from dict
*/}}
{{- define "dict.cleanup" -}}
{{- $dict := . }}
{{- range $k, $v := $dict -}}
  {{- if not $v -}}
    {{- $_ := unset $dict $k }}
  {{- end -}}
{{- end -}}
{{- end -}}
