{{/*
MiddleManager labels
*/}}
{{- define "druid.middlemanager.labels" -}}
{{ include "druid.labels" . }}
app.kubernetes.io/component: middlemanager
{{- end -}}

{{/*
MiddleManager selector labels
*/}}
{{- define "druid.middlemanager.selectorLabels" -}}
{{ include "druid.selectorLabels" . }}
app.kubernetes.io/component: middlemanager
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "druid.middlemanager.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ .Values.serviceAccount.name | default (include "druid.fullname" .) }}-middlemanager
{{- else -}}
    {{ .Values.serviceAccount.name | default "default" }}
{{- end -}}
{{- end -}}

{{/*
MiddleManager volumes
*/}}
{{- define "druid.middlemanager.volumes" -}}
{{- $middleManager := mergeOverwrite (deepCopy .Values.commons) .Values.middleManager -}}
{{ include "druid.volumes" . }}
- name: middlemanager-config
  configMap:
    name: {{ include "druid.fullname" . }}-middlemanager
{{- with $middleManager.extraVolumes }}
{{ toYaml . }}
{{- end }}
{{- end -}}

{{/*
MiddleManager volumeMounts
*/}}
{{- define "druid.middlemanager.volumeMounts" -}}
{{- $middleManager := mergeOverwrite (deepCopy .Values.commons) .Values.middleManager -}}
{{ include "druid.volumeMounts" . }}
- name: middlemanager-config
  mountPath: /opt/druid/conf/druid/cluster/data/middleManager
{{- $persistence := $middleManager.persistence }}
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
{{- with $middleManager.extraVolumeMounts }}
{{ toYaml . }}
{{- end }}
{{- end -}}

{{/*
Checksum pod annotations
*/}}
{{- define "druid.middlemanager.checksum" -}}
{{ include "druid.checksum" . }}
checksum/middlemanager-config: {{ include (print $.Template.BasePath "/middlemanager/configmap.yaml") . | sha256sum }}
{{- end -}}
