# AWS EKS Platform Project

I built this repository to demonstrate how I design, deploy, and operate a Kubernetes platform on AWS using production-oriented DevOps practices.

## What I Built
- Terraform infrastructure for VPC + EKS + IAM/IRSA
- GitOps deployment flow with Argo CD and environment overlays
- CI/CD pipelines for linting, testing, scanning, image build, and GitOps promotion
- Kubernetes security guardrails using Kyverno and OPA Gatekeeper
- Platform add-ons for ingress, TLS, secrets, and monitoring
- A sample Java Spring Boot service (`demo-api`) with health/readiness/metrics endpoints

## Why These Choices
- Terraform gives repeatable infra with clear environment separation (`dev`/`prod`)
- GitOps keeps cluster state auditable and PR-driven
- Policy-as-code catches security misconfigurations before deployment
- Prometheus metrics + alert rules make operations observable from day one

## Repository Layout
- `infra/terraform`: AWS infrastructure modules and environment stacks
- `platform/`: cluster add-ons (ingress, security, monitoring, cert-manager, secrets)
- `gitops/`: Argo CD applications and overlays
- `services/demo-api/`: sample workload, Dockerfile, Kubernetes manifests, Helm chart
- `.github/workflows/`: CI/CD automation
- `docs/`: architecture notes, portfolio talking points, and decision records
- `scripts/`: utility scripts for local checks and image tag updates

## Quality Standards I Enforced
- Java formatting checks with `spotless`
- Service tests with `JUnit` + `Spring Boot Test`
- Terraform format checks in CI
- Trivy vulnerability scan in app CI
- Pre-commit hooks for local consistency

## Local Verification
```bash
make check
```

```powershell
powershell -ExecutionPolicy Bypass -File scripts/check.ps1
```

## CI/CD Flow
1. Pull requests run lint, tests, and vulnerability scan.
2. Push to `master` builds and pushes the image to ECR.
3. Pipeline updates GitOps image tag in `dev` overlay.
4. Argo CD syncs the new desired state into EKS.

## Architecture and Decisions
- Detailed architecture: `docs/ARCHITECTURE.md`
- Key engineering decisions: `docs/DECISIONS.md`
- Interview-focused summary: `docs/PORTFOLIO.md`

## Next Improvements
- Progressive delivery (canary/blue-green)
- SLO burn-rate alerting
- Cost visibility dashboards
