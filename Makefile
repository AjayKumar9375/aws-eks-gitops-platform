.PHONY: lint test check run terraform-fmt terraform-check terraform-plan

lint:
	cd services/demo-api && mvn -B -ntp spotless:check

test:
	cd services/demo-api && mvn -B -ntp test

check: lint test terraform-check

run:
	cd services/demo-api && mvn -B -ntp spring-boot:run

terraform-fmt:
	terraform fmt -recursive infra/terraform

terraform-check:
	terraform fmt -check -recursive infra/terraform

terraform-plan:
	cd infra/terraform/envs/dev && terraform init && terraform plan
