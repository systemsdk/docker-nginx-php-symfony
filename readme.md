# PHP symfony environment
Docker environment required to run Symfony (based on official php and mysql docker hub repositories).

[![CircleCI](https://circleci.com/gh/dimadeush/docker-nginx-php-symfony.svg?style=svg)](https://circleci.com/gh/dimadeush/docker-nginx-php-symfony)

[Source code](https://github.com/dimadeush/docker-nginx-php-symfony.git)

## Requirements
* Docker version 18.06 or later
* Docker compose version 1.22 or later
* An editor or IDE
* MySQL Workbench

Note: OS recommendation - Linux Ubuntu based.

## Components:
1. Nginx 1.15
2. PHP 7.3 fpm
3. MySQL 8
4. Symfony 4.2

## Setting up DEV environment
1. Set another APP_SECRET for application in .env.prod file.
    
    Note 1: You can get unique secret key for example [here](http://nux.net/secret).
    
    Note 2: Do not use .env.local.php on dev and test environment (delete it if exist).
2. Build and start the image from your terminal:
    ```
    docker-compose build
    make start
    make composer-install
    ```
3. Add domain to local 'hosts' file:
    ```
    127.0.0.1    localhost
    ```
4. Make sure that you have installed migrations/fixtures:
    ```
    make migrate
    make fixtures
    ```
5. Configure Xdebug:
    - In case you need debug only requests from frontend in Firefox:
        * Edit /docker/dev/xdebug.ini:
        ```
        xdebug.remote_autostart = 0
        ```
        * Restart container
        * Install locally in Firefox extension "Xdebug helper" and set in settings IDE KEY: PHPSTORM
        * Have fun with debugging
    - In case you need debug any request to an api:
        * Edit /docker/dev/xdebug.ini:
        ```
        xdebug.remote_autostart = 1
        ```
        * Restart container
        * Have fun with debugging

## Additional main command available:
    ```
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
    make ssh-supervisord
    
    make composer-install-prod
    make composer-install
    
    make composer-update
    
    make info
    
    make drop-migrate
    
    make migrate-prod
    make migrate
    
    make fixtures-prod
    make fixtures
    
    make phpunit
    
    etc....
    ```
    Notes: Please see more commands in Makefile

## Architecture & packages
* [Symfony 4.2](https://symfony.com)
* [doctrine-migrations-bundle](https://github.com/doctrine/DoctrineMigrationsBundle)
* [doctrine-fixtures-bundle](https://github.com/doctrine/DoctrineFixturesBundle)
* [command-scheduler-bundle](https://github.com/j-guyon/CommandSchedulerBundle)
* [phpunit](https://phpunit.de)
* [phpunit-bridge](https://github.com/symfony/phpunit-bridge)
* [phpunit-result-printer](https://github.com/mikeerickson/phpunit-pretty-result-printer)
* [browser-kit](https://github.com/symfony/browser-kit)
* [css-selector](https://github.com/symfony/css-selector)

## General guidelines
* **[General](docs/general.md)**

## Working on your project
1. For new feature development, fork `develop` branch into a new branch with one of the two patterns:
    * `feature/{ticketNo}`
2. Commit often, and write descriptive commit messages, so its easier to follow steps taken when reviewing.
3. Push this branch to the repo and create pull request into `develop` to get feedback, with the format `feature/{ticketNo}` - Short descriptive title of Jira task".
4. Iterate as needed.
5. Make sure that "All checks have passed" on circleci and status is green.
6. When PR is approved, it will be squashed & merged, into `develop` and later merged into `release/{No}` for deployment.
