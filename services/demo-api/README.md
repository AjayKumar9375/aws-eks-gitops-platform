# Demo API

A minimal Flask service used to demonstrate CI/CD, GitOps, and observability.

## Local Development
```bash
cd services/demo-api
python -m venv .venv
# Linux/macOS: source .venv/bin/activate
# Windows PowerShell: .venv\Scripts\Activate.ps1
pip install -r dev-requirements.txt
python app.py
```

## Endpoints
- `/` basic status
- `/healthz` liveness
- `/readyz` readiness
- `/metrics` Prometheus metrics

## Quality Gates
```bash
# From repo root
make lint
make test
```

```powershell
# From repo root on Windows
./scripts/check.ps1
```
