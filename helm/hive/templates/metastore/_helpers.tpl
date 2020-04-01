{{/*
Hive MetaStore labels
*/}}
{{- define "hive.metastore.labels" -}}
{{ include "hive.labels" . }}
app.kubernetes.io/component: metastore
{{- end -}}

{{/*
Hive MetaStore selector labels
*/}}
{{- define "hive.metastore.selectorLabels" -}}
{{ include "hive.selectorLabels" . }}
app.kubernetes.io/component: metastore
{{- end -}}
