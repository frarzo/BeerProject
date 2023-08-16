import json, os
import mysql.connector

def read_json(path):
    if os.path.exists(path):
        with open(path, "r", encoding="utf8") as file:
            data = json.load(file)
        print(f"Data read from path: {path}")
        return data
    else:
        print(f"No data found at path: {path}")
        return {}

jsonUtenti = read_json("db stuff/utente.json")
db = mysql.connector.connect(host="localhost", user="arzo", password="abcd1234", database="beer")
cursor = db.cursor()

for utente in jsonUtenti:
    cursor.execute(f'INSERT INTO Utente(id,nome, cognome, email, psw, saldo, data_reg) VALUES (\'{utente["id"]}\',\'{utente["nome"]}\',\'{utente["cognome"]}\',\'{utente["email"]}\',\'{utente["psw"]}\',{utente["saldo"]},\'{utente["data_reg"]}\')')

db.commit()
cursor.close()
db.close()
