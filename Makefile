help: ## show help message
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[$$()% a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

tf-docs: ## creates terraform documentation
	@terraform-docs -c .config/.terraform-docs.yaml ./terraform

tf-lint: ## lints terraform code
	@cd terraform && tflint

tf-validate: ## validates terraform code
	@cd terraform && terraform validate

commit: tf-lint tf-docs ## commits all code to git
	@git add -A && pre-commit run -a --config=.config/.pre-commit-config.yaml && cz c && git push

sec-scan: ## security scanning
	@checkov -d . --config-file .config/.checkov.yaml

tf-init:
	@cd terraform && terraform init
tf-plan: tf-init-prime ## plans terraform changes 
	@cd terraform && terraform plan -var-file="terraform.tfvars" -out=.tfplan
tf-apply: ## applies planned terraform changes 
	@cd terraform && terraform apply ".tfplan"
tf-destroy: ## destroys the terraform changes 
	@cd terraform && terraform destroy -var-file="terraform.tfvars"

start: ## start docker
	@COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1 docker compose up --build && docker compose logs -f

stop: ## stop docker
	@COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1 docker compose stop

reset: ## reset docker
	@COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1 docker compose down --remove-orphans -v
