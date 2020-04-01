{{- define "hive.filesystem.adl.map" -}}
accessTokenProvider:   oauth2.access.token.provider.type
devicecodeClientappid: oauth2.devicecode.clientappid
clientId:     oauth2.client.id
refreshToken: oauth2.refresh.token
refreshUrl:   oauth2.refresh.url
credential:   oauth2.credential
msiPort:      oauth2.msi.port
{{- end }}

{{- define "hive.filesystem.adl" -}}
{{- $account := index . 0 -}}
{{- $props   := index . 1 -}}
{{- $prefix := eq $account "" | ternary "fs.adl" (printf "fs.adl.account.%s" $account) }}
{{- $keyMap := include "hive.filesystem.adl.map" . | fromYaml }}
{{- range $key, $value := $props }}
{{- if and (or $value (kindIs "bool" $value)) (hasKey $keyMap $key) }}
{{ $prefix }}.{{ index $keyMap $key }}: {{ $value }}
{{- end }}
{{- end }}
{{- end -}}
