{{/*
Beat labels
*/}}
{{- define "superset.beat.labels" -}}
{{ include "superset.labels" . }}
app.kubernetes.io/component: beat
{{- end -}}

{{/*
Beat selector labels
*/}}
{{- define "superset.beat.selectorLabels" -}}
{{ include "superset.selectorLabels" . }}
app.kubernetes.io/component: beat
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "superset.beat.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ .Values.serviceAccount.name | default (include "superset.fullname" .) }}-beat
{{- else -}}
    {{ .Values.serviceAccount.name | default "default" }}
{{- end -}}
{{- end -}}
