{{/*
Hive-MetaStore migration labels
*/}}
{{- define "hive.migration.labels" -}}
{{ include "hive.labels" . }}
app.kubernetes.io/component: migration
{{- end -}}

{{/*
Hive-MetaStore migration selector labels
*/}}
{{- define "hive.migration.selectorLabels" -}}
{{ include "hive.selectorLabels" . }}
app.kubernetes.io/component: migration
{{- end -}}
