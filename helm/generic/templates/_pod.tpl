{{/*
Pod template for workload
*/}}
{{- define "generic.podTemplate" -}}
metadata:
  labels:
    {{- include "generic.selectorLabels" . | nindent 4 }}
  annotations:
    checksum/configmap: {{ include (print $.Template.BasePath "/configmaps.yaml") . | sha256sum }}
    checksum/secret:    {{ include (print $.Template.BasePath "/secrets.yaml") .    | sha256sum }}
    {{- with .Values.app.podAnnotations }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
spec:
  {{- with .Values.image.pullSecrets }}
  imagePullSecrets:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  enableServiceLinks: false
  containers:
    - name:  app
      image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
      imagePullPolicy: {{ .Values.image.pullPolicy }}
      {{- with .Values.app.command }}
      command:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.app.args }}
      args:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- if .Values.env }}
      env:
        {{- include "generic.env" . | nindent 8 }}
      {{- end }}
      {{- if .Values.envFrom }}
      envFrom:
        {{- include "generic.envFrom" . | nindent 8 }}
      {{- end }}
      ports:
        {{- toYaml .Values.app.ports | nindent 8 }}
      {{- if .Values.volumeMounts }}
      volumeMounts:
        {{- toYaml .Values.volumeMounts | nindent 8 }}
      {{- end }}
      {{- if .Values.volumeDevices }}
      volumeDevices:
        {{- toYaml .Values.volumeDevices | nindent 8 }}
      {{- end }}
      {{- with .Values.app.healthcheck.liveness }}
      livenessProbe:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.app.healthcheck.readiness }}
      readinessProbe:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.app.healthcheck.startup }}
      startupProbe:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.resources }}
      resources:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.securityContext }}
      securityContext:
        {{- toYaml . | nindent 8 }}
      {{- end }}
  serviceAccountName: {{ include "generic.serviceAccountName" . }}
  {{- with .Values.app.priorityClassName }}
  priorityClassName:  {{ . }}
  {{- end }}
  {{- with .Values.app.runtimeClassName }}
  runtimeClassName:   {{ . }}
  {{- end }}
  {{- with .Values.app.schedulerName }}
  schedulerName:      {{ . }}
  {{- end }}
  {{- with .Values.podSecurityContext }}
  securityContext:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- if .Values.volumes }}
  volumes:
    {{- include "generic.volumes" . | nindent 4 }}
  {{- end }}
  {{- with .Values.nodeSelector }}
  nodeSelector:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.affinity }}
  affinity:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with .Values.tolerations }}
  tolerations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end -}}
