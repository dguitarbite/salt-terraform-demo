#!/usr/lib/python2
# Server side script which accepts requests from RMQ.
# This script is continuously listening to the given channel/exchange/queue.
# Matches the metadata descriptor in this script to provide the right
# mathematical operator to work on.


import api
import basicmath
import json
import pika
from StringIO import StringIO


HOSTURI, EXCHANGE = api.getargs()

REQ_COUNT = 0
QUEUE = 'simplerpc'
credentials = pika.PlainCredentials('simplerpc', 'simplerpc')
parameters = pika.ConnectionParameters(host=HOSTURI, credentials=credentials)
connection = pika.BlockingConnection(parameters)
channel = connection.channel()
channel.queue_declare(queue=QUEUE)


def mathOps(values, operator='all'):

    output = {}
    mathstuff = basicmath.BasicMath()

    if operator in ('addition', 'all'):
        print "Hit ME! Add"
        output['addition'] = mathstuff.addition(values)

    if operator in ('multiplication' or 'all'):
        print "Hit ME! mul"
        output['multiplication'] = mathstuff.multiplication(values)

    if operator in ('division' or 'all'):
        print "Hit ME! div"
        output['division'] = mathstuff.division(values)

    if operator in ('modulus' or 'all'):
        print "Hit ME! mod"
        output['modulus'] = mathstuff.modulus(values)

    if operator in ('substraction' or 'all'):
        print "Hit ME! sub"
        output['substraction'] = mathstuff.substraction(values)

    return output


def on_request(ch, method, props, body):

    global REQ_COUNT

    REQ_COUNT += 1
    print(" [x] Listening ... Request Number: %i" % REQ_COUNT)
    body = json.load(StringIO(body))
    operator = body['operator']
    values = body['data']

    print(" [.] mathOps(%s)" % operator)
    response = json.dumps(mathOps(values, operator=operator), 
                                  separators=(',', ':'))
    print(" Output: %s\n" % response)
    basicProperties = pika.BasicProperties(correlation_id=props.correlation_id)
    ch.basic_publish(exchange='',
                     routing_key=props.reply_to,
                     properties=basicProperties,
                     body=str(response))
    ch.basic_ack(delivery_tag=method.delivery_tag)


channel.basic_qos(prefetch_count=1)
channel.basic_consume(on_request, queue=QUEUE)

try:
    print(" [x] Avaiting RPC requests")
    print(" [x] Starting RPC server\n")
    channel.start_consuming()
except KeyboardInterrupt:
    connection.close()
