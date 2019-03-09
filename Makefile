dir=${CURDIR}
project=-p symfony
service=symfony:latest

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
	@docker-compose $(project) exec symfony bash

ssh-supervisord:
	@docker-compose $(project) exec supervisord bash

exec:
	@docker-compose $(project) exec symfony $$cmd

clean:
	rm -rf $(dir)/reports/*

prepare:
	mkdir -p $(dir)/reports/coverage

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

logs-supervisord:
	@docker logs supervisord

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
	@make exec cmd="php bin/console doctrine:fixtures:load --append"

phpunit:
	@make exec cmd="./vendor/bin/simple-phpunit -c phpunit.xml.dist --log-junit reports/phpunit.xml --coverage-html reports/coverage --coverage-clover reports/coverage.xml"
