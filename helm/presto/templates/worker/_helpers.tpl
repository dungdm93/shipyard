{{/*
Worker labels
*/}}
{{- define "presto.worker.labels" -}}
{{ include "presto.labels" . }}
app.kubernetes.io/component: worker
{{- end -}}

{{/*
Worker selector labels
*/}}
{{- define "presto.worker.selectorLabels" -}}
{{ include "presto.selectorLabels" . }}
app.kubernetes.io/component: worker
{{- end -}}

{{/*
Worker volumes
*/}}
{{- define "presto.worker.volumes" -}}
- name: presto-config
  configMap:
    name: {{ include "presto.fullname" . }}-config
    items:
    - key:  worker-config.properties
      path: config.properties
{{ include "presto.volumes" . }}
{{- end -}}
