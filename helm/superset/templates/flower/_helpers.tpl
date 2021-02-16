{{/*
Flower labels
*/}}
{{- define "superset.flower.labels" -}}
{{ include "superset.labels" . }}
app.kubernetes.io/component: flower
{{- end -}}

{{/*
Flower selector labels
*/}}
{{- define "superset.flower.selectorLabels" -}}
{{ include "superset.selectorLabels" . }}
app.kubernetes.io/component: flower
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "superset.flower.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ .Values.serviceAccount.name | default (include "superset.fullname" .) }}-flower
{{- else -}}
    {{ .Values.serviceAccount.name | default "default" }}
{{- end -}}
{{- end -}}
