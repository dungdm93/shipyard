{{/*
Worker labels
*/}}
{{- define "superset.worker.labels" -}}
{{ include "superset.labels" . }}
app.kubernetes.io/component: worker
{{- end -}}

{{/*
Worker selector labels
*/}}
{{- define "superset.worker.selectorLabels" -}}
{{ include "superset.selectorLabels" . }}
app.kubernetes.io/component: worker
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "superset.worker.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ .Values.serviceAccount.name | default (include "superset.fullname" .) }}-worker
{{- else -}}
    {{ .Values.serviceAccount.name | default "default" }}
{{- end -}}
{{- end -}}
