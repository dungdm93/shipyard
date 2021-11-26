{{/*
Triggerer labels
*/}}
{{- define "airflow.triggerer.labels" -}}
{{ include "airflow.labels" . }}
app.kubernetes.io/component: triggerer
{{- end -}}

{{/*
Triggerer selector labels
*/}}
{{- define "airflow.triggerer.selectorLabels" -}}
{{ include "airflow.selectorLabels" . }}
app.kubernetes.io/component: triggerer
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "airflow.triggerer.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
  {{ .Values.serviceAccount.name | default (include "airflow.fullname" .) }}-triggerer
{{- else -}}
  {{ .Values.serviceAccount.name | default "default" }}
{{- end -}}
{{- end -}}
