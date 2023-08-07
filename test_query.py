import mysql.connector
from mysql.connector import Error
try:
    db = mysql.connector.connect(
        host="192.168.1.104", database="beer",user="arzo", password="abcd1234")
    for el in db:
        print(el)
except Error as e:
    print("Error in connecting to mysql",e)

