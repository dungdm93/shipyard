{{/*
HDFS DataNode labels
*/}}
{{- define "hdfs.datanode.labels" -}}
{{ include "hdfs.labels" . }}
app.kubernetes.io/component: datanode
{{- end -}}

{{/*
HDFS DataNode selector labels
*/}}
{{- define "hdfs.datanode.selectorLabels" -}}
{{ include "hdfs.selectorLabels" . }}
app.kubernetes.io/component: datanode
{{- end -}}
