# This module is the server side for running RPC over AMQP.
# Using pika to invoke RabbitMQ for the same.
import pika
import random
import sys
import uuid


args = sys.argv
if len(args) == 3:
    HOSTURI = sys.argv[1]
    EXCHANGE = sys.argv[2]
elif len(args) == 2:
    HOSTURI = sys.argv[1]
    EXCHANGE = ''
else:
    HOSTURI = 'localhost'
    EXCHANGE = ''


class BasicMathOperators(object):

    def __init__(self):

        connURI = pika.ConnectionParameters(HOSTURI)
        self.connection = pika.BlockingConnection(connURI)
        self.channel = self.connection.channel()
        result = self.channel.queue_declare(exclusive=True)
        self.callback_queue = result.method.queue
        self.channel.basic_consume(self.on_response, no_ack=True,
                                   queue=self.callback_queue)

    def on_response(self, ch, method, props, body):
        if self.corr_id == props.correlation_id:
            self.response = body

    def call(self, n):
        self.response = None
        self.corr_id = str(uuid.uuid4())
        basicProperties = pika.BasicProperties(
            reply_to=self.callback_queue,
            correlation_id=self.corr_id,
        )

        self.channel.basic_publish(exchange='',
                                   routing_key='rpc_queue',
                                   properties=basicProperties,
                                   body=str(n))

        while self.response is None:
            self.connection.process_data_events()
        return int(self.response)


mathOps = BasicMathOperators()

print(" [x] Requesting addition")
response = mathOps.call(random.randrange(30))
print(" [.] Got %s" % response)
