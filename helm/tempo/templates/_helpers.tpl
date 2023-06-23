{{/*
Expand the name of the chart.
*/}}
{{- define "tempo.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "tempo.fullname" -}}
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
{{- define "tempo.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "tempo.labels" -}}
helm.sh/chart: {{ include "tempo.chart" . }}
{{ include "tempo.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "tempo.selectorLabels" -}}
app.kubernetes.io/name: {{ include "tempo.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "tempo.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "tempo.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Docker image name
*/}}
{{- define "tempo.image" -}}
{{ .Values.image.repository }}:{{ .Values.image.tag }}
{{- end -}}

{{/*
Checksum pod annotations
*/}}
{{- define "tempo.checksum" -}}
checksum/tempo-config: {{ include (print $.Template.BasePath "/configmap.yaml") . | sha256sum }}
{{- end -}}

{{/*
Tempo volumeMounts
*/}}
{{- define "tempo.volumeMounts" -}}
- name: tempo-config
  mountPath: /etc/tempo/
{{- end -}}

{{/*
Tempo volumes
*/}}
{{- define "tempo.volumes" -}}
- name: tempo-config
  configMap:
    name: {{ include "tempo.fullname" . }}-config
{{- end -}}

{{/*
Tempo config protocol
*/}}
{{- define "tempo.configProtocol" -}}
{{- $envelope := index . 0 }}
{{- $name  := index . 1 }}
{{- $protocol := get $envelope $name }}
{{- if $protocol.enabled }}
  {{- $_ := unset $protocol "enabled" }}
  {{- $_ := set   $protocol "endpoint" (printf ":%d" ($protocol.port | int)) }}
  {{- $_ := unset $protocol "port" }}
{{- else }}
  {{- $_ := unset $envelope $name }}
{{- end }}
{{- end -}}

{{/*
Tempo config endpoint
*/}}
{{- define "tempo.configReceiver" -}}
{{- $envelope := index . 0 }}
{{- $name  := index . 1 }}
{{- $receiver := get $envelope $name }}
{{- if $receiver.enabled }}
  {{- $_ := unset $receiver "enabled" }}

  {{- if hasKey $receiver "protocols" }}
    {{- range $proto := keys $receiver.protocols }}
      {{- $_ := include "tempo.configProtocol" (list $receiver.protocols $proto) }}
    {{- end }}
  {{- end }}

  {{- if hasKey $receiver "port" }}
    {{- $_ := set   $receiver "endpoint" (printf ":%d" ($receiver.port | int)) }}
    {{- $_ := unset $receiver "port" }}
  {{- end }}
{{- else }}
  {{- $_ := unset $envelope $name }}
{{- end }}
{{- end -}}
