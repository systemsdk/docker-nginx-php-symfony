FROM rabbitmq:3.10-management-alpine

COPY rabbitmq_delayed_message_exchange-3.10.2.ez /opt/rabbitmq/plugins/
RUN rabbitmq-plugins enable --offline rabbitmq_delayed_message_exchange
