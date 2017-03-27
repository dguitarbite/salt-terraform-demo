#!/usr/bin/python2
# This module is the client side for running RPC over AMQP.
# Using pika to invoke RabbitMQ for the same.


import api
import json
import pika
import random
import time
import uuid


HOSTURI, EXCHANGE = api.getargs()


QUEUE = 'simplerpc'


class BasicMathOperators(object):

    def __init__(self):

        credentials = pika.PlainCredentials('simplerpc', 'simplerpc')
        connURI = pika.ConnectionParameters(host=HOSTURI,
                                            credentials=credentials)
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
                                   routing_key=QUEUE,
                                   properties=basicProperties,
                                   body=str(n))

        while self.response is None:
            self.connection.process_data_events()
        return int(self.response)


mathOps = BasicMathOperators()

# TODO(dbite): Invoke multiple threads of this connection.
while True:
   
    time.sleep(5)

    try:
        numbers = random.sample(range(1000), 10)
        mathoperators = ['addition', 'division', 'substraction', 'all', 'multiplication', 'modulus']
        operator = random.choice(mathoperators)
        print(" [x] Requesting %s" % operator)
        rpcData = json.dumps({'operator': operator, 
                            'data': numbers})
        response = (mathOps.call(rpcData))
        response = json.loads(response)
        print(" [.] Got the cumulative %s: %s " % operator, response)
    except:
        print(" Some random error, who cares!")
