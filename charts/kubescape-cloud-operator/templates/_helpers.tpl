{{/* standardize cloud provider */}}
{{- define "cloud_provider" -}}
  {{- if .Values.cloudProviderMetadata.cloudProviderEngine -}}
    {{- $provider := lower .Values.cloudProviderMetadata.cloudProviderEngine -}}
    {{- if or (contains "eks" $provider) (contains "aws" $provider) (contains "amazon" $provider) -}}
eks
    {{- else if or (contains "gke" $provider) (contains "gcp" $provider) (contains "google" $provider) -}}
gke
   {{- else if or (contains "aks" $provider) (contains "azure" $provider) (contains "microsoft" $provider) -}}
    {{- end -}}
  {{- end -}}
{{- end }}

{{- define "account_guid" -}}
  {{- if .Values.kubescape.submit }}
    {{- if .Values.account -}}
    {{- else -}}
      {{- fail "submitting is enabled but value for account is not defined: please register at https://cloud.armosec.io to get yours and re-run with  --set account=<your Guid>" }}
    {{- end -}}
  {{- end }}
{{- end }}

{{- define "cluster_name" -}}
  {{- if .Values.kubescape.submit }}
    {{- if .Values.clusterName -}}
    {{- else -}}
      {{- fail "value for clusterName is not defined: re-run with  --set clusterName=<your cluster name>" }}
    {{- end -}}
  {{- end }}
{{- end }}

{{- define "check.provider" -}}
  {{- if or (contains "eks" .Capabilities.KubeVersion.GitVersion) (contains "gke" .Capabilities.KubeVersion.GitVersion) (contains "azmk8s.io" .Values.clusterServer) -}}
    {{- print "true" -}}
  {{- else -}}
    {{- print "false" -}}
  {{- end -}}
{{- end -}}

{{- define "relevancy.Enabled" -}}
  {{- $isManaged := include "check.provider" . -}}
  {{ if eq .Values.capabilities.relevancy "enable" -}}
    {{- print "true" -}}
  {{ else if eq .Values.capabilities.relevancy "disable" -}}
    {{- print "false" -}}
  {{- else if and (eq .Values.capabilities.relevancy "detect") (eq $isManaged "true") -}}
    {{- print "true" -}}
  {{- else -}}
    {{- print "false" -}}
  {{- end -}}
{{- end -}}
