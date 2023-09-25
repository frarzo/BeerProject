# <img src="docs/icons/../../app/beerstation/android/app/src/main/ic_launcher-playstore.png" width="31"> BeerStation

Project for my IoT's course @UniUD.

<div>
<a href='https://www.raspberrypi.com/'><img src="docs/icons/raspberry-pi-svgrepo-com.svg" width="48"></a>
<a href='https://mqtt.org/'><img src="docs/icons/mqtt-ver.svg" width="58"></a>
<a href=''><img src="docs/icons/ISO_C++_Logo.svg.png" width="43"></a>
<a href='https://www.python.org/'><img src="docs/icons/python-svgrepo-com.svg" width="48"></a>
<a href='https://www.espressif.com/'><img src="docs/icons/espressif-svgrepo-com.svg" width="48"></a>
<a href='https://www.mysql.com/it/'><img src="docs/icons/mysql-logo-svgrepo-com.svg" width="60"></a>
<a href='https://flutter.dev/'><img src="docs/icons/flutter-svgrepo-com.svg" width="45"></a>
<a href='https://www.php.net/'><img src="docs/icons/new-php-logo.svg" width="70"></a>
</div>


This project I developed is my submission for my _Internet of Things'_ exam.

I tried to implement as many things as possible I've learned to use during the course and using the ESP programmable boards I've previously played with.

Arzon Francesco - 142439

## Folder Structure:
*API folder* contains the php server files used to create an API for the mobile application.  
*esp_programs folder* contains the sketches loaded onto the ESP boards.  
*DB folder* contains the tables for the database and some py files used to populate the database.  
*app folder* contains the files and classes used to build the mobile app with Flutter.  
*rasp_server.py* is the Python server that runs on the Raspberry Pi.  

<details>
<summary>Brief tree folder view with the essential files</summary>

```
beerproject/
├─ API/
│  ├─ login.php
│  ├─ register.php
│  ├─ resetdebt.php
│  ├─ getconsumazioni.php
├─ esp_programs/
│  ├─ others/
│  │  ├─ dump.ino
│  │  ├─ esp8266_write_card.ino
│  ├─ current/
│  │  ├─ esp32_rfid.ino
│  │  ├─ esp8266_card_to_tag.ino
│  │  ├─ pump.ino
├─ DB/
│  ├─ TABLES/
│  │  ├─ create_tables.sql
│  │  ├─ ER model.mwb
│  │  ├─ backup.sql
├─ app/
│  ├─ beerstation/
│  │  ├─ lib/
│  │  │  ├─ obj/
│  │  │  │  ├─ consumazione.dart
│  │  │  │  ├─ user.dart
│  │  │  ├─ screens/
│  │  │  │  ├─ homepage.dart
│  │  │  ├─ users/
│  │  │  │  ├─ login_screen.dart
│  │  │  │  ├─ register_screen.dart
│  │  │  ├─ main.dart
│  │  │  ├─ utils.dart
├─ docs/
│  ├─ app_images/
│  ├─ diagrams/
│  │  ├─ wiring/
│  ├─ icons/
│  ├─ Relazione IOT Arzon 142439.doc
```
</details>

## App Screenshots:

<div><img src='docs/app_images/login.jpg' width='150'>
<img src='docs/app_images/register.jpg' width='150'>
<img src='docs/app_images/home.jpg' width='150'>
<img src='docs/app_images/consumazioni.jpg' width='150'>
<img src='docs/app_images/saldo.jpg' width='150'></div>

## Details
PHP server
```
cd ./beerproject
php -S 0.0.0.0:80
```
On RaspPi (or other local PC)
```
mosquitto
```
```
python rasp_server.py
```
The main programs to flash on the ESP boards are located in Arduino/current  
Inside Arduino/others there is a sketch for writing userIDs on MIFARE 1K.
