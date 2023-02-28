{{/*
Coordinator labels
*/}}
{{- define "trino.coordinator.labels" -}}
{{ include "trino.labels" . }}
app.kubernetes.io/component: coordinator
{{- end -}}

{{/*
Coordinator selector labels
*/}}
{{- define "trino.coordinator.selectorLabels" -}}
{{ include "trino.selectorLabels" . }}
app.kubernetes.io/component: coordinator
{{- end -}}

{{/*
Coordinator volumes
*/}}
{{- define "trino.coordinator.volumes" -}}
{{- $coordinator := mergeOverwrite (deepCopy .Values.commons) .Values.coordinator -}}
- name: trino-config
  projected:
    sources:
    - configMap:
        name: {{ include "trino.fullname" . }}-properties
    - configMap:
        name: {{ include "trino.fullname" . }}-config
        items:
        - key:  coordinator-config.properties
          path: config.properties
        {{- if (and .Values.faultTolerant.policy .Values.faultTolerant.exchangeManager.type ) }}
        - key:  exchange-manager.properties
          path: exchange-manager.properties
        {{- end }}
- name: trino-catalog
  configMap:
    name: {{ include "trino.fullname" . }}-catalog
{{- if .Values.metrics.enabled }}
- name: jmx-exporter
  emptyDir: {}
- name: trino-metrics
  configMap:
    name: {{ include "trino.fullname" . }}-metrics
{{- end }}
{{- if .Values.spill.enabled }}
- name: trino-spill
  emptyDir: {}
{{- end }}
{{- with $coordinator.extraVolumes }}
{{ toYaml . }}
{{- end }}
{{- end -}}


{{/*
Coordinator volumeMounts
*/}}
{{- define "trino.coordinator.volumeMounts" -}}
{{- $coordinator := mergeOverwrite (deepCopy .Values.commons) .Values.coordinator -}}
- name: trino-config
  mountPath: /etc/trino
- name: trino-catalog
  mountPath: /etc/trino/catalog
{{- if .Values.metrics.enabled }}
{{ include "trino.jmxMounts" . }}
{{- end }}
{{- if .Values.spill.enabled }}
- name: trino-spill
  mountPath: {{ .Values.spill.path }}
{{- end }}
{{- with $coordinator.extraVolumeMounts }}
{{ toYaml . }}
{{- end }}
{{- end -}}
