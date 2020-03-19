{{/*
Worker labels
*/}}
{{- define "airflow.worker.labels" -}}
{{ include "airflow.labels" . }}
app.kubernetes.io/component: worker
{{- end -}}

{{/*
Worker selector labels
*/}}
{{- define "airflow.worker.selectorLabels" -}}
{{ include "airflow.selectorLabels" . }}
app.kubernetes.io/component: worker
{{- end -}}
