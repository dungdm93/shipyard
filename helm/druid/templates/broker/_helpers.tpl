{{/*
Broker labels
*/}}
{{- define "druid.broker.labels" -}}
{{ include "druid.labels" . }}
app.kubernetes.io/component: broker
{{- end -}}

{{/*
Broker selector labels
*/}}
{{- define "druid.broker.selectorLabels" -}}
{{ include "druid.selectorLabels" . }}
app.kubernetes.io/component: broker
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "druid.broker.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ .Values.serviceAccount.name | default (include "druid.fullname" .) }}-broker
{{- else -}}
    {{ .Values.serviceAccount.name | default "default" }}
{{- end -}}
{{- end -}}

{{/*
Broker volumes
*/}}
{{- define "druid.broker.volumes" -}}
{{- $broker := mergeOverwrite (deepCopy .Values.commons) .Values.broker -}}
{{ include "druid.volumes" . }}
- name: broker-config
  configMap:
    name: {{ include "druid.fullname" . }}-broker
{{- with $broker.extraVolumes }}
{{ toYaml . }}
{{- end }}
{{- end -}}

{{/*
Broker volumeMounts
*/}}
{{- define "druid.broker.volumeMounts" -}}
{{- $broker := mergeOverwrite (deepCopy .Values.commons) .Values.broker -}}
{{ include "druid.volumeMounts" . }}
- name: broker-config
  mountPath: /opt/druid/conf/druid/cluster/query/broker
{{- with $broker.extraVolumeMounts }}
{{ toYaml . }}
{{- end }}
{{- end -}}

{{/*
Checksum pod annotations
*/}}
{{- define "druid.broker.checksum" -}}
{{ include "druid.checksum" . }}
checksum/broker-config: {{ include (print $.Template.BasePath "/broker/configmap.yaml") . | sha256sum }}
{{- end -}}
