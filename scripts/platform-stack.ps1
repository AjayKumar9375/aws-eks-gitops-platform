param(
  [Parameter(Mandatory = $true)]
  [ValidateSet("deploy", "destroy")]
  [string]$Action
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if ($Action -eq "deploy") {
  & "$PSScriptRoot/apply-stack.ps1" @args
  exit $LASTEXITCODE
}

& "$PSScriptRoot/destroy-stack.ps1" @args
exit $LASTEXITCODE
