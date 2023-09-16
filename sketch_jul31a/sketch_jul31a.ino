#include <SPI.h>
#include <MFRC522.h>
#include <PubSubClient.h>
#include <WiFi.h>

#define SS_PIN 5    // ESP32 pin GPIO5
#define RST_PIN 27  // ESP32 pin GPIO27

MFRC522 rfid(SS_PIN, RST_PIN);
WiFiClient WIFIclient;
PubSubClient client(WIFIclient);

unsigned long timeStart = 0;
unsigned long timeEnd = 0;
bool tagPresent = false;

const char* ssid = "TP-Link";
const char* password = "WbdL57ak12";
const char* broker = "192.168.1.110";
const char* topic = "test";
const int port = 1883;

byte bufferATQA[2];
byte bufferSize = sizeof(bufferATQA);

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
  Serial.println("Use an RFID tag");
}


String readUID() {
  char buff[] = { 0, 0, 0, 0, 0, 0, 0, 0 };
  char buffer[24];  //24 chars included endstring

  for (int i = 0; i < rfid.uid.size; i++) {
    buff[i] = rfid.uid.uidByte[i];
  }
  sprintf(buffer, "%02X %02X %02X %02X %02X %02X %02X %02X\0", buff[0], buff[1], buff[2], buff[3], buff[4], buff[5], buff[6], buff[7]);
  client.publish(topic, buffer);
  return buffer;
}



//Non so perché devo mettere 3 volte il wakeup ma così funziona, provato a caso
//Se elimino anche uno non funziona quindi non toccare

void loop() {
  MFRC522::StatusCode status = rfid.PICC_WakeupA(bufferATQA, &bufferSize);
  //Serial.print("Before check, status - ");
  //Serial.println(status, DEC);


  if (rfid.PICC_IsNewCardPresent() && rfid.PICC_ReadCardSerial()) {


    status = rfid.PICC_WakeupA(bufferATQA, &bufferSize);
    //Serial.print("Inside IF, status - ");
    //Serial.println(status, DEC);

    if (!tagPresent) {  // if tagPresent = false, then the tag has just "arrived"
      if(client.publish(topic,"Rilevato un tag! Attiva pompa")){
        Serial.println("mandato attiva pompa");
      }
      Serial.println(readUID());
      tagPresent = true;
      timeStart = millis();
      Serial.println("Tag NFC RILEVATO!");
    }

  } else {
    if (tagPresent) {  //at some point there was a tag, but it's gone now
      Serial.print("\n");
      timeEnd = millis();
      unsigned long duration = timeEnd - timeStart;
      Serial.print("Tag NFC stayed for ");
      Serial.print(duration);
      Serial.println(" ms");
      client.publish(topic,String(duration).c_str());
      //  noted the last tag's time, reset
      tagPresent = false;
    }
  }
  status = rfid.PICC_WakeupA(bufferATQA, &bufferSize);
  //Serial.print("End, status - ");
  //Serial.println(status, DEC);
}
