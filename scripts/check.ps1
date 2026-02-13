Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

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
