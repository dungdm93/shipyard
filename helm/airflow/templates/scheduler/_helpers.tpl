{{/*
Scheduler labels
*/}}
{{- define "airflow.scheduler.labels" -}}
{{ include "airflow.labels" . }}
app.kubernetes.io/component: scheduler
{{- end -}}

{{/*
Scheduler selector labels
*/}}
{{- define "airflow.scheduler.selectorLabels" -}}
{{ include "airflow.selectorLabels" . }}
app.kubernetes.io/component: scheduler
{{- end -}}
