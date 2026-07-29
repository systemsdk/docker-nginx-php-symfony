include .env
# Determine if .env.local file exist
ifneq ("$(wildcard .env.local)", "")
	include .env.local
endif

ifndef INSIDE_DOCKER_CONTAINER
	INSIDE_DOCKER_CONTAINER = 0
endif

HOST_UID := $(shell id -u)
HOST_GID := $(shell id -g)
PHP_USER := -u www-data
PROJECT_NAME := -p ${COMPOSE_PROJECT_NAME}
OPENSSL_BIN := $(shell which openssl)
INTERACTIVE := $(shell [ -t 0 ] && echo 1)
ERROR_ONLY_FOR_HOST = @printf "\033[33mThis command for host machine\033[39m\n"
.DEFAULT_GOAL := help
ifneq ($(INTERACTIVE), 1)
	OPTION_T := -T
endif
ifeq ($(GITLAB_CI), 1)
	# Determine additional params for phpunit in order to generate coverage badge on GitLabCI side
	PHPUNIT_OPTIONS := --coverage-text --colors=never
endif

help: ## Show available commands and their descriptions
	@echo "\033[34mList of available commands:\033[39m"
	@grep -E '^[a-zA-Z-]+:.*?## .*$$' Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "[32m%-27s[0m %s\n", $$1, $$2}'

load-staging-env:
	$(eval include .env.staging)

load-prod-env:
	$(eval include .env.prod)

export HOST_UID HOST_GID NGINX_VERSION WEB_PORT_HTTP WEB_PORT_SSL XDEBUG_CONFIG XDEBUG_VERSION MYSQL_VERSION INNODB_USE_NATIVE_AIO SQL_MODE MYSQL_ROOT_PASSWORD MYSQL_PORT RABBITMQ_VERSION RABBITMQ_DELAYED_MESSAGE_EXCHANGE_VERSION RABBITMQ_ERLANG_COOKIE RABBITMQ_USER RABBITMQ_PASS RABBITMQ_MANAGEMENT_PORT

build: ## Build the development environment
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose -f compose.yaml build
else
	$(ERROR_ONLY_FOR_HOST)
endif

build-test: ## Build the test or CI environment
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose -f compose-test-ci.yaml build
else
	$(ERROR_ONLY_FOR_HOST)
endif

build-staging: load-staging-env ## Build the staging environment
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose -f compose-staging.yaml build
else
	$(ERROR_ONLY_FOR_HOST)
endif

build-prod: load-prod-env ## Build the production environment
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose -f compose-prod.yaml build
else
	$(ERROR_ONLY_FOR_HOST)
endif

start: ## Start the development environment
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose -f compose.yaml $(PROJECT_NAME) up -d
else
	$(ERROR_ONLY_FOR_HOST)
endif

start-test: ## Start the test or CI environment
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose -f compose-test-ci.yaml $(PROJECT_NAME) up -d
else
	$(ERROR_ONLY_FOR_HOST)
endif

start-staging: load-staging-env ## Start the staging environment
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose -f compose-staging.yaml $(PROJECT_NAME) up -d
else
	$(ERROR_ONLY_FOR_HOST)
endif

start-prod: load-prod-env ## Start the production environment
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose -f compose-prod.yaml $(PROJECT_NAME) up -d
else
	$(ERROR_ONLY_FOR_HOST)
endif

stop: ## Stop the development environment containers (without removing them)
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose -f compose.yaml $(PROJECT_NAME) stop
else
	$(ERROR_ONLY_FOR_HOST)
endif

stop-test: ## Stop the test or CI environment containers (without removing them)
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose -f compose-test-ci.yaml $(PROJECT_NAME) stop
else
	$(ERROR_ONLY_FOR_HOST)
endif

stop-staging: load-staging-env ## Stop the staging environment containers (without removing them)
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose -f compose-staging.yaml $(PROJECT_NAME) stop
else
	$(ERROR_ONLY_FOR_HOST)
endif

