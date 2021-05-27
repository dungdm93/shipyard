{{/*
Router labels
*/}}
{{- define "druid.router.labels" -}}
{{ include "druid.labels" . }}
app.kubernetes.io/component: router
{{- end -}}

{{/*
Router selector labels
*/}}
{{- define "druid.router.selectorLabels" -}}
{{ include "druid.selectorLabels" . }}
app.kubernetes.io/component: router
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "druid.router.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ .Values.serviceAccount.name | default (include "druid.fullname" .) }}-router
{{- else -}}
    {{ .Values.serviceAccount.name | default "default" }}
{{- end -}}
{{- end -}}

{{/*
Router volumes
*/}}
{{- define "druid.router.volumes" -}}
{{- $router := mergeOverwrite (deepCopy .Values.commons) .Values.router -}}
{{ include "druid.volumes" . }}
- name: router-config
  configMap:
    name: {{ include "druid.fullname" . }}-router
{{- with $router.extraVolumes }}
{{ toYaml . }}
{{- end }}
{{- end -}}

{{/*
Router volumeMounts
*/}}
{{- define "druid.router.volumeMounts" -}}
{{- $router := mergeOverwrite (deepCopy .Values.commons) .Values.router -}}
{{ include "druid.volumeMounts" . }}
- name: router-config
  mountPath: /opt/druid/conf/druid/cluster/query/router
{{- with $router.extraVolumeMounts }}
{{ toYaml . }}
{{- end }}
{{- end -}}

{{/*
Checksum pod annotations
*/}}
{{- define "druid.router.checksum" -}}
{{ include "druid.checksum" . }}
checksum/router-config: {{ include (print $.Template.BasePath "/router/configmap.yaml") . | sha256sum }}
{{- end -}}
