# Runbook and Architecture Notes

## Environments
- `dev`: faster feedback, smaller node groups
- `prod`: higher availability, stricter policies

## Provisioning Flow
1. `infra/terraform` creates VPC, EKS, IAM, OIDC, and node groups.
2. `platform/` installs core add-ons (ingress, monitoring, security, secrets).
3. `gitops/` defines applications and environment overlays for Argo CD.

## Operational Standards
- GitOps is the source of truth for workloads.
- No manual kubectl changes in production.
- All workload changes happen via PRs.

## Security Standards
- Deny privileged pods, hostPath, and unsafe capabilities.
- Require image signatures or allow-list (policy included).
- Enforce namespace, labels, and resource requests.

## Observability Standards
- All services emit Prometheus metrics.
- Standard dashboards for cluster, app, and ingress.
- Alerts follow SLO-based error budgets.

## Cost Control
- Use smaller node groups in `dev`.
- Enable Cluster Autoscaler or Karpenter (future).
- Review ECR retention policies.
