{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "generic.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "generic.fullname" -}}
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
{{- define "generic.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "generic.labels" -}}
helm.sh/chart: {{ include "generic.chart" . }}
{{ include "generic.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "generic.selectorLabels" -}}
app.kubernetes.io/name: {{ include "generic.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "generic.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "generic.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{- define "generic.envSource" -}}
{{- if not .externalSource -}}
  {{- $mergeDict := dict -}}
  {{- if .configMapKeyRef }}
    {{- $mergeDict = dict "configMapKeyRef" (dict "name" (printf "%s-%s" .releaseName .configMapKeyRef.name)) -}}
  {{- else if .configMapRef }}
    {{- $mergeDict = dict "configMapRef"    (dict "name" (printf "%s-%s" .releaseName .configMapRef.name))    -}}
  {{- else if .secretKeyRef }}
    {{- $mergeDict = dict "secretKeyRef"    (dict "name" (printf "%s-%s" .releaseName .secretKeyRef.name))    -}}
  {{- else if .secretRef }}
    {{- $mergeDict = dict "secretRef"       (dict "name" (printf "%s-%s" .releaseName .secretRef.name))       -}}
  {{- end }}
  {{- $_ := mergeOverwrite . $mergeDict -}}
{{- end -}}
{{- $_ := unset . "externalSource" -}}
{{- $_ := unset . "releaseName" -}}
{{ . | toYaml }}
{{- end -}}

{{- define "generic.env" -}}
{{- $prefix := include "generic.fullname" . -}}
{{- range .Values.env }}
- name: {{ .name }}
  {{- if .value }}
  value: {{ .value | quote }}
  {{- else if .valueFrom }}
  {{- $src := mergeOverwrite .valueFrom (dict "releaseName" $prefix) }}
  valueFrom: {{- include "generic.envSource" $src | nindent 4 }}
  {{- end }}
{{- end }}
{{- end -}}

{{- define "generic.envFrom" -}}
{{- $prefix := include "generic.fullname" . -}}
{{- range .Values.envFrom }}
{{- $src := mergeOverwrite . (dict "releaseName" $prefix) }}
- {{- include "generic.envSource" $src | nindent 2 }}
{{- end }}
{{- end -}}

{{- define "generic.volumeSource" -}}
{{- if not .externalSource -}}
  {{- $mergeDict := dict -}}
  {{- if .configMap }}
    {{- $mergeDict = dict "configMap" (dict "name"       (printf "%s-%s" .releaseName .configMap.name))    -}}
  {{- else if .secret }}
    {{- $mergeDict = dict "secret"    (dict "secretName" (printf "%s-%s" .releaseName .secret.secretName)) -}}
  {{- end }}
  {{- $_ := mergeOverwrite . $mergeDict -}}
{{- end -}}
{{- $_ := unset . "externalSource" -}}
{{- $_ := unset . "releaseName" -}}
{{ . | toYaml }}
{{- end -}}

{{- define "generic.volumes" -}}
{{- $prefix := include "generic.fullname" . -}}
{{- range .Values.volumes }}
{{- $src := mergeOverwrite . (dict "releaseName" $prefix) }}
- {{- include "generic.volumeSource" $src | nindent 2 }}
{{- end }}
{{- end -}}
