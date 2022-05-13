{{/*
HDFS NameNode labels
*/}}
{{- define "hdfs.namenode.labels" -}}
{{ include "hdfs.labels" . }}
app.kubernetes.io/component: namenode
{{- end -}}

{{/*
HDFS NameNode selector labels
*/}}
{{- define "hdfs.namenode.selectorLabels" -}}
{{ include "hdfs.selectorLabels" . }}
app.kubernetes.io/component: namenode
{{- end -}}
