{{/*
Historical labels
*/}}
{{- define "druid.historical.labels" -}}
{{- $root := index . 0 -}}
{{- $tier := index . 1 -}}
{{ include "druid.labels" $root }}
app.kubernetes.io/component: historical
{{- if $tier }}
druid.apache.org/historical-tier: {{ $tier }}
{{- end }}
{{- end -}}

{{/*
Historical selector labels
*/}}
{{- define "druid.historical.selectorLabels" -}}
{{- $root := index . 0 -}}
{{- $tier := index . 1 -}}
{{ include "druid.selectorLabels" $root }}
app.kubernetes.io/component: historical
druid.apache.org/historical-tier: {{ $tier }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "druid.historical.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ .Values.serviceAccount.name | default (include "druid.fullname" .) }}-historical
{{- else -}}
    {{ .Values.serviceAccount.name | default "default" }}
{{- end -}}
{{- end -}}

{{/*
Historical volumes
*/}}
{{- define "druid.historical.volumes" -}}
{{- $root := index . 0 -}}
{{- $historical := index . 1 -}}
{{ include "druid.volumes" $root }}
- name: historical-config
  configMap:
    name: {{ include "druid.fullname" $root }}-historical-{{ $historical.tier }}
{{- with $historical.extraVolumes }}
{{ toYaml . }}
{{- end }}
{{- end -}}

{{/*
Historical volumeMounts
*/}}
{{- define "druid.historical.volumeMounts" -}}
{{- $root := index . 0 -}}
{{- $historical := index . 1 -}}
{{ include "druid.volumeMounts" $root }}
- name: historical-config
  mountPath: /opt/druid/conf/druid/cluster/data/historical
{{- $persistence := $historical.persistence }}
{{- if $persistence.enabled }}
- name: data
  mountPath: {{ $persistence.mountPath }}
  {{- if $persistence.subPath }}
  subPath: {{ $persistence.subPath }}
  {{- end }}
  {{- if $persistence.subPathExpr }}
  subPathExpr: {{ $persistence.subPathExpr }}
  {{- end }}
{{- end }}
{{- with $historical.extraVolumeMounts }}
{{ toYaml . }}
{{- end }}
{{- end -}}

{{/*
Checksum pod annotations
*/}}
{{- define "druid.historical.checksum" -}}
{{ include "druid.checksum" . }}
checksum/historical-config: {{ include (print $.Template.BasePath "/historical/configmap.yaml") . | sha256sum }}
{{- end -}}

{{/*
Historical k8s default
*/}}
{{- define "druid.historical.k8s.default" -}}
args: [ historical ]
persistence:
  enabled: true
  size: 50Gi
  storageClass: null
  mountPath: /data/druid/
  subPath:
  subPathExpr:
  accessModes:
  - ReadWriteOnce
  annotations: {}
{{- end -}}

{{/*
Historical config default
*/}}
{{- define "druid.historical.config.default" -}}
jvm.config: |
  -server
  -XX:+UseG1GC
  -XX:+ExitOnOutOfMemoryError
  -Duser.timezone=UTC
  -Dfile.encoding=UTF-8
  -Djava.io.tmpdir=/tmp
  -Djava.util.logging.manager=org.apache.logging.log4j.jul.LogManager
extra.jvm.config:
main.config: org.apache.druid.cli.Main server historical
runtime.properties:
  druid.historical.cache.useCache: true
  druid.historical.cache.populateCache: true
{{- end -}}
