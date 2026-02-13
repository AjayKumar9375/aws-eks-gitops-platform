# Demo API

A minimal Spring Boot service used to demonstrate CI/CD, GitOps, and observability.

## Local Development
```bash
cd services/demo-api
mvn -B -ntp spring-boot:run
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
powershell -ExecutionPolicy Bypass -File scripts/check.ps1
```
