param(
  [Parameter(Mandatory = $true)]
  [ValidateSet("deploy", "destroy")]
  [string]$Action,
  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]]$RemainingArgs
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if ($Action -eq "deploy") {
  & "$PSScriptRoot/apply-stack.ps1" @RemainingArgs
  exit $LASTEXITCODE
}

& "$PSScriptRoot/destroy-stack.ps1" @RemainingArgs
exit $LASTEXITCODE
