# Cost Visibility

Kubecost is installed through the `kubecost` Argo CD application in `gitops/apps/base/cost-app.yaml`.

The platform uses three layers for cost visibility:

- AWS resource tags from Terraform: `Project`, `Environment`, `CostCenter`, `Owner`, and `ManagedBy`.
- Kubernetes labels on workloads: `app.kubernetes.io/name`, `app.kubernetes.io/part-of`, and `team`.
- Kubecost allocation views for namespace, workload, service, and label-level cost breakdowns.

After sync, port-forward the Kubecost frontend for local inspection:

```bash
kubectl -n kubecost port-forward svc/kubecost-cost-analyzer 9090:9090
```

Then open `http://localhost:9090`.
