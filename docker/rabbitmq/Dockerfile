FROM rabbitmq:4.0-management-alpine

COPY rabbitmq_delayed_message_exchange-v4.0.7.ez /opt/rabbitmq/plugins/
RUN rabbitmq-plugins enable --offline rabbitmq_delayed_message_exchange
