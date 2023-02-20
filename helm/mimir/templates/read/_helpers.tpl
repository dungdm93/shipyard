{{/*
Read labels
*/}}
{{- define "mimir.read.labels" -}}
{{ include "mimir.labels" . }}
app.kubernetes.io/component: read
{{- end -}}

{{/*
Read selector labels
*/}}
{{- define "mimir.read.selectorLabels" -}}
{{ include "mimir.selectorLabels" . }}
app.kubernetes.io/component: read
{{- end -}}
