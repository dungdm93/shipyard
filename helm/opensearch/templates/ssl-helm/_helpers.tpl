{{/*
Generate TLS certificates.

Note: Always use this template as follows:\

  {{- $_ := include "opensearch.helm.setup-ca" . -}}

The assignment to `$_` is required because we store the generated CI in a global `ca` variable.
Please, don't try to "simplify" this, as without this trick, every generated
certificate would be signed by a different CA.
*/}}
{{- define "opensearch.helm.setup-ca" }}
  {{- if not .ca }}
    {{- $ca := "" -}}
    {{- $caSecret := printf "%s-ca" (include "opensearch.fullname" .) }}
    {{- with lookup "v1" "Secret" .Release.Namespace $caSecret }}
      {{- $crt := index .data "ca.crt" }}
      {{- $key := index .data "ca.key" }}
      {{- $ca = buildCustomCert $crt $key -}}
    {{- else }}
      {{- $ca = genCA "opensearch.org" 365 }}
    {{- end }}
  {{- $_ := set . "ca" $ca -}}
  {{- end }}
{{- end }}
