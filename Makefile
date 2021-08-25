dir=${CURDIR}

ifndef APP_ENV
	include .env
	# Determine if .env.local file exist
	ifneq ("$(wildcard .env.local)","")
		include .env.local
	endif
endif

symfony_user=-u www-data
project=-p ${COMPOSE_PROJECT_NAME}
service=${COMPOSE_PROJECT_NAME}:latest
openssl_bin:=$(shell which openssl)
interactive:=$(shell [ -t 0 ] && echo 1)
ifneq ($(interactive),1)
	optionT=-T
endif
ifeq ($(GITLAB_CI),1)
	# Determine additional params for phpunit in order to generate coverage badge on GitLabCI side
	phpunitOptions=--coverage-text --colors=never
endif

build:
	@docker-compose -f docker-compose.yml build

build-test:
	@docker-compose -f docker-compose-test-ci.yml build

build-staging:
	@docker-compose -f docker-compose-staging.yml build

build-prod:
	@docker-compose -f docker-compose-prod.yml build

start:
	@docker-compose -f docker-compose.yml $(project) up -d

start-test:
	@docker-compose -f docker-compose-test-ci.yml $(project) up -d

start-staging:
	@docker-compose -f docker-compose-staging.yml $(project) up -d

start-prod:
	@docker-compose -f docker-compose-prod.yml $(project) up -d

stop:
	@docker-compose -f docker-compose.yml $(project) down

stop-test:
	@docker-compose -f docker-compose-test-ci.yml $(project) down

stop-staging:
	@docker-compose -f docker-compose-staging.yml $(project) down

stop-prod:
	@docker-compose -f docker-compose-prod.yml $(project) down

restart: stop start
restart-test: stop-test start-test
restart-staging: stop-staging start-staging
restart-prod: stop-prod start-prod

env-prod:
	@make exec cmd="composer dump-env prod"

env-staging:
	@make exec cmd="composer dump-env staging"

ssh:
	@docker-compose $(project) exec $(optionT) $(symfony_user) symfony bash

ssh-nginx:
	@docker-compose $(project) exec nginx /bin/sh

ssh-supervisord:
	@docker-compose $(project) exec supervisord bash

ssh-mysql:
	@docker-compose $(project) exec mysql bash

ssh-rabbitmq:
	@docker-compose $(project) exec rabbitmq /bin/sh

exec:
	@docker-compose $(project) exec $(optionT) $(symfony_user) symfony $$cmd

exec-bash:
	@docker-compose $(project) exec $(optionT) $(symfony_user) symfony bash -c "$(cmd)"

exec-by-root:
	@docker-compose $(project) exec $(optionT) symfony $$cmd

report-prepare:
	mkdir -p $(dir)/reports/coverage

