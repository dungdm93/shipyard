{{/*
AIO labels
*/}}
{{- define "mimir.aio.labels" -}}
{{ include "mimir.labels" . }}
app.kubernetes.io/component: all
{{- end -}}

{{/*
AIO selector labels
*/}}
{{- define "mimir.aio.selectorLabels" -}}
{{ include "mimir.selectorLabels" . }}
app.kubernetes.io/component: all
{{- end -}}
