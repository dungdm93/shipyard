{{/*
DataHub Frontend labels
*/}}
{{- define "datahub.frontend.labels" -}}
{{ include "datahub.labels" . }}
app.kubernetes.io/component: frontend
{{- end -}}

{{/*
DataHub Frontend selector labels
*/}}
{{- define "datahub.frontend.selectorLabels" -}}
{{ include "datahub.selectorLabels" . }}
app.kubernetes.io/component: frontend
{{- end -}}

{{/*
DataHub Frontend checksum pod annotations
*/}}
{{- define "datahub.frontend.checksum" -}}
checksum/env: {{ include (print $.Template.BasePath "/secret.yaml") . | sha256sum }}
checksum/frontend-env: {{ include (print $.Template.BasePath "/frontend/secret.yaml") . | sha256sum }}
checksum/frontend-jaas: {{ include (print $.Template.BasePath "/frontend/secret-jaas.yaml") . | sha256sum }}
{{- end -}}
