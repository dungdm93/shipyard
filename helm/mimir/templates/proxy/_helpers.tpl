{{/*
Proxy labels
*/}}
{{- define "mimir.proxy.labels" -}}
{{ include "mimir.labels" . }}
app.kubernetes.io/component: proxy
{{- end -}}

{{/*
Proxy selector labels
*/}}
{{- define "mimir.proxy.selectorLabels" -}}
{{ include "mimir.selectorLabels" . }}
app.kubernetes.io/component: proxy
{{- end -}}

{{/*
Proxy checksum pod annotations
*/}}
{{- define "mimir.proxy.checksum" -}}
checksum/proxy-config: {{ include (print $.Template.BasePath "/proxy/configmap.yaml") . | sha256sum }}
{{- end -}}

{{/*
Proxy docker image name
*/}}
{{- define "mimir.proxy.image" -}}
{{ .repository }}:{{ .tag }}
{{- end -}}

{{/*
Proxy volumeMounts
*/}}
{{- define "mimir.proxy.volumeMounts" -}}
- name: envoy-config
  mountPath: /etc/envoy/
{{- end -}}

{{/*
Proxy volumes
*/}}
{{- define "mimir.proxy.volumes" -}}
- name: envoy-config
  configMap:
    name: {{ include "mimir.fullname" . }}-proxy-config
{{- end -}}
