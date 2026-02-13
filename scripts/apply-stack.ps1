param(
  [string]$ClusterName = "devops-eks-dev",
  [string]$Region = "us-east-1",
  [string]$ContextAlias = "devops-eks-dev",
  [string]$AppNamespace = "demo",
  [string]$ReleaseName = "demo",
  [string]$ChartPath = "services/demo-api/helm/demo-api",
  [string]$ImageRepository = "205474063511.dkr.ecr.us-east-1.amazonaws.com/java-application",
  [string]$ImageTag = "latest",
  [switch]$InstallArgoCD = $true
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Invoke-CheckedCommand {
  param([Parameter(Mandatory = $true)][string]$Command)
  Write-Host ">> $Command" -ForegroundColor Cyan
  Invoke-Expression $Command
  if ($LASTEXITCODE -ne 0) {
    throw "Command failed: $Command"
  }
}

function Ensure-Tool {
  param([Parameter(Mandatory = $true)][string]$Name)
  if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
    throw "Required tool not found on PATH: $Name"
  }
}

Ensure-Tool "aws"
Ensure-Tool "kubectl"
Ensure-Tool "helm"

Invoke-CheckedCommand "aws eks update-kubeconfig --name $ClusterName --region $Region --alias $ContextAlias"
Invoke-CheckedCommand "kubectl config use-context $ContextAlias"

if ($InstallArgoCD) {
  Invoke-CheckedCommand "kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -"
  Invoke-CheckedCommand "kubectl apply --server-side -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"
  Invoke-CheckedCommand "kubectl -n argocd rollout status deploy/argocd-server --timeout=300s"
}

Invoke-CheckedCommand "kubectl create namespace $AppNamespace --dry-run=client -o yaml | kubectl apply -f -"
Invoke-CheckedCommand "helm upgrade --install $ReleaseName $ChartPath -n $AppNamespace --set image.repository=$ImageRepository --set image.tag=$ImageTag"

$deploymentName = "$ReleaseName-demo-api"
Invoke-CheckedCommand "kubectl -n $AppNamespace rollout status deployment/$deploymentName --timeout=300s"
Invoke-CheckedCommand "kubectl -n $AppNamespace get deploy,pods,svc"
