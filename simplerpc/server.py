#!/usr/lib/python2
# Client side script which accepts requests from RMQ.
# This script is continuously listening to the given channel/exchange/queue.
# Matches the metadata descriptor in this script to provide the right
# mathematical operator to work on.


import api
import basicmath
import json
import pika


HOSTURI, EXCHANGE = api.getargs()


QUEUE = 'simplerpc'
credentials = pika.PlainCredentials('simplerpc', 'simplerpc')
parameters = pika.ConnectionParameters(host=HOSTURI, credentials=credentials)
connection = pika.BlockingConnection(parameters)
channel = connection.channel()
channel.queue_declare(queue=QUEUE)


def mathOps(n):

    mathstuff = basicmath.BasicMath()
    n = mathstuff.addition(n)
    n = mathstuff.division(n)
    n = mathstuff.modulus(n)
    n = mathstuff.multiplication(n)
    n = mathstuff.substraction(n)

    return n


def on_request(ch, method, props, body):

    body = json.loads(body)
    operator = body['operator']
    values = body['values']

    print(" [.] mathOps(%s)" % operator)
    response = json.dumps(mathOps(values))

    basicProperties = pika.BasicProperties(correlation_id=props.correlation_id)
    ch.basic_publish(exchange='',
                     routing_key=props.reply_to,
                     properties=basicProperties,
                     body=str(response))
    ch.basic_ack(delivery_tag=method.delivery_tag)


channel.basic_qos(prefetch_count=1)
channel.basic_consume(on_request, queue=QUEUE)

try:
    print(" [x] Awaiting RPC requests")
    channel.start_consuming()
except KeyboardInterrupt:
    connection.close()
