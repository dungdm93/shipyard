{{/* Generalized Metadata Service (GMS) */}}

{{/*
DataHub GMS labels
*/}}
{{- define "datahub.gms.labels" -}}
{{ include "datahub.labels" . }}
app.kubernetes.io/component: gms
{{- end -}}

{{/*
DataHub GMS selector labels
*/}}
{{- define "datahub.gms.selectorLabels" -}}
{{ include "datahub.selectorLabels" . }}
app.kubernetes.io/component: gms
{{- end -}}

{{/*
DataHub GMS checksum pod annotations
*/}}
{{- define "datahub.gms.checksum" -}}
checksum/env: {{ include (print $.Template.BasePath "/secret.yaml") . | sha256sum }}
checksum/gms-env: {{ include (print $.Template.BasePath "/gms/secret.yaml") . | sha256sum }}
{{- end -}}
