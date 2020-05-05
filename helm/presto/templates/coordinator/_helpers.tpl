{{/*
Coordinator labels
*/}}
{{- define "presto.coordinator.labels" -}}
{{ include "presto.labels" . }}
app.kubernetes.io/component: coordinator
{{- end -}}

{{/*
Coordinator selector labels
*/}}
{{- define "presto.coordinator.selectorLabels" -}}
{{ include "presto.selectorLabels" . }}
app.kubernetes.io/component: coordinator
{{- end -}}

{{/*
Coordinator volumes
*/}}
{{- define "presto.coordinator.volumes" -}}
{{- $coordinator := mergeOverwrite (deepCopy .Values.commons) .Values.coordinator -}}
- name: presto-config
  projected:
    sources:
    - configMap:
        name: {{ include "presto.fullname" . }}-properties
    - configMap:
        name: {{ include "presto.fullname" . }}-config
        items:
        - key:  coordinator-config.properties
          path: config.properties
- name: presto-catalog
  configMap:
    name: {{ include "presto.fullname" . }}-catalog
{{- with $coordinator.extraVolumes }}
{{ toYaml . }}
{{- end }}
{{- end -}}


{{/*
Coordinator volumeMounts
*/}}
{{- define "presto.coordinator.volumeMounts" -}}
{{- $coordinator := mergeOverwrite (deepCopy .Values.commons) .Values.coordinator -}}
- name: presto-config
  mountPath: /etc/presto
- name: presto-catalog
  mountPath: /etc/presto/catalog
{{- with $coordinator.extraVolumeMounts }}
{{ toYaml . }}
{{- end }}
{{- end -}}
