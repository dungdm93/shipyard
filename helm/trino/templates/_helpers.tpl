{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "trino.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "trino.fullname" -}}
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
{{- define "trino.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "trino.labels" -}}
helm.sh/chart: {{ include "trino.chart" . }}
{{ include "trino.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "trino.selectorLabels" -}}
app.kubernetes.io/name: {{ include "trino.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "trino.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "trino.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Checksum pod annotations
*/}}
{{- define "trino.checksum" -}}
checksum/trino-properties: {{ include (print $.Template.BasePath "/commons/trino-properties.yaml") . | sha256sum }}
checksum/trino-config:     {{ include (print $.Template.BasePath "/commons/trino-config.yaml") .     | sha256sum }}
checksum/trino-catalog:    {{ include (print $.Template.BasePath "/commons/trino-catalog.yaml") .    | sha256sum }}
checksum/trino-monitor:    {{ include (print $.Template.BasePath "/commons/trino-monitor.yaml") .    | sha256sum }}
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


{{- define "trino.initContainers.jmxAgents" -}}
- name: jmx-agent
  image: "bitnami/jmx-exporter:0.16.1"
  imagePullPolicy: IfNotPresent
  command:
    - cp
    - /opt/bitnami/jmx-exporter/jmx_prometheus_javaagent.jar
    - /jmx-exporter/jmx_prometheus_javaagent.jar
  volumeMounts:
    - name: jmx-exporter
      mountPath: /jmx-exporter
{{- end -}}

{{- define "trino.initContainer.cacheDirCreator" -}}
- name: cache-dir-creator
  image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
  imagePullPolicy: {{ .Values.image.pullPolicy }}
  command:
    - bash
    - /etc/trino/scripts/mkcachedir.sh
  volumeMounts:
    - name: cache
      mountPath: /opt/trino/cache
    - name: trino-scripts
      mountPath: /etc/trino/scripts
    - name: trino-catalog
      mountPath: /etc/trino/catalog
{{- end -}}

{{- define "trino.jmxMounts" -}}
- name: jmx-exporter
  mountPath: /jmx-exporter
- name: trino-metrics
  mountPath: /jmx-exporter/trino-metrics.yaml
  subPath:   trino-metrics.yaml
{{- end -}}
