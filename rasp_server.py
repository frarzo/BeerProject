import paho.mqtt.client as mosquitto
import json
import mysql.connector

#Setting up MQTT
broker = '192.168.1.110'
port = 1883
client = mosquitto.Client("RaspberryPi HUB")


def on_publish(client, userdata, result):
    pass

def on_message(client, userdata, message):
    # print(message.topic)
    #If something's odd
    try:
      decoded_message = str(message.payload.decode('utf-8'))  
    except Exception:
        print("Messaggio codificato male...")
        return
    
    # If there is a message from the ESP32 + RFID reader
    if message.topic == "beer/requests":
        # print(f'Message received: {decoded_message}\n, TOPIC = {message.topic}\nQoS = {message.qos}\n RETAIN = {message.retain}')
        payload = json.loads(decoded_message)
        id = payload['id']
        cmd = payload['cmd']
        global idPompa
        global result
        idPompa = payload['idPompa']
        print(f"---- Richiesta da Utente {id} alla Pompa {idPompa},  Comando: {cmd} ----")
        #Check if there's a user with that ID in the DB
        cursor.execute(f"SELECT 1 FROM Utente WHERE id=\'{id}\';")
        result = cursor.fetchall()

        if result:
            print('Success')
            client.publish('beer/pump'+str(idPompa), payload['cmd'])
        else:
            #Se l'ID non è riconosciuto
            print('Failed')
            client.publish('beer/pump'+str(idPompa),'2') 
            return   
        
    # If the tag has been removed, receive the duration 
    if message.topic == "beer/duration":
        print('Bicchiere rimosso')
        payload = json.loads(decoded_message)
        print(f"Erogati {int(payload['duration'])*0.045} mL")
        # If less than 50 ms, do not consider it
        if int(payload['duration']) > 50:
            #idPompa = payload['idPompa']
            #print(f'idpompa={str(idPompa)}')
            # Arbitrariamente, erogati 45 ml/s [da rivedere]
            mills = int(payload['duration'])*0.045
            id = payload['id']
            if id=="" or not result: #Se utente nullo o non compare nel DB, salta
                return
            #idPompa = payload['idPompa']
            # Check which beer is assigned to that pump
            cursor.execute(f'SELECT beer_id FROM Pompa WHERE id=\'{idPompa}\'')
            result = cursor.fetchall()
            # Saves the drinks to DB which will update the tab
            cursor.execute(
                f"INSERT INTO Consumazione (user_id,beer_id,quantita) VALUES (\'{id}\',{result[0][0]},{mills});")
            db.commit()
            print("---- Consumazione effettuata ----")
            

# Setting up DB connection
db = mysql.connector.connect(
    host="192.168.1.104", user="arzo", password="abcd1234", database="beer")
cursor = db.cursor()

# Subscribing to the topics and setting up MQTT functions
client.on_publish = on_publish
client.on_message = on_message

client.connect(broker)

client.subscribe('beer/requests')
client.subscribe('beer/duration')

client.loop_forever()
