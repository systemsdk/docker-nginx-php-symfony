# Symfony Messenger & Asynchronous Processing
This document outlines the architectural guidelines and operational procedures for asynchronous task execution using the [Symfony Messenger](https://symfony.com/doc/current/messenger.html) component and RabbitMQ.

## Architectural Role
Symfony Messenger is the backbone of our asynchronous processing and event-driven architecture. It provides message buses to decouple application layers and route background tasks (e.g., sending emails, external API calls, processing heavy reports) to message queues.

Before implementing new asynchronous logic, ensure you are familiar with the core [Messenger component concepts](https://symfony.com/doc/current/components/messenger.html).

## Message Broker (RabbitMQ)
This environment utilizes [RabbitMQ](https://hub.docker.com/_/rabbitmq) as the primary message broker. It implements the Advanced Message Queuing Protocol (AMQP) to guarantee reliable message delivery and failover capabilities.

### Management UI (Admin Panel)
For manual management and monitoring, use the full-featured web interface. It allows you to view all existing queues, exchanges and bindings, as well as monitor message flow in real-time.

* URL: [http://localhost:15672](http://localhost:15672)
* Default Credentials: `guest` / `guest` (These can be modified in your `.env` configuration file).

### HTTP API & Documentation
RabbitMQ exposes a REST HTTP API for programmatic access to broker metrics and management.

* Local API Reference: When the container is running, the API documentation and help are accessible directly at [http://localhost:15672/api/](http://localhost:15672/api/).
* External API Reference: You can also refer to the [official RabbitMQ Management HTTP API reference](https://rawcdn.githack.com/rabbitmq/rabbitmq-server/v3.11.5/deps/rabbitmq_management/priv/www/api/index.html).

## Messages and Handlers
In accordance with our Domain-Driven Design (DDD) principles, asynchronous communication must strictly follow these rules:

* Messages (Application Layer): Messages are exclusively used for asynchronous operations. They must be strictly typed, immutable and as small as possible. A smaller message payload ensures faster broker routing and maximizes processing speed. Never serialize full Doctrine Entities into a message. Always pass scalar values or Entity IDs (UUIDs). This keeps the payload lightweight and prevents data staleness or `EntityManager` detachment issues.
    * Example: `App\Message\TestMessage`
* Handlers (Transport Layer): They act as adapters between the message broker and our core application. Their sole responsibility is to receive the asynchronous message, unpack the payload (e.g., extract the UUID) and delegate the execution to the corresponding Application Service. A Handler must never contain business logic or manipulate Domain entities directly.
    * Example: `App\MessageHandler\TestHandler`

For basic implementation details, refer to the official documentation:
* [Creating a Message](https://symfony.com/doc/current/messenger.html#creating-a-message-handler)
* [Creating a Message Handler](https://symfony.com/doc/current/messenger.html#creating-a-message-handler)

## Transports Initialization
Before dispatching or consuming messages, you must initialize the configured transports. This process creates the required routing infrastructure in RabbitMQ and sets up the database table for failed messages (Dead Letter Queue).

To set up the transports, execute the following command:
```bash
make messenger-setup-transports
```

Note: After executing this command, all necessary RabbitMQ queues, exchanges and bindings will be created, along with the MySQL table for failed messages.

## Consuming Messages
Messages dispatched to asynchronous transports are not executed immediately. They are queued in RabbitMQ and processed by background worker processes.

Currently, workers are managed automatically by Supervisor across all environments (including local setups for `dev`, `test`, `staging` and `prod`). If you notice that messages are sitting in the queue and not being consumed, verify the worker status by executing the following command in your local shell:
```bash
make logs-supervisord
```

> 🏗️ DevOps Note for Production:
> While bundling Supervisor inside the application container is a pragmatic and necessary solution for all our local environments (including local `staging` and `production` setups), any actual remote deployments to live servers should be refactored by the DevOps team. Remote infrastructure must follow the strict containerization best practice of "one process per container" (e.g., separating PHP-FPM and Messenger workers into completely distinct containers/pods).
