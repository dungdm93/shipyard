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
