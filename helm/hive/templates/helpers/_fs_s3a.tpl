{{- define "hive.filesystem.s3a.map" -}}
impl: impl
endpoint: endpoint
pathStyleAccess: path.style.access
credentialsProvider: aws.credentials.provider

accessKey:    access.key
secretKey:    secret.key
sessionToken: session.token

sseKey: server-side-encryption.key
sseAlg: server-side-encryption-algorithm
{{- end }}

{{- define "hive.filesystem.s3a" -}}
{{- $bucket := index . 0 -}}
{{- $props  := index . 1 -}}
{{- $prefix := eq $bucket "" | ternary "fs.s3a" (printf "fs.s3a.bucket.%s" $bucket) }}
{{- $keyMap := include "hive.filesystem.s3a.map" . | fromYaml }}
{{- range $key, $value := $props }}
{{- if and (or $value (kindIs "bool" $value)) (hasKey $keyMap $key) }}
{{ $prefix }}.{{ index $keyMap $key }}: {{ $value }}
{{- end }}
{{- end }}
{{- end -}}
