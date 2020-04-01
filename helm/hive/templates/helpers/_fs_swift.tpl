{{- define "hive.filesystem.swift.map" -}}
authUrl:  auth.url
tenant:   tenant
region:   region
username: username
password: password
apikey:   apikey
public:   public
{{- end }}

{{- define "hive.filesystem.swift" -}}
{{- $service := index . 0 -}}
{{- $props   := index . 1 -}}
{{- $keyMap := include "hive.filesystem.swift.map" . | fromYaml }}
{{- range $key, $value := $props }}
{{- if and (or $value (kindIs "bool" $value)) (hasKey $keyMap $key) }}
fs.swift.service.{{ $service }}.{{ index $keyMap $key }}: {{ $value }}
{{- end }}
{{- end }}
{{- end -}}
