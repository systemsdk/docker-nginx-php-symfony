dir=${CURDIR}
project=-p symfony
service=symfony:latest
interactive:=$(shell [ -t 0 ] && echo 1)
ifneq ($(interactive),1)
	optionT=-T
endif

start:
	@docker-compose -f docker-compose.yml $(project) up -d

start-test:
	@docker-compose -f docker-compose-test-ci.yml $(project) up -d

start-prod:
	@docker-compose -f docker-compose-prod.yml $(project) up -d

stop:
	@docker-compose -f docker-compose.yml $(project) down

stop-test:
	@docker-compose -f docker-compose-test-ci.yml $(project) down

stop-prod:
	@docker-compose -f docker-compose-prod.yml $(project) down

restart: stop start
restart-test: stop-test start-test
restart-prod: stop-prod start-prod

env-prod:
	@make exec cmd="composer dump-env prod"

ssh:
	@docker-compose $(project) exec $(optionT) symfony bash

ssh-nginx:
	@docker-compose $(project) exec nginx /bin/sh

ssh-supervisord:
	@docker-compose $(project) exec supervisord bash

ssh-mysql:
	@docker-compose $(project) exec mysql bash

ssh-rabbitmq:
	@docker-compose $(project) exec rabbitmq /bin/sh

exec:
	@docker-compose $(project) exec $(optionT) symfony $$cmd

exec-bash:
	@docker-compose $(project) exec $(optionT) symfony bash -c "$(cmd)"

report-prepare:
	mkdir -p $(dir)/reports/coverage

report-clean:
	rm -rf $(dir)/reports/*

wait-for-db:
	@make exec cmd="php bin/console db:wait"

composer-install-prod:
	@make exec cmd="composer install --optimize-autoloader --no-dev"

composer-install:
	@make exec cmd="composer install --optimize-autoloader"

composer-update:
	@make exec cmd="composer update"

info:
	@make exec cmd="bin/console --version"
	@make exec cmd="php --version"

logs:
	@docker logs -f symfony

logs-nginx:
	@docker logs -f nginx

logs-supervisord:
	@docker logs -f supervisord

logs-mysql:
	@docker logs -f mysql

logs-rabbitmq:
	@docker logs -f rabbitmq

drop-migrate:
	@make exec cmd="php bin/console doctrine:schema:drop --full-database --force"
	@make exec cmd="php bin/console doctrine:schema:drop --full-database --force --env=test"
	@make migrate

migrate-prod:
	@make exec cmd="php bin/console doctrine:migrations:migrate --no-interaction"

migrate:
	@make exec cmd="php bin/console doctrine:migrations:migrate --no-interaction"
	@make exec cmd="php bin/console doctrine:migrations:migrate --no-interaction --env=test"

fixtures:
	@make exec cmd="php bin/console doctrine:fixtures:load --env=test"

phpunit:
	@make exec cmd="./vendor/bin/phpunit -c phpunit.xml.dist --coverage-html reports/coverage --coverage-clover reports/clover.xml --log-junit reports/junit.xml"

###> php-coveralls ###
report-code-coverage: ## update code coverage on coveralls.io. Note: COVERALLS_REPO_TOKEN should be set on CI side.
	@make exec-bash cmd="export COVERALLS_REPO_TOKEN=${COVERALLS_REPO_TOKEN} && php ./vendor/bin/php-coveralls -v --coverage_clover reports/clover.xml --json_path reports/coverals.json"
###< php-coveralls ###

###> phpcs ###
phpcs: ## Run PHP CodeSniffer
	@make exec-bash cmd="./vendor/bin/phpcs --version && ./vendor/bin/phpcs --standard=PSR2 --colors -p src"
###< phpcs ###

###> ecs ###
ecs: ## Run Easy Coding Standard
	@make exec-bash cmd="error_reporting=0 ./vendor/bin/ecs --clear-cache check src"

ecs-fix: ## Run The Easy Coding Standard to fix issues
	@make exec-bash cmd="error_reporting=0 ./vendor/bin/ecs --clear-cache --fix check src"
###< ecs ###

###> phpmetrics ###
phpmetrics:
	@make exec cmd="make phpmetrics-process"

phpmetrics-process: ## Generates PhpMetrics static analysis, should be run inside symfony container
	@mkdir -p reports/phpmetrics
	@if [ ! -f reports/junit.xml ] ; then \
		printf "\033[32;49mjunit.xml not found, running tests...\033[39m\n" ; \
		./vendor/bin/phpunit -c phpunit.xml.dist --coverage-html reports/coverage --coverage-clover reports/clover.xml --log-junit reports/junit.xml ; \
	fi;
	@echo "\033[32mRunning PhpMetrics\033[39m"
	@php ./vendor/bin/phpmetrics --version
	@./vendor/bin/phpmetrics --junit=reports/junit.xml --report-html=reports/phpmetrics .
###< phpmetrics ###
