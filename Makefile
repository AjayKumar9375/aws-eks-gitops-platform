.PHONY: lint test check run terraform-fmt terraform-check terraform-plan helm-lint kustomize-check

lint:
	cd services/demo-api && mvn -B -ntp spotless:check

test:
	cd services/demo-api && mvn -B -ntp test

check: lint test terraform-check helm-lint kustomize-check

run:
	cd services/demo-api && mvn -B -ntp spring-boot:run

terraform-fmt:
	terraform fmt -recursive infra/terraform

terraform-check:
	terraform fmt -check -recursive infra/terraform

terraform-plan:
	cd infra/terraform/envs/dev && terraform init && terraform plan

helm-lint:
	helm lint services/demo-api/helm/demo-api

kustomize-check:
	kubectl kustomize gitops/apps/overlays/dev >/dev/null
	kubectl kustomize gitops/apps/overlays/prod >/dev/null
	kubectl kustomize platform/monitoring >/dev/null
	kubectl kustomize platform/security >/dev/null
