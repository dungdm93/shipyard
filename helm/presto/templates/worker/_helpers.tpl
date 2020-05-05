{{/*
Worker labels
*/}}
{{- define "presto.worker.labels" -}}
{{ include "presto.labels" . }}
app.kubernetes.io/component: worker
{{- end -}}

{{/*
Worker selector labels
*/}}
{{- define "presto.worker.selectorLabels" -}}
{{ include "presto.selectorLabels" . }}
app.kubernetes.io/component: worker
{{- end -}}

{{/*
Worker volumes
*/}}
{{- define "presto.worker.volumes" -}}
{{- $worker := mergeOverwrite (deepCopy .Values.commons) .Values.worker -}}
- name: presto-config
  projected:
    sources:
    - configMap:
        name: {{ include "presto.fullname" . }}-properties
    - configMap:
        name: {{ include "presto.fullname" . }}-config
        items:
        - key:  worker-config.properties
          path: config.properties
- name: presto-catalog
  configMap:
    name: {{ include "presto.fullname" . }}-catalog
{{- with $worker.extraVolumes }}
{{ toYaml . }}
{{- end }}
{{- end -}}

{{/*
Coordinator volumeMounts
*/}}
{{- define "presto.worker.volumeMounts" -}}
{{- $worker := mergeOverwrite (deepCopy .Values.commons) .Values.worker -}}
- name: presto-config
  mountPath: /etc/presto
- name: presto-catalog
  mountPath: /etc/presto/catalog
{{- with $worker.extraVolumeMounts }}
{{ toYaml . }}
{{- end }}
{{- end -}}
