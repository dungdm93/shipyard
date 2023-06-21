{{/*
DataHub Actions labels
*/}}
{{- define "datahub.actions.labels" -}}
{{ include "datahub.labels" . }}
app.kubernetes.io/component: actions
{{- end -}}

{{/*
DataHub Actions selector labels
*/}}
{{- define "datahub.actions.selectorLabels" -}}
{{ include "datahub.selectorLabels" . }}
app.kubernetes.io/component: actions
{{- end -}}

{{/*
DataHub Actions checksum pod annotations
*/}}
{{- define "datahub.actions.checksum" -}}
checksum/env: {{ include (print $.Template.BasePath "/secret.yaml") . | sha256sum }}
checksum/actions-env: {{ include (print $.Template.BasePath "/actions/secret.yaml") . | sha256sum }}
checksum/actions-extra: {{ include (print $.Template.BasePath "/actions/secret-actions.yaml") . | sha256sum }}
{{- end -}}

{{/*
DataHub Actions service account
*/}}
{{- define "datahub.actions.serviceAccountName" -}}
{{- if .Values.actionServiceAccount.create }}
{{- .Values.actionServiceAccount.name | default (printf "%s-actions" (include "datahub.fullname" .)) }}
{{- else }}
{{- .Values.actionServiceAccount.name | default "default" }}
{{- end }}
{{- end }}
