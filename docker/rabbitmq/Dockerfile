FROM rabbitmq:3.9-management-alpine

COPY rabbitmq_delayed_message_exchange-3.9.0.ez /opt/rabbitmq/plugins/
RUN rabbitmq-plugins enable --offline rabbitmq_delayed_message_exchange
