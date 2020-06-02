import pika
from deal_generator import generate_deal
connection = pika.BlockingConnection(pika.ConnectionParameters('localhost'))
channel = connection.channel()

channel.exchange_declare(exchange='exchange', exchange_type='direct')
channel.queue_declare(queue='requests')
channel.queue_declare(queue='responses')
channel.queue_bind(exchange='exchange', queue='requests', routing_key='request')
channel.queue_bind(exchange='exchange', queue='responses', routing_key='response')

def callback(ch, method, properties, body):
    request = body.decode("utf-8")
    deal = generate_deal(request)
    deal_encoded = deal.encode("utf-8")
    channel.basic_publish(exchange='exchange',
                      routing_key='response',
                      body=deal_encoded)

channel.basic_consume(queue='requests',
                      auto_ack=True,
                      on_message_callback=callback)

channel.start_consuming()