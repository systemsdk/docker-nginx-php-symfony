FROM rabbitmq:3.11-management-alpine

COPY rabbitmq_delayed_message_exchange-3.11.1.ez /opt/rabbitmq/plugins/
RUN rabbitmq-plugins enable --offline rabbitmq_delayed_message_exchange
