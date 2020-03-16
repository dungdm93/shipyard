{{/*
Coordinator labels
*/}}
{{- define "presto.coordinator.labels" -}}
{{ include "presto.labels" . }}
app.kubernetes.io/component: coordinator
{{- end -}}

{{/*
Coordinator selector labels
*/}}
{{- define "presto.coordinator.selectorLabels" -}}
{{ include "presto.selectorLabels" . }}
app.kubernetes.io/component: coordinator
{{- end -}}
