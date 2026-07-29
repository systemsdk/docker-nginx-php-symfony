ARG RABBITMQ_VERSION=4.2

FROM rabbitmq:${RABBITMQ_VERSION}-management-alpine

ARG RABBITMQ_DELAYED_MESSAGE_EXCHANGE_VERSION=4.2.0

COPY rabbitmq_delayed_message_exchange-${RABBITMQ_DELAYED_MESSAGE_EXCHANGE_VERSION}.ez /opt/rabbitmq/plugins/
RUN rabbitmq-plugins enable --offline rabbitmq_delayed_message_exchange
