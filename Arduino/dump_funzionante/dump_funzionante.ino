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
    Serial.println("LETTURA\n");
    //client.publish("test", "RFID letto\n");
    if (rfid.PICC_ReadCardSerial()) {                                 // NUID has been readed
      MFRC522::PICC_Type piccType = rfid.PICC_GetType(rfid.uid.sak);  //sak è il byte risposta di ntag213, indica che il tag è univocamente selezionato e solo questo reader comunica con esso anche con altri device nfc nei paraggi
      //Serial.println(rfid.uid.sak);
      Serial.print("RFID/NFC Tag Type: ");
      Serial.println(rfid.PICC_GetTypeName(piccType));

      String buffer;
      // print UID in Serial Monitor in the hex format
      //Serial.print("Dimensione UID è: ");
      Serial.printf("Dimensione UID è: %d\n", rfid.uid.size);
      Serial.print("\nUID HEX:");
      for (int i = 0; i < rfid.uid.size; i++) {
        //buffer = buffer + ((rfid.uid.uidByte[i] < 0x10) ? " 0" : " ");
        //buffer = buffer + (rfid.uid.uidByte[i]);
        Serial.print(rfid.uid.uidByte[i] < 0x10 ? " 0" : " ");
        Serial.print(rfid.uid.uidByte[i]);
      }
      Serial.println();
      //Serial.println("UID DEC: " + buffer);

      //Serial.println(rfid.uid.uidByte[8],DEC);

      rfid.PICC_DumpToSerial(&(rfid.uid));  //DUMPS EVERYTHING TO SERIAL


      rfid.PICC_HaltA();       // halt PICC
      rfid.PCD_StopCrypto1();  // stop encryption on PCD
    }
  }
  sleep(1);
}
