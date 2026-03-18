{{/*
Common helpers for tenant-app chart.
*/}}

{{/*
Full name: tenant-{slug}
*/}}
{{- define "tenant-app.fullname" -}}
{{- printf "tenant-%s" .Values.tenant.slug | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
App name for selector labels
*/}}
{{- define "tenant-app.appname" -}}
{{- printf "%s-app" (include "tenant-app.fullname" .) }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "tenant-app.labels" -}}
orbit.sh/tenant: {{ .Values.tenant.slug | quote }}
orbit.sh/managed-by: orbit-operator
app.kubernetes.io/part-of: {{ include "tenant-app.fullname" . }}
app.kubernetes.io/managed-by: argocd
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
{{- end }}

{{/*
App selector labels
*/}}
{{- define "tenant-app.selectorLabels" -}}
orbit.sh/tenant: {{ .Values.tenant.slug | quote }}
app.kubernetes.io/name: {{ include "tenant-app.appname" . }}
{{- end }}

{{/*
Postgres cluster name
*/}}
{{- define "tenant-app.postgresName" -}}
{{- printf "tenant-%s-pg" .Values.tenant.slug | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Valkey name
*/}}
{{- define "tenant-app.valkeyName" -}}
{{- printf "tenant-%s-valkey" .Values.tenant.slug | trunc 63 | trimSuffix "-" }}
{{- end }}
