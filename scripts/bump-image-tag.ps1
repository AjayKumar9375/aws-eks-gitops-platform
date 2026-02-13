param(
  [Parameter(Mandatory=$true)]
  [string]$Tag,
  [Parameter(Mandatory=$true)]
  [ValidateSet("dev", "prod")]
  [string]$Overlay
)

$path = "gitops/apps/overlays/$Overlay/demo-api-patch.yaml"
if (-not (Test-Path $path)) {
  throw "Overlay patch not found: $path"
}

$content = Get-Content $path -Raw
$content = $content -replace "value:\s*.*", "value: $Tag"
Set-Content -Path $path -Value $content -Encoding UTF8
Write-Host "Updated $path to tag $Tag"
