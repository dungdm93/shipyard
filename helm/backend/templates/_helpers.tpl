{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "backend.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "backend.fullname" -}}
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
{{- define "backend.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "backend.labels" -}}
helm.sh/chart: {{ include "backend.chart" . }}
{{ include "backend.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "backend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "backend.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "backend.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "backend.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{- define "backend.envSource" -}}
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

{{- define "backend.env" -}}
{{- $prefix := include "backend.fullname" . -}}
{{- range .Values.env }}
- name: {{ .name }}
  {{- if .value }}
  value: {{ .value | quote }}
  {{- else if .valueFrom }}
  {{- $src := mergeOverwrite .valueFrom (dict "releaseName" $prefix) }}
  valueFrom: {{- include "backend.envSource" $src | nindent 4 }}
  {{- end }}
{{- end }}
{{- end -}}

{{- define "backend.envFrom" -}}
{{- $prefix := include "backend.fullname" . -}}
{{- range .Values.envFrom }}
{{- $src := mergeOverwrite . (dict "releaseName" $prefix) }}
- {{- include "backend.envSource" $src | nindent 2 }}
{{- end }}
{{- end -}}

{{- define "backend.volumeSource" -}}
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

{{- define "backend.volumes" -}}
{{- $prefix := include "backend.fullname" . -}}
{{- range .Values.volumes }}
{{- $src := mergeOverwrite . (dict "releaseName" $prefix) }}
- {{- include "backend.volumeSource" $src | nindent 2 }}
{{- end }}
{{- end -}}
