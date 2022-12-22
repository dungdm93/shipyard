{{/*
Read labels
*/}}
{{- define "loki.read.labels" -}}
{{ include "loki.labels" . }}
app.kubernetes.io/component: read
{{- end -}}

{{/*
Read selector labels
*/}}
{{- define "loki.read.selectorLabels" -}}
{{ include "loki.selectorLabels" . }}
app.kubernetes.io/component: read
{{- end -}}
