import paho.mqtt.client as mosquitto
import json

broker = '192.168.1.110'
port = 1883

client = mosquitto.Client("RaspberryPi HUB")


def on_publish(client, userdata, result):
    print(f"Data published \n: {result}")
    pass


def on_message(client, userdata, message):
    decoded_message=str(message.payload.decode('utf-8'))
    print(
        f'Message received: {decoded_message}\n, TOPIC = {message.topic}\nQoS = {message.qos}\n RETAIN = {message.retain}')
    cmd= json.loads(decoded_message)['cmd']

    client.publish('beer/pump',cmd)


client.on_publish = on_publish
client.on_message = on_message

client.connect(broker)

client.subscribe('beer/requests')

client.loop_forever()
