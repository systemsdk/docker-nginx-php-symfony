# Development
This document contains basic information and recommendation for development this application.

## General
* Follow the [PSR-1 guide](https://www.php-fig.org/psr/psr-1/), [PSR-2 guide](https://www.php-fig.org/psr/psr-2/), [Coding Standards](http://symfony.com/doc/current/contributing/code/standards.html).
* Try to keep class names informative but not too long.
* Follow Symfony conventions and [best practices](https://symfony.com/doc/current/best_practices/index.html).
* Separate application logic from presentation and data-persistence layers.
* Use namespaces to group all related classes into separate folders.
* Put stuff in the cache when its easy enough to invalidate.
* Use [messenger](https://symfony.com/doc/current/components/messenger.html) to delegate when you don't need to wait for data to return.
* Write documentation for all things outside of standard MVC functions.
* Write integration, functional and unit tests for all new features (in that order of priority).
* All functionality needs to be "mockable", so that you can test every part of the app without 3rd party dependencies.
* Use strict_types, type hinting and return type hinting.

Within this application the base workflow is following:

`Controller/Command <--> Resource <--> Repository <--> Entity`

#### Exceptions
* All Exceptions that should terminate the current request (and return an error message to the user) should be handled
using Symfony [best practice](https://symfony.com/doc/current/controller/error_pages.html#use-kernel-exception-event).
* All Exceptions that should be handled in the controller, or just logged for debugging, should be wrapped in a
try catch block (catchable Exceptions).
* Use custom Exceptions for all catchable scenarios, and try to use standard Exceptions for fatal Exceptions.
* Use custom Exceptions to log.

#### Entities
Entities should only be data-persistence layers, i.e. defines relationships, attributes, helper methods
but does not fetch collections of data.

#### Repositories
Repositories need to be responsible for parameter handling and query builder callbacks/joins.
Parameter handling can help with generic REST queries.

#### Resources
Resource services are layer between your controller/command and repository.
Within this layer it is possible to control how to `mutate` repository data for application needs.
Resource services are basically the application foundation and it can control your request and response as you like.

#### Controllers
Keep controllers clean of application logic. They should ideally just inject resources/services - either through
the constructor (if used more than once) or in the controller method itself.

#### Events
Events are handled by event listeners. Please follow instruction [here](https://symfony.com/doc/current/event_dispatcher.html).

#### Serializers
Use [Serializer component](https://symfony.com/doc/current/components/serializer.html) to transform data into JSON.

#### Services
Isolate 3rd party dependencies into Service classes for simple refactoring/extension.


## IDE
Short list of most popular IDE for PHP development:

* [PhpStorm](https://www.jetbrains.com/phpstorm/)
* [Zend Studio](https://www.zend.com/products/zend-studio)
* [Eclipse PDT](https://www.eclipse.org/pdt/)
* [NetBeans](https://netbeans.org/)
* [Sublime Text](https://www.sublimetext.com/)


## PHP Code Sniffer
This tool is an essential development tool that ensures your code remains clean and consistent.
PHP Code Sniffer is available for dev/test environment using next symfony container shell command:
```bash
./vendor/bin/phpcs -i
```
Note: Also you can use make command (`make phpcs`) in your local shell.

If you are using [PhpStorm](https://www.jetbrains.com/phpstorm/) you can configure PHP Code Sniffer using recommendation
[here](https://www.jetbrains.com/help/phpstorm/using-php-code-sniffer.html).


## Database changes
Doctrine migrations it is functionality for versioning your database schema and easily deploying changes to it.
Migration files contain all necessary database changes to get application running with its database structure.
In order to migrate changes to your database please use next command in symfony container shell:
```bash
./bin/console doctrine:migrations:migrate
```
Note: Also you can use make command (`make migrate`) in your local shell and it will make necessary changes to main database and test database.

Please use next workflow for migrations:

1. Make changes (create/edit/delete) to entities in `/src/Entity/` folder
2. Run `diff` command to create new migration file
3. Run `migrate` command to make actual changes to your database
4. Run `validate` command to validate your mappings and actual database structure

Above commands you can run in symfony container shell using next: `./bin/console doctrine:migrations:<command>`.

Using above workflow allow you make database changes on your application. 
Also you do not need to make any migrations files by hand (Doctrine will handle it). 
Please always check generated migration files to make sure that those doesn't contain anything that you really don't want.
