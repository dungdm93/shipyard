{{- define "hive.filesystem.gs.saMap" -}}
email:        email
privateKeyId: private.key.id
privateKey:   private.key
jsonKeyfile:  json.keyfile
keyfile:      keyfile
{{- end }}

{{- define "hive.filesystem.gs" -}}
{{- $gs := . }}
{{- if $gs.serviceAccount.enabled }}
# Authentication via ServiceAccount
fs.gs.auth.service.account.enable: true
  {{- $keyMap := include "hive.filesystem.gs.saMap" . | fromYaml }}

  {{- range $key := list "email" "privateKeyId" "privateKey" "jsonKeyfile" "keyfile" }}
    {{- $value := index $gs.serviceAccount $key }}
    {{- if and (or $value (kindIs "bool" $value)) (hasKey $keyMap $key) }}
fs.gs.auth.service.account.{{ index $keyMap $key }}: {{ $value | quote }}
    {{- end }}
  {{- end }}
{{- else }}
# Authentication via Client Secret
fs.gs.auth.service.account.enable: false
  {{- range $key := list "id" "secret" "file" }}
    {{- $value := index $gs.client $key }}
    {{- if and (or $value (kindIs "bool" $value)) }}
fs.gs.auth.client.{{ $key }}: {{ $value }}
    {{- end }}
  {{- end }}
{{- end }}
{{- end -}}
