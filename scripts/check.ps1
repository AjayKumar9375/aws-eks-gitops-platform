Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

python -m pip install -r services/demo-api/dev-requirements.txt
python -m ruff check services/demo-api
python -m ruff format --check services/demo-api
Push-Location services/demo-api
try {
  python -m pytest tests
}
finally {
  Pop-Location
}
