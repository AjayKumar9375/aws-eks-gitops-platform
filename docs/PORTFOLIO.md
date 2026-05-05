# Project Summary

## Overview

This repository demonstrates a production-aware AWS EKS platform built around infrastructure as code, GitOps delivery, policy controls, observability, and CI/CD quality gates.

## Highlights

- Reusable Terraform modules for VPC and EKS with separate `dev` and `prod` environment stacks.
- Argo CD application definitions and overlays for auditable GitOps deployments.
- Kubernetes security guardrails with Kyverno and OPA Gatekeeper.
- Progressive delivery support through Argo Rollouts canary analysis.
- Prometheus-compatible service metrics with SLO burn-rate alerting.
- Cost visibility through Kubecost and consistent allocation tags.
- CI workflows for application tests, infrastructure validation, manifest rendering, and vulnerability scanning.

## Engineering Focus

- Clear separation between infrastructure, platform add-ons, GitOps applications, and service code.
- Secure workload defaults, including non-root containers, security contexts, and required labels.
- Operational readiness through health checks, readiness checks, metrics, alerts, and runbooks.
- Maintainable development workflow with local validation scripts and pre-commit hooks.
