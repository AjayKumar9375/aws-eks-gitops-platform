# Deployment Checklist (EKS + Argo CD + GitHub Actions)

This runbook is for deploying `demo-api` in this repository using:
- AWS EKS
- Argo CD GitOps
- GitHub Actions (`master` branch)

## 1. One-Time: AWS + GitHub OIDC Setup

1. Create (or verify) IAM OIDC provider:
- `token.actions.githubusercontent.com`
- Audience: `sts.amazonaws.com`

2. Create IAM role for GitHub Actions (example name: `GitHubActionsECRPushRole`):
- Trust policy restricted to:
  - your GitHub owner/repo
  - branch `master`

3. Attach ECR push permissions to that role.

4. In GitHub repo settings:
- `Settings -> Secrets and variables -> Actions`
- Add Secret:
  - `AWS_ROLE_ARN=arn:aws:iam::<account-id>:role/GitHubActionsECRPushRole`
- Add Variables:
  - `AWS_REGION=us-east-1`
  - `ECR_REPO=205474063511.dkr.ecr.us-east-1.amazonaws.com/java-application`

## 2. One-Time: Create ECR Repo and Lifecycle Policy

```bash
aws ecr create-repository --repository-name java-application --region us-east-1
aws ecr put-lifecycle-policy --repository-name java-application --region us-east-1 --lifecycle-policy-text file://platform/ecr/lifecycle-policy.json
```

If repository already exists, the create command can be skipped.

## 3. Provision Infrastructure (dev)

```bash
cd infra/terraform/envs/dev
terraform init
terraform apply
cd ../../..
```

## 4. Configure EKS API Reachability (if private endpoint issue)

```powershell
$MYIP=(Invoke-RestMethod https://checkip.amazonaws.com).Trim(); aws eks update-cluster-config --name devops-eks-dev --region us-east-1 --resources-vpc-config endpointPublicAccess=true,endpointPrivateAccess=true,publicAccessCidrs="$MYIP/32"
```

Wait for cluster update:

```bash
aws eks wait cluster-active --name devops-eks-dev --region us-east-1
```

## 5. Configure kubectl Access

```bash
aws eks update-kubeconfig --name devops-eks-dev --region us-east-1 --alias devops-eks-dev
kubectl config use-context devops-eks-dev
kubectl get nodes
```

If you get `You must be logged in to the server`, grant your local IAM principal EKS access:

```bash
aws sts get-caller-identity --query Arn --output text
```

Use that ARN as `<PRINCIPAL_ARN>`:

```bash
aws eks create-access-entry --cluster-name devops-eks-dev --region us-east-1 --principal-arn <PRINCIPAL_ARN>
aws eks associate-access-policy --cluster-name devops-eks-dev --region us-east-1 --principal-arn <PRINCIPAL_ARN> --policy-arn arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy --access-scope type=cluster
```

Then retry:

```bash
kubectl get nodes
```

## 6. Install Argo CD in `argocd` Namespace

```bash
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply --server-side -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl -n argocd get pods
kubectl -n argocd rollout status deploy/argocd-server --timeout=300s
```

If Argo CD was accidentally installed in `default`, clean and reinstall:

```bash
kubectl delete -n default -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply --server-side -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

## 7. Verify GitOps Repo Configuration

Ensure repo URLs point to your real GitHub repository and branch is `master` in:
- `platform/argocd/bootstrap.yaml`
- `gitops/apps/base/demo-api-app.yaml`
- `gitops/apps/base/ingress-app.yaml`
- `gitops/apps/base/monitoring-app.yaml`
- `gitops/apps/base/security-app.yaml`
- `gitops/apps/base/secrets-app.yaml`

## 8. Bootstrap Argo CD Applications

```bash
kubectl apply -f platform/argocd/bootstrap.yaml
kubectl -n argocd get applications
```

## 9. Deploy Application (Normal Flow)

1. Push changes to `master` (or manually run workflow `demo-api-build-push` with `push_image=true`).
2. Workflow builds and pushes image to ECR.
3. Workflow updates `gitops/apps/overlays/dev/demo-api-patch.yaml`.
4. Argo CD sync deploys updated image.

## 10. Verify Application

```bash
kubectl -n demo get deploy,pods,svc
kubectl -n demo rollout status deploy/demo-api
kubectl -n demo port-forward svc/demo-api 8080:80
curl http://localhost:8080/healthz
curl http://localhost:8080/readyz
curl http://localhost:8080/metrics
```

## 11. Useful Troubleshooting Commands

```bash
kubectl config current-context
kubectl get deploy -A | grep argocd
kubectl get svc -A | grep argocd
aws eks describe-cluster --name devops-eks-dev --region us-east-1 --query "cluster.resourcesVpcConfig.{public:endpointPublicAccess,private:endpointPrivateAccess,cidrs:publicAccessCidrs}" --output table
```

## 12. One-Script Deploy/Destroy

Deploy everything (Argo CD + Helm release):

```powershell
powershell -ExecutionPolicy Bypass -File scripts/apply-stack.ps1 -ImageTag <IMAGE_TAG>
```

Destroy everything created by the script:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/destroy-stack.ps1 -Force
```

Compatibility wrapper (still supported):

```powershell
powershell -ExecutionPolicy Bypass -File scripts/platform-stack.ps1 -Action deploy
powershell -ExecutionPolicy Bypass -File scripts/platform-stack.ps1 -Action destroy -Force
```
