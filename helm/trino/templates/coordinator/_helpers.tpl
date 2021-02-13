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
- name: trino-catalog
  configMap:
    name: {{ include "trino.fullname" . }}-catalog
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
{{- with $coordinator.extraVolumeMounts }}
{{ toYaml . }}
{{- end }}
{{- end -}}