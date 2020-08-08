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

{{/*
Create the name of the service account to use
*/}}
{{- define "airflow.worker.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ .Values.serviceAccount.name | default (include "airflow.fullname" .) }}-worker
{{- else -}}
    {{ .Values.serviceAccount.name | default "default" }}
{{- end -}}
{{- end -}}
