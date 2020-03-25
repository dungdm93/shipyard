{{/*
Coordinator labels
*/}}
{{- define "presto.coordinator.labels" -}}
{{ include "presto.labels" . }}
app.kubernetes.io/component: coordinator
{{- end -}}

{{/*
Coordinator selector labels
*/}}
{{- define "presto.coordinator.selectorLabels" -}}
{{ include "presto.selectorLabels" . }}
app.kubernetes.io/component: coordinator
{{- end -}}

{{/*
Coordinator volumes
*/}}
{{- define "presto.coordinator.volumes" -}}
- name: presto-config
  configMap:
    name: {{ include "presto.fullname" . }}-config
    items:
    - key:  coordinator-config.properties
      path: config.properties
{{ include "presto.volumes" . }}
{{- end -}}
