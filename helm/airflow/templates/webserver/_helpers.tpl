{{/*
Webserver labels
*/}}
{{- define "airflow.webserver.labels" -}}
{{ include "airflow.labels" . }}
app.kubernetes.io/component: webserver
{{- end -}}

{{/*
Webserver selector labels
*/}}
{{- define "airflow.webserver.selectorLabels" -}}
{{ include "airflow.selectorLabels" . }}
app.kubernetes.io/component: webserver
{{- end -}}

{{- define "airflow.webserver.volumeMounts" -}}
- name: airflow-config
  mountPath: /opt/airflow/webserver_config.py
  subPath:   webserver_config.py
{{ include "airflow.volumeMounts" . }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "airflow.webserver.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ .Values.serviceAccount.name | default (include "airflow.fullname" .) }}-webserver
{{- else -}}
    {{ .Values.serviceAccount.name | default "default" }}
{{- end -}}
{{- end -}}
