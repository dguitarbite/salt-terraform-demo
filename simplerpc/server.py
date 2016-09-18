import basicmath
import pika
import sys


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

    n = int(body)

    print(" [.] mathOps(%s)" % n)
    response = mathOps(n)

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