stop-prod: load-prod-env ## Stop the production environment containers (without removing them)
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose -f compose-prod.yaml $(PROJECT_NAME) stop
else
	$(ERROR_ONLY_FOR_HOST)
endif

down: ## Stop and remove the development environment containers and networks
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose -f compose.yaml $(PROJECT_NAME) down
else
	$(ERROR_ONLY_FOR_HOST)
endif

down-test: ## Stop and remove the test or CI environment containers and networks
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose -f compose-test-ci.yaml $(PROJECT_NAME) down
else
	$(ERROR_ONLY_FOR_HOST)
endif

down-staging: load-staging-env ## Stop and remove the staging environment containers and networks
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose -f compose-staging.yaml $(PROJECT_NAME) down
else
	$(ERROR_ONLY_FOR_HOST)
endif

down-prod: load-prod-env ## Stop and remove the production environment containers and networks
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose -f compose-prod.yaml $(PROJECT_NAME) down
else
	$(ERROR_ONLY_FOR_HOST)
endif

restart: stop start ## Restart the development environment
restart-test: stop-test start-test ## Restart the test or CI environment
restart-staging: stop-staging start-staging ## Restart the staging environment
restart-prod: stop-prod start-prod ## Restart the production environment

env-prod: ## Create cached config file .env.local.php (for production)
	@make exec cmd="composer dump-env prod"

env-staging: ## Create cached config file .env.local.php (for staging)
	@make exec cmd="composer dump-env staging"

ssh: ## Access the bash shell inside the symfony container
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose $(PROJECT_NAME) exec $(OPTION_T) $(PHP_USER) symfony bash
else
	$(ERROR_ONLY_FOR_HOST)
endif

ssh-root: ## Access the bash shell as root inside the symfony container
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose $(PROJECT_NAME) exec $(OPTION_T) symfony bash
else
	$(ERROR_ONLY_FOR_HOST)
endif

fish: ## Access the fish shell inside the symfony container
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose $(PROJECT_NAME) exec $(OPTION_T) $(PHP_USER) symfony fish
else
	$(ERROR_ONLY_FOR_HOST)
endif

ssh-nginx: ## Access the bash shell inside the nginx container
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose $(PROJECT_NAME) exec nginx /bin/sh
else
	$(ERROR_ONLY_FOR_HOST)
endif

ssh-supervisord: ## Access the bash shell inside the supervisord container (cron jobs, etc.)
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose $(PROJECT_NAME) exec supervisord bash
else
	$(ERROR_ONLY_FOR_HOST)
endif

ssh-mysql: ## Access the bash shell inside the mysql container
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose $(PROJECT_NAME) exec mysql bash
else
	$(ERROR_ONLY_FOR_HOST)
endif

ssh-rabbitmq: ## Access the bash shell inside the rabbitmq container
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose $(PROJECT_NAME) exec rabbitmq /bin/sh
else
	$(ERROR_ONLY_FOR_HOST)
endif

exec:
ifeq ($(INSIDE_DOCKER_CONTAINER), 1)
	@$$cmd
else
	@docker compose $(PROJECT_NAME) exec $(OPTION_T) $(PHP_USER) symfony $$cmd
endif

exec-bash:
ifeq ($(INSIDE_DOCKER_CONTAINER), 1)
	@bash -c "$(cmd)"
else
	@docker compose $(PROJECT_NAME) exec $(OPTION_T) $(PHP_USER) symfony bash -c "$(cmd)"
endif

exec-by-root:
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker compose $(PROJECT_NAME) exec $(OPTION_T) symfony $$cmd
else
	$(ERROR_ONLY_FOR_HOST)
endif

report-prepare: ## Create the /reports/coverage folder (used for test reports)
	@make exec cmd="mkdir -p reports/coverage"

report-clean: ## Remove all generated reports in the /reports/ folder
	@make exec-by-root cmd="rm -rf reports/*"

wait-for-db: ## Check MySQL database availability (useful for CI/CD, e.g. /.circleci)
	@make exec cmd="php bin/console db:wait"