report-clean:
	rm -rf $(dir)/reports/*

wait-for-db:
	@make exec cmd="php bin/console db:wait"

composer-install-no-dev:
	@make exec-bash cmd="COMPOSER_MEMORY_LIMIT=-1 composer install --optimize-autoloader --no-dev"

composer-install:
	@make exec-bash cmd="COMPOSER_MEMORY_LIMIT=-1 composer install --optimize-autoloader"

composer-update:
	@make exec-bash cmd="COMPOSER_MEMORY_LIMIT=-1 composer update"

info:
	@make exec cmd="bin/console --version"
	@make exec cmd="php --version"

logs:
	@docker logs -f ${COMPOSE_PROJECT_NAME}_symfony

logs-nginx:
	@docker logs -f ${COMPOSE_PROJECT_NAME}_nginx

logs-supervisord:
	@docker logs -f ${COMPOSE_PROJECT_NAME}_supervisord

logs-mysql:
	@docker logs -f ${COMPOSE_PROJECT_NAME}_mysql

logs-rabbitmq:
	@docker logs -f ${COMPOSE_PROJECT_NAME}_rabbitmq

drop-migrate:
	@make exec cmd="php bin/console doctrine:schema:drop --full-database --force"
	@make exec cmd="php bin/console doctrine:schema:drop --full-database --force --env=test"
	@make migrate

migrate-no-test:
	@make exec cmd="php bin/console doctrine:migrations:migrate --no-interaction --all-or-nothing"

migrate:
	@make exec cmd="php bin/console doctrine:migrations:migrate --no-interaction --all-or-nothing"
	@make exec cmd="php bin/console doctrine:migrations:migrate --no-interaction --all-or-nothing --env=test"

fixtures:
	@make exec cmd="php bin/console doctrine:fixtures:load --env=test"

messenger-setup-transports:
	@make exec cmd="php bin/console messenger:setup-transports"

phpunit:
	@make exec-bash cmd="rm -rf ./var/cache/test* && bin/console cache:warmup --env=test && ./vendor/bin/phpunit -c phpunit.xml.dist --coverage-html reports/coverage $(phpunitOptions) --coverage-clover reports/clover.xml --log-junit reports/junit.xml"

###> php-coveralls ###
report-code-coverage: ## update code coverage on coveralls.io. Note: COVERALLS_REPO_TOKEN should be set on CI side.
	@make exec-bash cmd="export COVERALLS_REPO_TOKEN=${COVERALLS_REPO_TOKEN} && php ./vendor/bin/php-coveralls -v --coverage_clover reports/clover.xml --json_path reports/coverals.json"
###< php-coveralls ###

###> phpcs ###
phpcs: ## Run PHP CodeSniffer
	@make exec-bash cmd="./vendor/bin/phpcs --version && ./vendor/bin/phpcs --standard=PSR12 --colors -p src tests"
###< phpcs ###

###> ecs ###
ecs: ## Run Easy Coding Standard
	@make exec-bash cmd="./vendor/bin/ecs --version && ./vendor/bin/ecs --clear-cache check src tests"

ecs-fix: ## Run The Easy Coding Standard to fix issues
	@make exec-bash cmd="./vendor/bin/ecs --version && ./vendor/bin/ecs --clear-cache --fix check src tests"
###< ecs ###

###> phpmetrics ###
phpmetrics:
	@make exec-by-root cmd="make phpmetrics-process"

phpmetrics-process: ## Generates PhpMetrics static analysis, should be run inside symfony container
	@mkdir -p reports/phpmetrics
	@if [ ! -f reports/junit.xml ] ; then \
		printf "\033[32;49mjunit.xml not found, running tests...\033[39m\n" ; \
		./vendor/bin/phpunit -c phpunit.xml.dist --coverage-html reports/coverage --coverage-clover reports/clover.xml --log-junit reports/junit.xml ; \
	fi;
	@echo "\033[32mRunning PhpMetrics\033[39m"
	@php ./vendor/bin/phpmetrics --version
	@php ./vendor/bin/phpmetrics --junit=reports/junit.xml --report-html=reports/phpmetrics .
###< phpmetrics ###

###> php copy/paste detector ###
phpcpd:
	@make exec cmd="php phpcpd.phar --fuzzy src tests"
###< php copy/paste detector ###

###> php mess detector ###
phpmd:
	@make exec cmd="php ./vendor/bin/phpmd src text phpmd_ruleset.xml --suffixes php"
###< php mess detector ###

###> PHPStan static analysis tool ###
phpstan:
	@echo "\033[32mRunning PHPStan - PHP Static Analysis Tool\033[39m"
	@make exec cmd="bin/console cache:clear --env=test"
	@make exec cmd="./vendor/bin/phpstan --version"
	@make exec cmd="./vendor/bin/phpstan analyze src tests"
###< PHPStan static analysis tool ###

###> Phpinsights PHP quality checks ###
phpinsights:
	@echo "\033[32mRunning PHP Insights\033[39m"
	@make exec cmd="php -d error_reporting=0 ./vendor/bin/phpinsights analyse --no-interaction --min-quality=100 --min-complexity=85 --min-architecture=100 --min-style=100"
###< Phpinsights PHP quality checks ###
