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
        {{- if (and .Values.faultTolerant.enabled .Values.faultTolerant.exchangeManager.enabled ) }}
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
{{- with $worker.extraVolumeMounts }}
{{ toYaml . }}
{{- end }}
{{- end -}}
