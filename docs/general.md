# General
* Follow the [PSR-2 guide](https://www.php-fig.org/psr/psr-2/) in terms of style.
* Try to keep class names informative but not too long.
* Follow Symfony conventions and [best practices](https://symfony.com/doc/current/best_practices/index.html).
* Separate application logic from presentation and data-persistence layers.
* Use namespaces to group all related classes into separate folders.
* Put stuff in the cache when its easy enough to invalidate.
* Use [messenger](https://symfony.com/doc/current/components/messenger.html) to delegate when you don't need to wait for data to return.
* Write documentation for all things outside of standard MVC functions.
* Write integration and unit tests for all new features (in that order of priority).
* All functionality needs to be "mockable", so that you can test every part of the app without 3rd party dependencies.
* Use strict_types, scalar type hinting and return type hinting.

## Exceptions
* All Exceptions that should terminate the current request (and return an error message to the user) should be handled
using Symfony [best practice](https://symfony.com/doc/current/controller/error_pages.html#use-kernel-exception-event).
* All Exceptions that should be handled in the controller, or just logged for debugging, should be wrapped in a
try catch block (catchable Exceptions).
* Use custom Exceptions for all catchable scenarios, and try to use standard Exceptions for fatal Exceptions.
* Use custom Exceptions to log.

## Models
Models should only be data-persistence layers, i.e. defines relationships, attributes, helper methods
but does not fetch collections of data.

## Repositories
Most application logic in controllers should be wrapped in repository functions.
Never lazyload more than you need.

## Events
Events for models are handled by event listeners. Please follow instruction [here](https://symfony.com/doc/current/event_dispatcher.html).

## Controllers
Keep controllers clean of application logic. They should ideally just inject repositories - either through
the constructor (if used more than once) or in the controller method itself.

## Serializers
Use [Serializer component](https://symfony.com/doc/current/components/serializer.html) to transform model data into JSON.

## Services
Isolate 3rd party dependencies into Service classes for simple refactoring/extension.
