{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "superset.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "superset.fullname" -}}
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
{{- define "superset.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "superset.labels" -}}
helm.sh/chart: {{ include "superset.chart" . }}
{{ include "superset.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "superset.selectorLabels" -}}
app.kubernetes.io/name: {{ include "superset.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Checksum pod annotations
*/}}
{{- define "superset.checksum" -}}
checksum/superset-config: {{ include (print $.Template.BasePath "/commons/superset-config.yaml") . | sha256sum }}
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
Superset env
*/}}
{{- define "superset.env" -}}
- name: SUPERSET_CONFIG_PATH
  value: /etc/superset/superset_config.py
- name: GUNICORN_CONFIG_PATH
  value: /etc/superset/gunicorn.conf.py
- name: CELERY_CONFIG_PATH
  value: /etc/superset/celeryconfig.py
{{- end -}}

{{/*
Superset volumeMounts
*/}}
{{- define "superset.volumeMounts" -}}
- name: superset-config
  mountPath: /etc/superset/
{{- end -}}

{{/*
Superset volumes
*/}}
{{- define "superset.volumes" -}}
- name: superset-config
  configMap:
    name: {{ include "superset.fullname" . }}-config
{{- end -}}
