{{/*
Worker labels
*/}}
{{- define "trino.worker.labels" -}}
{{ include "trino.labels" . }}
app.kubernetes.io/component: worker
{{- end -}}

{{/*
Worker selector labels
*/}}
{{- define "trino.worker.selectorLabels" -}}
{{ include "trino.selectorLabels" . }}
app.kubernetes.io/component: worker
{{- end -}}

{{/*
Worker volumes
*/}}
{{- define "trino.worker.volumes" -}}
{{- $worker := mergeOverwrite (deepCopy .Values.commons) .Values.worker -}}
- name: trino-config
  projected:
    sources:
    - configMap:
        name: {{ include "trino.fullname" . }}-properties
    - configMap:
        name: {{ include "trino.fullname" . }}-config
        items:
        - key:  worker-config.properties
          path: config.properties
        {{- if (and .Values.faultTolerant.policy .Values.faultTolerant.exchangeManager.type ) }}
        - key:  exchange-manager.properties
          path: exchange-manager.properties
        {{- end }}
- name: trino-catalog
  configMap:
    name: {{ include "trino.fullname" . }}-catalog
- name: trino-scripts
  configMap:
    name: {{ include "trino.fullname" . }}-scripts
{{- if .Values.metrics.enabled }}
- name: jmx-exporter
  emptyDir: {}
- name: trino-metrics
  configMap:
    name: {{ include "trino.fullname" . }}-metrics
{{- end }}
{{- if and .Values.cache.enabled (not .Values.cache.persistence.enable) }}
- name: cache
  emptyDir: {}
{{- end }}
{{- if and .Values.spill.enabled (not .Values.spill.persistence.enable) }}
- name: spill
  emptyDir: {}
{{- end }}
{{- with $worker.extraVolumes }}
{{ toYaml . }}
{{- end }}
{{- end -}}

{{/*
Coordinator volumeMounts
*/}}
{{- define "trino.worker.volumeMounts" -}}
{{- $worker := mergeOverwrite (deepCopy .Values.commons) .Values.worker -}}
- name: trino-config
  mountPath: /etc/trino
- name: trino-catalog
  mountPath: /etc/trino/catalog
- name: trino-scripts
  mountPath: /etc/trino/scripts
{{- if .Values.metrics.enabled }}
{{ include "trino.jmxMounts" . }}
{{- end }}
{{- if .Values.cache.enabled }}
- name: cache
  mountPath: /opt/trino/cache
{{- end }}
{{- if .Values.spill.enabled }}
- name: spill
  mountPath: /opt/trino/spill
{{- end }}
{{- with $worker.extraVolumeMounts }}
{{ toYaml . }}
{{- end }}
{{- end -}}

{{/*
Worker volumeClaimTemplates
*/}}
{{- define "trino.worker.volumeClaimTemplates" -}}
{{- if and .Values.cache.enabled .Values.cache.persistence.enabled }}
- apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    name: cache
  spec:
    {{- with .Values.cache.persistence.accessModes }}
    accessModes:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    {{- if .Values.cache.persistence.storageClass }}
    {{- if eq "-" .Values.cache.persistence.storageClass }}
    storageClassName: ""
    {{- else }}
    storageClassName: {{ .Values.cache.persistence.storageClass | quote }}
    {{- end }}
    {{- end }}
    resources:
      requests:
        storage: {{ .Values.cache.persistence.size | quote }}
{{- end }}
{{- if and .Values.spill.enabled .Values.spill.persistence.enabled }}
- apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    name: spill
  spec:
    {{- with .Values.spill.persistence.accessModes }}
    accessModes:
      {{- toYaml . | nindent 6 }}
    {{- end }}
    storageClassName: {{ .Values.spill.persistence.storageClass | quote }}
    resources:
      requests:
        storage: {{ .Values.spill.persistence.size | quote }}
{{- end }}
{{- end -}}
