{{/*
Write labels
*/}}
{{- define "loki.write.labels" -}}
{{ include "loki.labels" . }}
app.kubernetes.io/component: write
{{- end -}}

{{/*
Write selector labels
*/}}
{{- define "loki.write.selectorLabels" -}}
{{ include "loki.selectorLabels" . }}
app.kubernetes.io/component: write
{{- end -}}
