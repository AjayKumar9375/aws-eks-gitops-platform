# Architecture Detail

## Cluster Design
- EKS managed node groups
- Private subnets for workers
- Public subnets for load balancers and NAT

## GitOps
- Argo CD bootstraps from `platform/argocd/bootstrap.yaml`
- Environments defined in `gitops/apps/overlays/*`

## Policies
- Kyverno enforces registry and labels
- Gatekeeper provides extra validation for pods

## CI/CD
- PRs: test + scan
- Main: build + push + update GitOps overlay

## Observability
- Prometheus rules for app alerts
- Grafana dashboards (add as needed)
