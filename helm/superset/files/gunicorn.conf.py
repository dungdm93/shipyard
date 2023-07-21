#accesslog = '-' # stdout
#errorlog = '-'  # stderr

{{ if .Values.superset.extraGunicornConfig -}}
{{ tpl .Values.superset.extraGunicornConfig . }}
{{- end }}
