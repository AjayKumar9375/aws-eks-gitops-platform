# Engineering Decisions

## 1. GitOps as Deployment Source of Truth
- Decision: use Argo CD + Kustomize overlays.
- Reason: every deployment change is tracked in Git and peer-reviewable.
- Tradeoff: adds promotion workflow overhead versus direct `kubectl` deploys.

## 2. Terraform Modules for EKS and VPC
- Decision: split infra into environment stacks and reusable modules.
- Reason: reuse and consistency between `dev` and `prod`.
- Tradeoff: more upfront module design effort.

## 3. Dual Policy Engines (Kyverno + Gatekeeper)
- Decision: include both to demonstrate policy patterns.
- Reason: shows practical understanding of admission control options.
- Tradeoff: additional policy maintenance complexity.

## 4. Trivy in CI for App Path
- Decision: fail PRs on HIGH/CRITICAL findings in service scope.
- Reason: baseline security gate before merge.
- Tradeoff: occasional noisy findings requiring triage.

## 5. Minimal Service with Health + Metrics
- Decision: keep app intentionally small and production-aware.
- Reason: showcase platform capabilities rather than application complexity.
- Tradeoff: limited business logic depth in service layer.
