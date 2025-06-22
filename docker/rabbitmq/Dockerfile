FROM rabbitmq:4.1-management-alpine

COPY rabbitmq_delayed_message_exchange-4.1.0.ez /opt/rabbitmq/plugins/
RUN rabbitmq-plugins enable --offline rabbitmq_delayed_message_exchange
