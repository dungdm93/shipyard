{{ if .Values.superset.extraCeleryConfig -}}
{{ tpl .Values.superset.extraCeleryConfig . }}
{{- end }}
