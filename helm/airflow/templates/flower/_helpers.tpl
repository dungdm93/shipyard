{{/*
Flower labels
*/}}
{{- define "airflow.flower.labels" -}}
{{ include "airflow.labels" . }}
app.kubernetes.io/component: flower
{{- end -}}

{{/*
Flower selector labels
*/}}
{{- define "airflow.flower.selectorLabels" -}}
{{ include "airflow.selectorLabels" . }}
app.kubernetes.io/component: flower
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "airflow.flower.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ .Values.serviceAccount.name | default (include "airflow.fullname" .) }}-flower
{{- else -}}
    {{ .Values.serviceAccount.name | default "default" }}
{{- end -}}
{{- end -}}
