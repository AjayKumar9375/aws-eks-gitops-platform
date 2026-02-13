{{- define "demo-api.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{- define "demo-api.fullname" -}}
{{- printf "%s-%s" .Release.Name (include "demo-api.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end }}
