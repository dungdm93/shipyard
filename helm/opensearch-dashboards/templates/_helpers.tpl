{{/*
Expand the name of the chart.
*/}}
{{- define "opensearch-dashboards.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "opensearch-dashboards.fullname" -}}
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
{{- define "opensearch-dashboards.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "opensearch-dashboards.labels" -}}
helm.sh/chart: {{ include "opensearch-dashboards.chart" . }}
{{ include "opensearch-dashboards.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "opensearch-dashboards.selectorLabels" -}}
app.kubernetes.io/name: {{ include "opensearch-dashboards.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "opensearch-dashboards.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "opensearch-dashboards.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Checksum pod annotations
*/}}
{{- define "opensearch-dashboards.checksum" -}}
checksum/opensearch-dashboards-config: {{ include (print $.Template.BasePath "/configmap.yaml") . | sha256sum }}
{{- end -}}

{{/*
OpenSearch Dashboards volumeMounts
*/}}
{{- define "opensearch-dashboards.volumeMounts" -}}
- name: config
  mountPath: /etc/opensearch-dashboards
{{- with .Values.nodeOptions }}
- name: config
  mountPath: /usr/share/opensearch-dashboards/config/node.options
  subPath: node.options
{{- end }}
{{- end -}}

{{/*
OpenSearch Dashboards volumes
*/}}
{{- define "opensearch-dashboards.volumes" -}}
- name: config
  configMap:
    name: {{ include "opensearch-dashboards.fullname" . }}-config
{{- end -}}


{{- define "opensearch-dashboards.flattenConfig" -}}
{{- $config := index . 0 -}}
{{- $key := index . 1 -}}
{{- $dict := index . 2 -}}
{{- range $k, $v := $dict }}
  {{- if kindIs "map" $v }}
    {{- include "opensearch-dashboards.flattenConfig" (list $config (printf "%s.%s" $key $k) $v) }}
  {{- else }}
    {{- $_ := set $config (printf "%s.%s" $key $k) $v }}
  {{- end }}
{{- end }}
{{- end -}}
