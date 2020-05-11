# Messenger
This document describing how you can use [messenger](https://symfony.com/doc/current/messenger.html) within this environment.

## Using messenger
### Description
Symfony's Messenger provides a message bus and some routing capabilities to send messages within your application and through transports such as message queues. Before using it, read the [Messenger component](https://symfony.com/doc/current/components/messenger.html) docs to get familiar with its concepts.
### RabbitMQ
This environment is using [RabbitMQ](https://hub.docker.com/_/rabbitmq) message broker software. RabbitMQ is open source message broker software (sometimes called message-oriented middleware) that implements the Advanced Message Queuing Protocol (AMQP). The RabbitMQ server is written in the Erlang programming language and is built on the Open Telecom Platform framework for clustering and failover. Client libraries to interface with the broker are available for all major programming languages.
### Admin panel
You can use your browser in order to manage/view messages. Just open next url in your browser: http://localhost:15672. Default login - guest and password - guest. You can change it in compose file if it is necessary.
### Consuming Messages
Once your messages have been routed, it will be consumed. In case any issue just make sure that program:messenger is working in supervisord. You can use make command "make logs-supervisord" for this needs.
### Message and Handler
Before you can send a message, you must create it first. In order to do something when your message is dispatched, you need to create a message handler. Please follow docs in order to implement it:

* [Message](https://symfony.com/doc/current/messenger.html#message)
* [Handler](https://symfony.com/doc/current/messenger.html#registering-handlers)

## RabbitMQ Management HTTP API
When activated, the management plugin provides an HTTP API at http://server-name:15672/api/ by default. Browse to that location for more information on the API. For convenience the same API reference is available from GitHub:
* [RabbitMQ Management HTTP API](https://rawcdn.githack.com/rabbitmq/rabbitmq-management/v3.8.3/priv/www/api/index.html)
