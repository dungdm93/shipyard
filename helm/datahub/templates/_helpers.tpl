{{/*
Expand the name of the chart.
*/}}
{{- define "datahub.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "datahub.fullname" -}}
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
{{- define "datahub.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "datahub.labels" -}}
helm.sh/chart: {{ include "datahub.chart" . }}
{{ include "datahub.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "datahub.selectorLabels" -}}
app.kubernetes.io/name: {{ include "datahub.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "datahub.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "datahub.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "datahub.setEnv" -}}
{{- $dict  := index . 0 }}
{{- $key   := index . 1 }}
{{- $value := index . 2 }}
{{- if not (kindIs "invalid" $value) }}
  {{- $_ := set $dict $key $value }}
{{- end }}
{{- end -}}

{{- define "datahub.setSecretEnv" -}}
{{- $dict  := index . 0 }}
{{- $key   := index . 1 }}
{{- $provided := index . 2 }}
{{- $secretData := index . 3 }}
{{- $defaultValue := index . 4 }}
{{- if $provided }}
  {{- $_ := set $dict $key $provided }}
{{- else }}
  {{- $existingData := get $secretData $key }}
  {{- if $existingData }}
    {{- $_ := set $dict $key ($existingData | b64dec) }}
  {{- else }}
    {{- $_ := set $dict $key $defaultValue }}
  {{- end }}
{{- end }}
{{- end -}}
