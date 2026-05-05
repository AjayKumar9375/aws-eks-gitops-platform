# Contributing

This repository is intentionally small, but changes should still move through the same checks expected from a platform codebase.

## Local Checks

Run the full validation before opening a pull request:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/check.ps1
```

or, on Unix-like shells:

```bash
make check
```

The check path covers Java formatting/tests, Terraform formatting, Helm linting, and Kustomize rendering.

## Development Standards

- Keep infrastructure changes environment-aware; avoid hard-coding production-only values in shared modules.
- Keep workload manifests compatible with the policy layer, especially required labels and approved image registries.
- Prefer GitOps changes through overlays instead of manual cluster edits.
- Keep container images non-root and set Kubernetes security contexts on workloads.
- Add or update tests when changing service behavior.
- Update `README.md`, `DEPLOYMENT.md`, or `docs/` when an operational workflow changes.

## Pull Request Checklist

- `make check` or `scripts/check.ps1` passes locally, or any skipped tool is called out.
- Terraform plans are reviewed for unexpected replacements.
- GitOps overlay changes are intentional and scoped to the target environment.
- New secrets are referenced through External Secrets, not committed into the repository.
