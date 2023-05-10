{{/*
AIO labels
*/}}
{{- define "loki.aio.labels" -}}
{{ include "loki.labels" . }}
app.kubernetes.io/component: all
{{- end -}}

{{/*
AIO selector labels
*/}}
{{- define "loki.aio.selectorLabels" -}}
{{ include "loki.selectorLabels" . }}
app.kubernetes.io/component: all
{{- end -}}
