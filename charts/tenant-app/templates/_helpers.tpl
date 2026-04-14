{{/*
Common helpers for tenant-app chart.
*/}}

{{/*
Resource prefix: uses tenant.resourcePrefix if set (obfuscated), otherwise tenant-{slug}.
*/}}
{{- define "tenant-app.resourcePrefix" -}}
{{- if .Values.tenant.resourcePrefix -}}
{{- .Values.tenant.resourcePrefix | trunc 63 | trimSuffix "-" }}
{{- else -}}
{{- printf "tenant-%s" .Values.tenant.slug | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Full name: resource prefix (e.g. t-a7f3b2c1 or tenant-{slug})
*/}}
{{- define "tenant-app.fullname" -}}
{{- include "tenant-app.resourcePrefix" . }}
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
Stable labels — same as common labels but WITHOUT helm.sh/chart.
Use this for any field that Kubernetes treats as immutable (e.g. StatefulSet
volumeClaimTemplates metadata, Job selectors). Including helm.sh/chart there
would cause every chart version bump to trigger "Forbidden: updates to
spec ... are forbidden" sync errors.
*/}}
{{- define "tenant-app.labelsStable" -}}
orbit.sh/tenant: {{ .Values.tenant.slug | quote }}
orbit.sh/managed-by: orbit-operator
app.kubernetes.io/part-of: {{ include "tenant-app.fullname" . }}
app.kubernetes.io/managed-by: argocd
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
{{- printf "%s-pg" (include "tenant-app.resourcePrefix" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Valkey name
*/}}
{{- define "tenant-app.valkeyName" -}}
{{- printf "%s-valkey" (include "tenant-app.resourcePrefix" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Per-component hostname.

Receives a dict with:
  .name  — component key (string)
  .comp  — component values map (kept for interface compatibility, unused)
  .root  — top-level $ context

Every component gets: {component-name}-{slug}.orbit.lustres.dev
*/}}
{{- define "tenant-app.componentHostname" -}}
{{- $myName := .name }}
{{- $slug   := .root.Values.tenant.slug }}
{{- printf "%s-%s.orbit.lustres.dev" $myName $slug }}
{{- end }}
