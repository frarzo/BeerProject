import paho.mqtt.client as mosquitto
import json
import mysql.connector

broker = '192.168.1.110'
port = 1883

client = mosquitto.Client("RaspberryPi HUB")


def on_publish(client, userdata, result):
    print(f"Data published: {result}")
    pass


def on_message(client, userdata, message):
    # print(message.topic)
    try:
      decoded_message = str(message.payload.decode('utf-8'))  #In caso di tag mal formattati
    except Exception:
        print("UHMMMM")
        return
    if message.topic == "beer/requests":
        # print(f'Message received: {decoded_message}\n, TOPIC = {message.topic}\nQoS = {message.qos}\n RETAIN = {message.retain}')
        payload = json.loads(decoded_message)
        id = payload['id']
        cmd = payload['cmd']
        global idPompa
        idPompa = payload['idPompa']

        cursor.execute(f"SELECT 1 FROM Utente WHERE id=\'{id}\';")
        result = cursor.fetchall()

        if result:
            #print('beer/pompa'+str(idPompa))
            client.publish('beer/pump'+str(idPompa), payload['cmd'])
        else:
            client.publish('beer/pump'+str(idPompa),'2') 
            return   #Se l'ID non è riconosciuto


    if message.topic == "beer/duration":
        payload = json.loads(decoded_message)
        print(payload['duration'])
        if int(payload['duration']) > 50:
            #idPompa = payload['idPompa']
            #print(f'idpompa={str(idPompa)}')
            # Arbitrariamente, erogati 45 ml/s
            mills = int(payload['duration'])*0.045
            id = payload['id']
            if id=="":
                return
            #idPompa = payload['idPompa']
            cursor.execute(f'SELECT beer_id FROM Pompa WHERE id=\'{idPompa}\'')
            result = cursor.fetchall()

            cursor.execute(
                f"INSERT INTO Consumazione (user_id,beer_id,quantita) VALUES (\'{id}\',{result[0][0]},{mills});")
            db.commit()


db = mysql.connector.connect(
    host="192.168.1.104", user="arzo", password="abcd1234", database="beer")
cursor = db.cursor()

client.on_publish = on_publish
client.on_message = on_message

client.connect(broker)

client.subscribe('beer/requests')
client.subscribe('beer/duration')

client.loop_forever()
