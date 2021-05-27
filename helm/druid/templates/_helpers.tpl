{{/*
Expand the name of the chart.
*/}}
{{- define "druid.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "druid.fullname" -}}
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
{{- define "druid.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "druid.labels" -}}
helm.sh/chart: {{ include "druid.chart" . }}
{{ include "druid.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "druid.selectorLabels" -}}
app.kubernetes.io/name: {{ include "druid.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "druid.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "druid.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Common volumes
*/}}
{{- define "druid.volumes" -}}
- name: common-config
  configMap:
    name: {{ include "druid.fullname" . }}-common
{{- end -}}

{{/*
Commons volumeMounts
*/}}
{{- define "druid.volumeMounts" -}}
- name: common-config
  mountPath: /opt/druid/conf/druid/cluster/_common
{{- end -}}

{{/*
Container image
*/}}
{{- define "druid.image" -}}
{{- .Values.image.repository -}}:{{- .Values.image.tag -}}
{{- end }}

{{/*
Checksum pod annotations
*/}}
{{- define "druid.checksum" -}}
checksum/common-config: {{ include (print $.Template.BasePath "/common/configmap.yaml") . | sha256sum }}
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
