{{/*
Expand the name of the chart.
*/}}
{{- define "opensearch.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "opensearch.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "opensearch.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "opensearch.labels" -}}
helm.sh/chart: {{ include "opensearch.chart" . }}
{{ include "opensearch.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "opensearch.selectorLabels" -}}
app.kubernetes.io/name: {{ include "opensearch.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "opensearch.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "opensearch.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Docker image name
*/}}
{{- define "opensearch.image" -}}
{{ .Values.image.repository }}:{{ .Values.image.tag }}
{{- end -}}

{{/*
Checksum pod annotations
*/}}
{{- define "opensearch.checksum" -}}
checksum/opensearch-config: {{ include (print $.Template.BasePath "/configmap.yaml") . | sha256sum }}
checksum/opensearch-config-security: {{ include (print $.Template.BasePath "/configmap-security.yaml") . | sha256sum }}
{{- end -}}

{{/*
OpenSearch volumeMounts
*/}}
{{- define "opensearch.volumeMounts" -}}
{{- $nodeGroup := index . 0 -}}
{{- $ := index . 1 -}}
- name: data
  mountPath: /usr/share/opensearch/data
- name: config
  mountPath: /usr/share/opensearch/config/opensearch.yml
  subPath: opensearch.yml
- name: config
  mountPath: /usr/share/opensearch/config/jvm.options
  subPath: jvm.options
- name: config-security
  mountPath: /usr/share/opensearch/config/opensearch-security
- name: ssl-transport
  mountPath: /usr/share/opensearch/config/ssl-transport
{{- if $.Values.security.ssl.http.enabled }}
- name: ssl-http
  mountPath: /usr/share/opensearch/config/ssl-http
- name: ssl-admin
  mountPath: /usr/share/opensearch/config/ssl-admin
{{- end }}
{{- end -}}

{{/*
OpenSearch volumes
*/}}
{{- define "opensearch.volumes" -}}
{{- $nodeGroup := index . 0 -}}
{{- $ := index . 1 -}}
{{- $persistence := $nodeGroup.persistence -}}
{{- if not $persistence.enabled }}
- name: data
  emptyDir: {}
{{- end }}
- name: config
  configMap:
    name: {{ include "opensearch.fullname" $ }}-config
- name: config-security
  configMap:
    name: {{ include "opensearch.fullname" $ }}-config-security
- name: ssl-transport
  secret:
    secretName: {{ include "opensearch.fullname" $ }}-ssl-transport
{{- if $.Values.security.ssl.http.enabled }}
- name: ssl-http
  secret:
    secretName: {{ include "opensearch.fullname" $ }}-ssl-http
- name: ssl-admin
  secret:
    secretName: {{ include "opensearch.fullname" $ }}-ssl-admin
{{- end }}
{{- end -}}
