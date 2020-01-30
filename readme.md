# PHP symfony environment
Docker environment required to run Symfony (based on official php and mysql docker hub repositories).

[![Actions Status](https://github.com/dimadeush/docker-nginx-php-symfony/workflows/Symfony%20App/badge.svg)](https://github.com/dimadeush/docker-nginx-php-symfony/actions)
[![CircleCI](https://circleci.com/gh/dimadeush/docker-nginx-php-symfony.svg?style=svg)](https://circleci.com/gh/dimadeush/docker-nginx-php-symfony)
[![Coverage Status](https://coveralls.io/repos/github/dimadeush/docker-nginx-php-symfony/badge.svg)](https://coveralls.io/github/dimadeush/docker-nginx-php-symfony)

[Source code](https://github.com/dimadeush/docker-nginx-php-symfony.git)

## Requirements
* Docker version 18.06 or later
* Docker compose version 1.22 or later
* An editor or IDE
* MySQL Workbench

Note: OS recommendation - Linux Ubuntu based.

## Components
1. Nginx 1.17
2. PHP 7.4 fpm
3. MySQL 8
4. Symfony 4.4
5. RabbitMQ 3

## Setting up DEV environment
1.Clone this repository from GitHub.

2.Set another APP_SECRET for application in .env.prod file.

Note 1: You can get unique secret key for example [here](http://nux.net/secret).

Note 2: Do not use .env.local.php on dev and test environment (delete it if exist).

3.Add domain to local 'hosts' file:
```bash
127.0.0.1    localhost
```

4.Configure `/docker/dev/xdebug.ini` (optional):

- In case you need debug only requests with IDE KEY: PHPSTORM from frontend in your browser:
```bash
xdebug.remote_autostart = 0
```
Install locally in Firefox extension "Xdebug helper" and set in settings IDE KEY: PHPSTORM

- In case you need debug any request to an api (by default):
```bash
xdebug.remote_autostart = 1
```

5.Build, start and install the docker images from your terminal:
```bash
docker-compose build
make start
make composer-install
```

6.Make sure that you have installed migrations:
```bash
make migrate
```

7.In order to use this application, please open in your browser next url: [http://localhost/api/doc](http://localhost/api/doc).

## Getting shell to container
After application will start (`make start`) and in order to get shell access inside symfony container you can run following command:
```bash
make ssh
```
Note 1: Please use next make commands in order to enter in other containers: `make ssh-nginx`, `make ssh-supervisord`, `make ssh-mysql`.

Note 2: Please use `exit` command in order to return from container's shell to local shell.

## Building containers
In case you edited Dockerfile or other environment configuration you'll need to build containers again using next commands:
```bash
make stop
docker-compose build
make start
```
Note: Please use next command if you need to build prod environment `docker-compose -f docker-compose-prod.yml build` instead `docker-compose build`.

## Start and stop environment
Please use next make commands in order to start and stop environment:
```bash
make start
make stop
```
Note: For prod environment need to be used next make commands: `make start-prod`, `make stop-prod`.

## Additional main command available
```bash
make start
make start-test
make start-prod

make stop
make stop-test
make stop-prod

make restart
make restart-test
make restart-prod

make env-prod

make ssh
make ssh-nginx
make ssh-supervisord
make ssh-mysql
make ssh-rabbitmq

make composer-install-prod
make composer-install
make composer-update

make info

make logs
make logs-nginx
make logs-supervisord
make logs-mysql
make logs-rabbitmq

make drop-migrate
make migrate
make migrate-prod

make fixtures

make phpunit
make report-code-coverage

make phpcs
make ecs
make ecs-fix
make phpmetrics

etc....
```
Notes: Please see more commands in Makefile

## Architecture & packages
* [Symfony 4.4](https://symfony.com)
* [doctrine-migrations-bundle](https://github.com/doctrine/DoctrineMigrationsBundle)
* [doctrine-fixtures-bundle](https://github.com/doctrine/DoctrineFixturesBundle)
* [command-scheduler-bundle](https://github.com/j-guyon/CommandSchedulerBundle)
* [phpunit](https://github.com/sebastianbergmann/phpunit)
* [phpunit-bridge](https://github.com/symfony/phpunit-bridge)
* [browser-kit](https://github.com/symfony/browser-kit)
* [css-selector](https://github.com/symfony/css-selector)
* [security-checker](https://github.com/sensiolabs/security-checker)
* [messenger](https://symfony.com/doc/current/messenger.html)
* [serializer-pack](https://packagist.org/packages/symfony/serializer-pack)
* [amqp](https://packagist.org/packages/symfony/amqp-pack)
* [composer-bin-plugin](https://github.com/bamarni/composer-bin-plugin)
* [security-advisories](https://github.com/Roave/SecurityAdvisories)
* [php-coveralls](https://github.com/php-coveralls/php-coveralls)
* [easy-coding-standard](https://github.com/Symplify/EasyCodingStandard)
* [PhpMetrics](https://github.com/phpmetrics/PhpMetrics)

## Guidelines
* [Commands](docs/commands.md)
* [Development](docs/development.md)
* [Testing](docs/testing.md)
* [IDE PhpStorm configuration](docs/phpstorm.md)
* [Xdebug configuration](docs/xdebug.md)
* [Messenger component](docs/messenger.md)

## Working on your project
1. For new feature development, fork `develop` branch into a new branch with one of the two patterns:
    * `feature/{ticketNo}`
2. Commit often, and write descriptive commit messages, so its easier to follow steps taken when reviewing.
3. Push this branch to the repo and create pull request into `develop` to get feedback, with the format `feature/{ticketNo}` - "Short descriptive title of Jira task".
4. Iterate as needed.
5. Make sure that "All checks have passed" on CircleCI(or another one in case you are not using CircleCI) and status is green.
6. When PR is approved, it will be squashed & merged, into `develop` and later merged into `release/{No}` for deployment.
