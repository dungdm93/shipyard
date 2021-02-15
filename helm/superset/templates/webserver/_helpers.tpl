{{/*
Webserver labels
*/}}
{{- define "superset.webserver.labels" -}}
{{ include "superset.labels" . }}
app.kubernetes.io/component: webserver
{{- end -}}

{{/*
Webserver selector labels
*/}}
{{- define "superset.webserver.selectorLabels" -}}
{{ include "superset.selectorLabels" . }}
app.kubernetes.io/component: webserver
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "superset.webserver.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ .Values.serviceAccount.name | default (include "superset.fullname" .) }}-webserver
{{- else -}}
    {{ .Values.serviceAccount.name | default "default" }}
{{- end -}}
{{- end -}}
