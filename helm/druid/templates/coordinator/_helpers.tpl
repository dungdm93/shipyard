{{/*
Coordinator labels
*/}}
{{- define "druid.coordinator.labels" -}}
{{ include "druid.labels" . }}
app.kubernetes.io/component: coordinator
{{- end -}}

{{/*
Coordinator selector labels
*/}}
{{- define "druid.coordinator.selectorLabels" -}}
{{ include "druid.selectorLabels" . }}
app.kubernetes.io/component: coordinator
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "druid.coordinator.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ .Values.serviceAccount.name | default (include "druid.fullname" .) }}-coordinator
{{- else -}}
    {{ .Values.serviceAccount.name | default "default" }}
{{- end -}}
{{- end -}}

{{/*
Coordinator volumes
*/}}
{{- define "druid.coordinator.volumes" -}}
{{- $coordinator := mergeOverwrite (deepCopy .Values.commons) .Values.coordinator -}}
{{ include "druid.volumes" . }}
- name: coordinator-config
  configMap:
    name: {{ include "druid.fullname" . }}-coordinator
{{- with $coordinator.extraVolumes }}
{{ toYaml . }}
{{- end }}
{{- end -}}

{{/*
Coordinator volumeMounts
*/}}
{{- define "druid.coordinator.volumeMounts" -}}
{{- $coordinator := mergeOverwrite (deepCopy .Values.commons) .Values.coordinator -}}
{{ include "druid.volumeMounts" . }}
- name: coordinator-config
  mountPath: /opt/druid/conf/druid/cluster/master/coordinator-overlord
{{- with $coordinator.extraVolumeMounts }}
{{ toYaml . }}
{{- end }}
{{- end -}}

{{/*
Checksum pod annotations
*/}}
{{- define "druid.coordinator.checksum" -}}
{{ include "druid.checksum" . }}
checksum/coordinator-config: {{ include (print $.Template.BasePath "/coordinator/configmap.yaml") . | sha256sum }}
{{- end -}}
