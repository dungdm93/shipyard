{{/*
Overlord labels
*/}}
{{- define "druid.overlord.labels" -}}
{{ include "druid.labels" . }}
app.kubernetes.io/component: overlord
{{- end -}}

{{/*
Overlord selector labels
*/}}
{{- define "druid.overlord.selectorLabels" -}}
{{ include "druid.selectorLabels" . }}
app.kubernetes.io/component: overlord
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "druid.overlord.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ .Values.serviceAccount.name | default (include "druid.fullname" .) }}-overlord
{{- else -}}
    {{ .Values.serviceAccount.name | default "default" }}
{{- end -}}
{{- end -}}

{{/*
Overlord volumes
*/}}
{{- define "druid.overlord.volumes" -}}
{{- $overlord := mergeOverwrite (deepCopy .Values.commons) .Values.overlord -}}
{{ include "druid.volumes" . }}
- name: overlord-config
  configMap:
    name: {{ include "druid.fullname" . }}-overlord
{{- with $overlord.extraVolumes }}
{{ toYaml . }}
{{- end }}
{{- end -}}

{{/*
Overlord volumeMounts
*/}}
{{- define "druid.overlord.volumeMounts" -}}
{{- $overlord := mergeOverwrite (deepCopy .Values.commons) .Values.overlord -}}
{{ include "druid.volumeMounts" . }}
- name: overlord-config
  mountPath: /opt/druid/conf/druid/cluster/master/coordinator-overlord
{{- with $overlord.extraVolumeMounts }}
{{ toYaml . }}
{{- end }}
{{- end -}}

{{/*
Checksum pod annotations
*/}}
{{- define "druid.overlord.checksum" -}}
{{ include "druid.checksum" . }}
checksum/overlord-config: {{ include (print $.Template.BasePath "/overlord/configmap.yaml") . | sha256sum }}
{{- end -}}