composer-install-no-dev: ## Install Composer dependencies (excluding dev packages)
	@make exec-bash cmd="COMPOSER_MEMORY_LIMIT=-1 composer install --optimize-autoloader --no-dev"

composer-install: ## Install all Composer dependencies
	@make exec-bash cmd="COMPOSER_MEMORY_LIMIT=-1 composer install --optimize-autoloader"

composer-update: ## Update Composer dependencies
	@make exec-bash cmd="COMPOSER_MEMORY_LIMIT=-1 composer update"

composer-audit: ## Check installed packages for security vulnerabilities
	@make exec-bash cmd="COMPOSER_MEMORY_LIMIT=-1 composer audit --abandoned=report"

info: ## Show the current PHP and Symfony versions
	@make exec cmd="php --version"
	@make exec cmd="bin/console about"
	@make exec cmd="composer --version"

logs: ## View logs from the symfony container (use ctrl+c to exit)
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker logs -f ${COMPOSE_PROJECT_NAME}-symfony
else
	$(ERROR_ONLY_FOR_HOST)
endif

logs-nginx: ## View logs from the nginx container (use ctrl+c to exit)
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker logs -f ${COMPOSE_PROJECT_NAME}-nginx
else
	$(ERROR_ONLY_FOR_HOST)
endif

logs-supervisord: ## View logs from the supervisord container (use ctrl+c to exit)
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker logs -f ${COMPOSE_PROJECT_NAME}-supervisord
else
	$(ERROR_ONLY_FOR_HOST)
endif

logs-mysql: ## View logs from the mysql container (use ctrl+c to exit)
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker logs -f ${COMPOSE_PROJECT_NAME}-mysql
else
	$(ERROR_ONLY_FOR_HOST)
endif

logs-rabbitmq: ## View logs from the rabbitmq container (use ctrl+c to exit)
ifeq ($(INSIDE_DOCKER_CONTAINER), 0)
	@docker logs -f ${COMPOSE_PROJECT_NAME}-rabbitmq
else
	$(ERROR_ONLY_FOR_HOST)
endif

drop-migrate: ## Drop databases and run all migrations for main/test databases
	@make exec cmd="php bin/console doctrine:schema:drop --full-database --force"
	@make exec cmd="php bin/console doctrine:schema:drop --full-database --force --env=test"
	@make migrate

migrate-no-test: ## Run all migrations for the main database only
	@make exec cmd="php bin/console doctrine:migrations:migrate --no-interaction"

migrate: ## Run all migrations for main/test databases
	@make exec cmd="php bin/console doctrine:migrations:migrate --no-interaction"
	@make exec cmd="php bin/console doctrine:migrations:migrate --no-interaction --env=test"

fixtures: ## Run fixtures for the test database, without --append option (tables are dropped and recreated)
	@make exec cmd="php bin/console doctrine:fixtures:load --env=test --no-interaction"

messenger-setup-transports: ## Initialize transports for the Symfony Messenger component
	@make exec cmd="php bin/console messenger:setup-transports"

phpunit: ## Run the PHPUnit test suite
	@make exec-bash cmd="rm -rf ./var/cache/test* && bin/console cache:warmup --env=test && ./vendor/bin/phpunit -c phpunit.xml.dist --coverage-html reports/coverage $(PHPUNIT_OPTIONS) --coverage-clover reports/clover.xml --log-junit reports/junit.xml"

report-code-coverage: ## Update code coverage report on Coveralls.io (requires COVERALLS_REPO_TOKEN, should be set on CI side)
	@make exec-bash cmd="export COVERALLS_REPO_TOKEN=${COVERALLS_REPO_TOKEN} && php ./vendor/bin/php-coveralls -v --coverage_clover reports/clover.xml --json_path reports/coverals.json"

phpcs: ## Run PHP CodeSniffer checks
	@make exec-bash cmd="./vendor/bin/phpcs --version && ./vendor/bin/phpcs --standard=PSR12 --colors -p src tests"

