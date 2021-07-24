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

{{/*
Create the name of the service account to use
*/}}
{{- define "airflow.scheduler.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
  {{ .Values.serviceAccount.name | default (include "airflow.fullname" .) }}-scheduler
{{- else -}}
  {{ .Values.serviceAccount.name | default "default" }}
{{- end -}}
{{- end -}}
