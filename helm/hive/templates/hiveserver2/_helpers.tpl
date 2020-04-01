{{/*
HiveServer2 labels
*/}}
{{- define "hive.hiveserver2.labels" -}}
{{ include "hive.labels" . }}
app.kubernetes.io/component: hiveserver2
{{- end -}}

{{/*
HiveServer2 selector labels
*/}}
{{- define "hive.hiveserver2.selectorLabels" -}}
{{ include "hive.selectorLabels" . }}
app.kubernetes.io/component: hiveserver2
{{- end -}}
