{{/*
Proxy labels
*/}}
{{- define "loki.proxy.labels" -}}
{{ include "loki.labels" . }}
app.kubernetes.io/component: proxy
{{- end -}}

{{/*
Proxy selector labels
*/}}
{{- define "loki.proxy.selectorLabels" -}}
{{ include "loki.selectorLabels" . }}
app.kubernetes.io/component: proxy
{{- end -}}

{{/*
Proxy checksum pod annotations
*/}}
{{- define "loki.proxy.checksum" -}}
checksum/proxy-config: {{ include (print $.Template.BasePath "/proxy/configmap.yaml") . | sha256sum }}
{{- end -}}

{{/*
Proxy docker image name
*/}}
{{- define "loki.proxy.image" -}}
{{ .repository }}:{{ .tag }}
{{- end -}}

{{/*
Proxy volumeMounts
*/}}
{{- define "loki.proxy.volumeMounts" -}}
- name: envoy-config
  mountPath: /etc/envoy/
{{- end -}}

{{/*
Proxy volumes
*/}}
{{- define "loki.proxy.volumes" -}}
- name: envoy-config
  configMap:
    name: {{ include "loki.fullname" . }}-proxy-config
{{- end -}}
