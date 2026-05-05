Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Assert-Command {
  param([Parameter(Mandatory = $true)][string]$Name)

  if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
    throw "Missing required command '$Name'. Install it and re-run this check."
  }
}

function Invoke-IfCommand {
  param(
    [Parameter(Mandatory = $true)][string]$Name,
    [Parameter(Mandatory = $true)][scriptblock]$Script
  )

  if (Get-Command $Name -ErrorAction SilentlyContinue) {
    & $Script
  }
  else {
    Write-Warning "Skipping $Name validation because '$Name' is not installed."
  }
}

Assert-Command mvn
Assert-Command terraform

Push-Location services/demo-api
try {
  mvn -B -ntp spotless:check
  if ($LASTEXITCODE -ne 0) { throw "spotless check failed" }
  mvn -B -ntp test
  if ($LASTEXITCODE -ne 0) { throw "tests failed" }
}
finally {
  Pop-Location
}

terraform fmt -check -recursive infra/terraform
if ($LASTEXITCODE -ne 0) { throw "terraform fmt check failed" }

Invoke-IfCommand helm {
  helm lint services/demo-api/helm/demo-api
  if ($LASTEXITCODE -ne 0) { throw "helm lint failed" }
}

Invoke-IfCommand kubectl {
  kubectl kustomize gitops/apps/overlays/dev | Out-Null
  if ($LASTEXITCODE -ne 0) { throw "dev GitOps overlay render failed" }

  kubectl kustomize gitops/apps/overlays/prod | Out-Null
  if ($LASTEXITCODE -ne 0) { throw "prod GitOps overlay render failed" }

  kubectl kustomize platform/monitoring | Out-Null
  if ($LASTEXITCODE -ne 0) { throw "monitoring platform render failed" }

  kubectl kustomize platform/security | Out-Null
  if ($LASTEXITCODE -ne 0) { throw "security platform render failed" }
}
