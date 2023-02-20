{{/*
Backend labels
*/}}
{{- define "mimir.backend.labels" -}}
{{ include "mimir.labels" . }}
app.kubernetes.io/component: backend
{{- end -}}

{{/*
Backend selector labels
*/}}
{{- define "mimir.backend.selectorLabels" -}}
{{ include "mimir.selectorLabels" . }}
app.kubernetes.io/component: backend
{{- end -}}
