{{- define "react-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "react-app.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "react-app.labels" -}}
app.kubernetes.io/name: {{ include "react-app.name" . }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "react-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "react-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "react-app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (include "react-app.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
default
{{- end -}}
{{- end -}}