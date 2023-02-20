{{/*
Write labels
*/}}
{{- define "mimir.write.labels" -}}
{{ include "mimir.labels" . }}
app.kubernetes.io/component: write
{{- end -}}

{{/*
Write selector labels
*/}}
{{- define "mimir.write.selectorLabels" -}}
{{ include "mimir.selectorLabels" . }}
app.kubernetes.io/component: write
{{- end -}}
