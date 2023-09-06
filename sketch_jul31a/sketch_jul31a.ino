/*
 * This ESP32 code is created by esp32io.com
 * This ESP32 code is released in the public domain
 * For more detail (instruction and wiring diagram), visit https://esp32io.com/tutorials/esp32-rfid-nfc
 */
#include <PubSubClient.h>
#include <SPI.h>
#include <MFRC522.h>
#include <WiFi.h>

#define SS_PIN 5    // ESP32 pin GPIO5
#define RST_PIN 27  // ESP32 pin GPIO27

const char* ssid = "TP-Link";
const char* password = "WbdL57ak12";
const char* broker = "192.168.1.110";
const char* topic = "test";
const int port = 1883;

MFRC522 rfid(SS_PIN, RST_PIN);
WiFiClient WIFIclient;
PubSubClient client(WIFIclient);

void setup() {
  Serial.begin(9600);

  WiFi.begin(ssid, password);
  Serial.print("Connecting to Wifi...");
  while (WiFi.status() != WL_CONNECTED) {
    delay(2000);
    Serial.print(".");
  }
  Serial.println("");

  client.setServer(broker, port);

  while (!client.connected()) {
    Serial.println("Connecting to MQTT Broker ...");

    if (client.connect("ESP32-cardReader")) {
      Serial.println("Connected to Broker as ESP32-cardReader");
    } else {
      Serial.print("Failed with state ");
      Serial.println(client.state());
      delay(1000);
    }
  }

  SPI.begin();      // init SPI bus
  rfid.PCD_Init();  // init MFRC522

  Serial.println("Tap an RFID/NFC tag on the RFID-RC522 reader");
}

void loop() {
  if (rfid.PICC_IsNewCardPresent()) {  // new tag is available
    Serial.println("NEW CARD PRESENT");
    //client.publish("test", "RFID letto\n");
    if (rfid.PICC_ReadCardSerial()) { 
      long int t1= millis();
      while(rfid.){
        Serial.print('Spillando\n');
        delay(1000);
      }
      long int t2= millis();
      Serial.println(t2-t1);

     // Serial.println("READ CARD SERIAL");
    }
  }
  //sleep(1);
}
