#!/usr/lib/python2
# Server side script which accepts requests from RMQ.
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


def mathOps(values, operator='all'):

    output = {}
    mathstuff = basicmath.BasicMath()

    if ('addition' or 'all') in operator:
        output['addition'] = mathstuff.addition(values)
    elif ('multiplication' or 'all') in operator:
        output['multiplication'] = mathstuff.multiplication(values)
    elif ('division' or 'all') in operator:
        output['division'] = mathstuff.division(values)
    elif ('modulus' or 'all') in operator:
        output['modulus'] = mathstuff.modulus(values)
    elif ('substraction' or 'all') in operator:
        output['substraction'] = mathstuff.substraction(values)

    return output


def on_request(ch, method, props, body):

    body = json.loads(body)
    operator = body['operator']
    values = body['data']

    print(" [.] mathOps(%s)" % operator)
    response = json.dumps(mathOps(values, operator=operator))
    print(" Output: %s" % response)
    print("\n\n\n\n")
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