ecs: ## Run Easy Coding Standard (ECS) checks
	@make exec-bash cmd="./vendor/bin/ecs --version && ./vendor/bin/ecs --clear-cache check src tests"

ecs-fix: ## Run Easy Coding Standard to automatically fix issues
	@make exec-bash cmd="./vendor/bin/ecs --version && ./vendor/bin/ecs --clear-cache --fix check src tests"

phpmetrics: ## Generate a PhpMetrics static analysis report
ifeq ($(INSIDE_DOCKER_CONTAINER), 1)
	@mkdir -p reports/phpmetrics
	@if [ ! -f reports/junit.xml ] ; then \
		printf "\033[32;49mjunit.xml not found, running tests...\033[39m\n" ; \
		./vendor/bin/phpunit -c phpunit.xml.dist --coverage-html reports/coverage --coverage-clover reports/clover.xml --log-junit reports/junit.xml ; \
	fi;
	@echo "\033[32mRunning PhpMetrics\033[39m"
	@php ./vendor/bin/phpmetrics --version
	@php ./vendor/bin/phpmetrics --junit=reports/junit.xml --report-html=reports/phpmetrics .
else
	@make exec-by-root cmd="make phpmetrics"
endif

phpcpd: ## Run PHP Copy/Paste Detector
	@make exec-bash cmd="mkdir -p reports/phpcpd && php ./vendor/bin/phpcpd --fuzzy --verbose --log-pmd=reports/phpcpd/phpcpd-report-v1.xml src tests"

phpcpd-html-report: ## Generate an HTML report for PHP Copy/Paste Detector
ifeq ($(INSIDE_DOCKER_CONTAINER), 1)
	@if [ ! -f reports/phpcpd/phpcpd-report-v1.xml ] ; then \
		printf "\033[32;49mreports/phpcpd/phpcpd-report-v1.xml not found, please run phpcpd.\033[39m\n" ; \
	else \
		printf "\033[32;49mCreating reports/phpcpd/phpcpd-report-v1.html report...\033[39m\n" ; \
		xalan -in reports/phpcpd/phpcpd-report-v1.xml -xsl https://systemsdk.github.io/phpcpd/report/phpcpd-html-v1_0_0.xslt -out reports/phpcpd/phpcpd-report-v1.html ; \
	fi;
else
	@make exec-bash cmd="make phpcpd-html-report"
endif

phpmd: ## Run PHP Mess Detector
	@make exec cmd="php ./vendor/bin/phpmd analyze --format=text --ruleset=phpmd_ruleset.xml --suffixes=php src tests"

phpstan: ## Run PHPStan static analysis
ifeq ($(INSIDE_DOCKER_CONTAINER), 1)
	@echo "\033[32mRunning PHPStan - PHP Static Analysis Tool\033[39m"
	@bin/console cache:clear --env=test
	@./vendor/bin/phpstan --version
	@./vendor/bin/phpstan analyze src tests
else
	@make exec cmd="make phpstan"
endif

phpinsights: ## Run PHP Insights analysis
ifeq ($(INSIDE_DOCKER_CONTAINER), 1)
	@echo "\033[32mRunning PHP Insights\033[39m"
	@php -d error_reporting=0 ./vendor/bin/phpinsights analyse --no-interaction --min-quality=100 --min-complexity=84 --min-architecture=100 --min-style=100
else
	@make exec cmd="make phpinsights"
endif

composer-normalize: ## Normalize the composer.json file structure
	@make exec cmd="composer normalize"

composer-validate: ## Validate the composer.json file syntax
	@make exec cmd="composer validate --no-check-version"

composer-require-checker: ## Check defined dependencies against actual code usage
	@make exec-bash cmd="XDEBUG_MODE=off php ./vendor/bin/composer-require-checker"

composer-unused: ## Detect unused Composer packages by scanning namespaces
	@make exec-bash cmd="XDEBUG_MODE=off php ./vendor/bin/composer-unused"
