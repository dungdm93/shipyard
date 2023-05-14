{{/*
AIO labels
*/}}
{{- define "tempo.aio.labels" -}}
{{ include "tempo.labels" . }}
app.kubernetes.io/component: all
{{- end -}}

{{/*
AIO selector labels
*/}}
{{- define "tempo.aio.selectorLabels" -}}
{{ include "tempo.selectorLabels" . }}
app.kubernetes.io/component: all
{{- end -}}
