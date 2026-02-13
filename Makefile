.PHONY: install-dev lint test check run terraform-fmt terraform-check terraform-plan

install-dev:
	cd services/demo-api && pip install -r dev-requirements.txt

lint:
	ruff check services/demo-api
	ruff format --check services/demo-api

test:
	cd services/demo-api && pytest tests

check: lint test terraform-check

run:
	cd services/demo-api && python app.py

terraform-fmt:
	terraform fmt -recursive infra/terraform

terraform-check:
	terraform fmt -check -recursive infra/terraform

terraform-plan:
	cd infra/terraform/envs/dev && terraform init && terraform plan
