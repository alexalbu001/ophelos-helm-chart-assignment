{{/*
Expand the name of the chart.
*/}}
{{- define "voting-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "voting-app.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "voting-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
These labels are added to every resource
*/}}
{{- define "voting-app.labels" -}}
helm.sh/chart: {{ include "voting-app.chart" . }}
{{ include "voting-app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
These are used in matchLabels sections
*/}}
{{- define "voting-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "voting-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the vote component
*/}}
{{- define "voting-app.vote.fullname" -}}
{{- printf "%s-vote" (include "voting-app.fullname" .) }}
{{- end }}

{{/*
Create the name of the result component
*/}}
{{- define "voting-app.result.fullname" -}}
{{- printf "%s-result" (include "voting-app.fullname" .) }}
{{- end }}

{{/*
Create the name of the worker component
*/}}
{{- define "voting-app.worker.fullname" -}}
{{- printf "%s-worker" (include "voting-app.fullname" .) }}
{{- end }}

{{/*
Create the name of the redis component
*/}}
{{- define "voting-app.redis.fullname" -}}
{{- printf "%s-redis" (include "voting-app.fullname" .) }}
{{- end }}

{{/*
Create the name of the postgresql component
*/}}
{{- define "voting-app.postgresql.fullname" -}}
{{- printf "%s-db" (include "voting-app.fullname" .) }}
{{- end }}

{{/*
Get the Redis password secret name
*/}}
{{- define "voting-app.redis.secretName" -}}
{{- if .Values.redis.auth.existingSecret -}}
    {{- .Values.redis.auth.existingSecret -}}
{{- else -}}
    {{- printf "%s-auth" (include "voting-app.redis.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Get the Redis password secret key
*/}}
{{- define "voting-app.redis.secretKey" -}}
{{- if .Values.redis.auth.existingSecret -}}
    {{- .Values.redis.auth.existingSecretPasswordKey | default "password" -}}
{{- else -}}
    password
{{- end -}}
{{- end -}}
