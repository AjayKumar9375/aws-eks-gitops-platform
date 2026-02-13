# Portfolio Notes

## How I Present This Project
- I designed this as a realistic platform engineering blueprint, not just a demo app.
- I focused on operational maturity: GitOps, policy controls, observability, and CI quality gates.
- I separated concerns clearly: infra (`terraform`), platform add-ons, app delivery (`gitops`), and service code.

## Interview Talking Points
- Built an AWS EKS platform with reusable Terraform modules and separate `dev`/`prod` environments.
- Implemented a GitOps deployment model using Argo CD overlays for controlled promotion.
- Added security controls with Kyverno and Gatekeeper to enforce baseline Kubernetes standards.
- Integrated CI checks for linting, tests, and vulnerability scanning before merge.
- Implemented service-level metrics and readiness/liveness patterns for operational visibility.

## Resume Bullets
- Designed and delivered an AWS EKS platform using Terraform, GitOps, and policy-as-code controls across multiple environments.
- Built CI/CD pipelines that enforce lint/test/security gates and automate container delivery with GitOps promotion.
- Enforced Kubernetes security posture through Kyverno and OPA Gatekeeper policies.
- Added observability foundations with Prometheus-compatible metrics and alerting patterns.
