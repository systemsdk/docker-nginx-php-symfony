FROM rabbitmq:4.0-management-alpine

COPY rabbitmq_delayed_message_exchange-4.0.2.ez /opt/rabbitmq/plugins/
RUN rabbitmq-plugins enable --offline rabbitmq_delayed_message_exchange
