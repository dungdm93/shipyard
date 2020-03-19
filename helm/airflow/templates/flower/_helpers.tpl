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
