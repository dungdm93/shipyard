{{/*
HDFS checkpointnode labels
*/}}
{{- define "hdfs.checkpointnode.labels" -}}
{{ include "hdfs.labels" . }}
app.kubernetes.io/component: checkpointnode
{{- end -}}

{{/*
HDFS checkpointnode selector labels
*/}}
{{- define "hdfs.checkpointnode.selectorLabels" -}}
{{ include "hdfs.selectorLabels" . }}
app.kubernetes.io/component: checkpointnode
{{- end -}}
