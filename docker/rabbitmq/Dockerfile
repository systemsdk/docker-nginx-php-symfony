FROM rabbitmq:4.2-management-alpine

COPY rabbitmq_delayed_message_exchange-4.2.0.ez /opt/rabbitmq/plugins/
RUN rabbitmq-plugins enable --offline rabbitmq_delayed_message_exchange
