# Commands
This document describing commands that can be used in local shell or inside symfony container shell.

## Local shell (Makefile)
This environment comes with "Makefile" and it allow to simplify using some functionality.
In order to use command listed bellow just use next syntax in your local shell: `make {command name}`.
Next commands available for this environment:
```bash
make help                       # Shows available commands with description

make build                      # Build dev environment
make build-test                 # Build test or continuous integration environment
make build-staging              # Build staging environment
make build-prod                 # Build prod environment

make start                      # Start dev environment
make start-test                 # Start test or continuous integration environment
make start-staging              # Start staging environment
make start-prod                 # Start prod environment

make stop                       # Stop dev environment containers
make stop-test                  # Stop test or continuous integration environment containers
make stop-staging               # Stop staging environment containers
make stop-prod                  # Stop prod environment containers

make down                       # Stop and remove dev environment containers, networks
make down-test                  # Stop and remove test or continuous integration environment containers, networks
make down-staging               # Stop and remove staging environment containers, networks
make down-prod                  # Stop and remove prod environment containers, networks

make restart                    # Stop and start dev environment
make restart-test               # Stop and start test or continuous integration environment
make restart-staging            # Stop and start staging environment
make restart-prod               # Stop and start prod environment

make env-staging                # Creates cached config file .env.local.php (usually for staging environment)
make env-prod                   # Creates cached config file .env.local.php (usually for prod environment)

make ssh                        # Get bash inside symfony docker container
make ssh-root                   # Get bash as root user inside symfony docker container
make ssh-nginx                  # Get bash inside nginx docker container
make ssh-supervisord            # Get bash inside supervisord docker container (cron jobs running there, etc...)
make ssh-mysql                  # Get bash inside mysql docker container
make ssh-rabbitmq               # Get bash inside rabbitmq docker container

make exec                       # Exucutes some command, under the www-data user, defined in cmd="..." variable inside symfony container shell
make exec-bash                  # Executes several commands, under the www-data user, defined in cmd="..." variable inside symfony container shell
make exec-by-root               # Executes some command, under the root user, defined in cmd="..." variable inside symfony container shell

make report-prepare             # Creates /reports/coverage folder, will be used for report after running tests
make report-clean               # Removes all reports in /reports/ folder

make wait-for-db                # Checks MySQL database availability, using for CI (f.e. /.circleci folder)

make composer-install-no-dev    # Installs composer no-dev dependencies
make composer-install           # Installs composer dependencies
make composer-update            # Updates composer dependencies

make info                       # Shows Php and Symfony version

make logs                       # Shows logs for symfony container. Use ctrl+c in order to exit
make logs-nginx                 # Shows logs for nginx container. Use ctrl+c in order to exit
make logs-supervisord           # Shows logs for supervisord container. Use ctrl+c in order to exit
make logs-mysql                 # Shows logs for mysql container. Use ctrl+c in order to exit
make logs-rabbitmq              # Shows logs for rabbitmq container. Use ctrl+c in order to exit

make drop-migrate               # Drops databases and runs all migrations for the main/test databases
make migrate                    # Runs all migrations for the main/test databases
make migrate-no-test            # Runs all migrations for the main database

make fixtures                   # Runs all fixtures for test database without --append option (tables will be dropped and recreated)

make messenger-setup-transports # Initializes transports for Symfony Messenger bundle

make phpunit                    # Runs PhpUnit tests
make report-code-coverage       # Updates code coverage report on https://coveralls.io (COVERALLS_REPO_TOKEN should be set on CI side)

make ecs                        # Runs Easy Coding Standard tool
make ecs-fix                    # Runs Easy Coding Standard tool to fix issues
make phpcs                      # Runs PHP CodeSniffer
make phpmetrics                 # Generates PhpMetrics static analysis report
make phpcpd                     # Runs php copy/paste detector
make phpmd                      # Runs php mess detector
make phpstan                    # Runs PhpStan static analysis tool
make phpinsights                # Runs Php Insights analysis tool

make composer-normalize         # Normalizes composer.json file content
make composer-validate          # Validates composer.json file content
make composer-require-checker   # Checks the defined dependencies against your code
make composer-unused            # Shows unused packages by scanning and comparing package namespaces against your code
```

## Symfony container shell
Inside symfony container shell available "native" symfony commands with their description and, in additional, custom commands.
In order to enter inside symfony container shell please use next command on your local shell:
```bash
make ssh
```
After above command you will be inside symfony container and for display list of available commands please use next command:
```bash
./bin/console
```
#### Custom commands in symfony container shell
```bash
./bin/console db:wait                    # Waits for database availability (1 mins max)
./bin/console messenger:setup-transports # Initializes transports for Symfony Messenger bundle
```
