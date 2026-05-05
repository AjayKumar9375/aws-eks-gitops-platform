# Security

## Reporting

Do not open public issues for sensitive security findings. Share the details privately with the project maintainer, including the affected path, impact, and a minimal reproduction when possible.

## Baseline Controls

- Kubernetes workloads run as non-root where possible.
- Workload labels are enforced through policy-as-code.
- Container images are expected to come from the configured ECR registry.
- External Secrets is used for application secret material.
- Pull requests run vulnerability scanning for the demo service.

## Secrets

Never commit real AWS credentials, kubeconfigs, tokens, private keys, or application secrets. Use AWS Secrets Manager and the External Secrets manifests under `platform/secrets/`.
