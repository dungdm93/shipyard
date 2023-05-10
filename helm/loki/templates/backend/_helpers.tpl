{{/*
Backend labels
*/}}
{{- define "loki.backend.labels" -}}
{{ include "loki.labels" . }}
app.kubernetes.io/component: backend
{{- end -}}

{{/*
Backend selector labels
*/}}
{{- define "loki.backend.selectorLabels" -}}
{{ include "loki.selectorLabels" . }}
app.kubernetes.io/component: backend
{{- end -}}
