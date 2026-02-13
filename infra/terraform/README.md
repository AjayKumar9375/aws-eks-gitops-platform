# Terraform

This folder models AWS infrastructure for the platform.

## Environments
- `envs/dev`
- `envs/prod`

## Usage (example)
```bash
cd infra/terraform/envs/dev
terraform init
terraform plan
terraform apply
```

## Notes
- Uses AWS EKS module with IRSA enabled.
- You must configure AWS credentials and remote state before applying.
