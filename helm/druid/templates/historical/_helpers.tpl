{{/*
Historical labels
*/}}
{{- define "druid.historical.labels" -}}
{{ include "druid.labels" . }}
app.kubernetes.io/component: historical
{{- end -}}

{{/*
Historical selector labels
*/}}
{{- define "druid.historical.selectorLabels" -}}
{{ include "druid.selectorLabels" . }}
app.kubernetes.io/component: historical
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "druid.historical.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ .Values.serviceAccount.name | default (include "druid.fullname" .) }}-historical
{{- else -}}
    {{ .Values.serviceAccount.name | default "default" }}
{{- end -}}
{{- end -}}

{{/*
Historical volumes
*/}}
{{- define "druid.historical.volumes" -}}
{{- $historical := mergeOverwrite (deepCopy .Values.commons) .Values.historical -}}
{{ include "druid.volumes" . }}
- name: historical-config
  configMap:
    name: {{ include "druid.fullname" . }}-historical
{{- with $historical.extraVolumes }}
{{ toYaml . }}
{{- end }}
{{- end -}}

{{/*
Historical volumeMounts
*/}}
{{- define "druid.historical.volumeMounts" -}}
{{- $historical := mergeOverwrite (deepCopy .Values.commons) .Values.historical -}}
{{ include "druid.volumeMounts" . }}
- name: historical-config
  mountPath: /opt/druid/conf/druid/cluster/data/historical
{{- $persistence := $historical.persistence }}
{{- if $persistence.enabled }}
- name: data
  mountPath: {{ $persistence.mountPath }}
  {{- if $persistence.subPath }}
  subPath: {{ $persistence.subPath }}
  {{- end }}
  {{- if $persistence.subPathExpr }}
  subPathExpr: {{ $persistence.subPathExpr }}
  {{- end }}
{{- end }}
{{- with $historical.extraVolumeMounts }}
{{ toYaml . }}
{{- end }}
{{- end -}}

{{/*
Checksum pod annotations
*/}}
{{- define "druid.historical.checksum" -}}
{{ include "druid.checksum" . }}
checksum/historical-config: {{ include (print $.Template.BasePath "/historical/configmap.yaml") . | sha256sum }}
{{- end -}}
