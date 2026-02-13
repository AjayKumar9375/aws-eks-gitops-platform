param(
  [string]$ClusterName = "devops-eks-dev",
  [string]$Region = "us-east-1",
  [string]$ContextAlias = "devops-eks-dev",
  [string]$AppNamespace = "demo",
  [string]$ReleaseName = "demo",
  [switch]$InstallArgoCD = $true,
  [switch]$Force
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

if (-not $Force) {
  $answer = Read-Host "This will remove Argo CD and app resources from this cluster. Type YES to continue"
  if ($answer -ne "YES") {
    Write-Host "Aborted." -ForegroundColor Yellow
    exit 1
  }
}

Invoke-CheckedCommand "helm uninstall $ReleaseName -n $AppNamespace --ignore-not-found"
Invoke-CheckedCommand "kubectl delete namespace $AppNamespace --ignore-not-found=true"

if ($InstallArgoCD) {
  Invoke-CheckedCommand "kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml --ignore-not-found=true"
  Invoke-CheckedCommand "kubectl delete namespace argocd --ignore-not-found=true"
}

Write-Host "Cleanup complete." -ForegroundColor Green
