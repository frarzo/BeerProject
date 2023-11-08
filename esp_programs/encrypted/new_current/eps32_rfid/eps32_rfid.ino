#include <SPI.h>
#include <MFRC522.h>
#include <PubSubClient.h>
#include <WiFi.h>
#include <ArduinoJson.h>

#define SS_PIN 5    // ESP32 pin GPIO5
#define RST_PIN 27  // ESP32 pin GPIO27


MFRC522 rfid(SS_PIN, RST_PIN);
WiFiClient WIFIclient;
PubSubClient client(WIFIclient);

unsigned long timeStart = 0;
unsigned long timeEnd = 0;
bool tagPresent = false;

const char* ssid = "dev";
const char* password = "WbdL57ak12";
const char* broker = "192.168.1.110";
const char* topicRequests = "beer/requests";
const char* topicDuration = "beer/duration";
const int port = 1883;
const uint8_t pageAddress = 0x06;
const int idPompa = 1;

byte PSWBuff[] = { 0x31, 0x32, 0x33, 0x34 };  // 32 bit password
byte pACK[] = { 0x00, 0x00 };                 // 16 bit password ACK returned by the NFC tag

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

    if (client.connect("ESP32-NFCTagReader")) {
      Serial.println("Connected to Broker as ESP32-NFCTagReader");
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

//TODO: - Migliora i nomi, sono poco intuitivi
//      - Elimina variabili commentate inutili da tentativi precedenti
String readUserID() {
  //char buffer[24];  //24 chars included endstring
  byte Bytesbuffer[18];
  byte size = sizeof(Bytesbuffer);
  char buff[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0 };
  //memcpy(Bytesbuffer, "00000000", 8);

  //Serial.print("Auth: ");
  MFRC522::StatusCode AuthStatus = (MFRC522::StatusCode)rfid.PCD_NTAG216_AUTH(&PSWBuff[0], pACK);
  if (AuthStatus != MFRC522::STATUS_OK) {
    Serial.print(F("Auth: FAILED "));
    Serial.println(rfid.GetStatusCodeName(AuthStatus));
    return "";
  } else {
    //Serial.println("SUCCESSFUL");
  }


  MFRC522::StatusCode ReadStatus = (MFRC522::StatusCode)rfid.MIFARE_Read(pageAddress, Bytesbuffer, &size);
  if (ReadStatus != MFRC522::STATUS_OK) {
    Serial.print(F("MIFARE_Read() failed: "));
    Serial.println(rfid.GetStatusCodeName(ReadStatus));
    return "";
  }

  for (int i = 0; i < sizeof(buff); i++) {
    buff[i] = (char)Bytesbuffer[i];
  }
  buff[8] = '\0';


  //sprintf(buffer, "%02X%02X%02X%02X%02X%02X%02X%02X\0", buff[0], buff[1], buff[2], buff[3], buff[4], buff[5], buff[6], buff[7]);
  //client.publish(topic, buffer);
  return buff;
}

void reconnect() {
  // Loop until we're reconnected
  while (!client.connected()) {
    //Serial.print("DISCONNECTED! Attempting MQTT connection...");
    // Create a random client ID
    String clientId = "ESP32-NFCTagReader";

    // Attempt to connect
    if (client.connect(clientId.c_str())) {
      Serial.print("");
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      // Wait 5 seconds before retrying
      delay(5000);
    }
  }
}

//Non so perché devo mettere 3 volte il wakeup ma così funziona, provato a caso
//Se elimino anche uno non funziona quindi non toccare

void loop() {

  if (!client.connected()) {
    reconnect();
  }

  MFRC522::StatusCode status = rfid.PICC_WakeupA(bufferATQA, &bufferSize);
  //Serial.print("Before check, status - ");
  //Serial.println(status, DEC);
  static String uid_tag = "";

  if (rfid.PICC_IsNewCardPresent() && rfid.PICC_ReadCardSerial()) {
    //Serial.println(rfid.uid.sak,HEX);
    if (rfid.uid.sak != 0x00) {
      return;
    }

    uid_tag = readUserID();
    status = rfid.PICC_WakeupA(bufferATQA, &bufferSize);
    //Serial.print("Inside IF, status - ");
    //Serial.println(status, DEC);

    if (!tagPresent) {  // if tagPresent = false, then the tag has just "arrived"

      const int capacity = JSON_OBJECT_SIZE(3);
      StaticJsonDocument<capacity> JsonDoc;

      if (uid_tag.isEmpty()) {
        return;
      }
      JsonDoc["id"] = uid_tag.c_str();
      JsonDoc["idPompa"] = idPompa;
      JsonDoc["cmd"] = "1";
      char payload[64];

      serializeJson(JsonDoc, payload);

      if (client.publish(topicRequests, payload)) {
        Serial.println("MQTT publish to topic beer/requests");
        serializeJson(JsonDoc, Serial);
        Serial.println();
      }

      //Serial.println(uid_tag);
      tagPresent = true;
      timeStart = millis();
      //Serial.println("Tag NFC RILEVATO!");
    }

  } else {
    if (tagPresent) {  //at some point there was a tag, but it's gone now
      Serial.print("\n");
      timeEnd = millis();
      unsigned long duration = timeEnd - timeStart;
      Serial.print("Tag NFC stayed for ");
      Serial.print(duration);
      Serial.println(" ms\n");

      //--------------------------------------

      const int capacity1 = JSON_OBJECT_SIZE(3);
      StaticJsonDocument<capacity1> JsonDoc1;

      JsonDoc1["id"] = uid_tag.c_str();
      JsonDoc1["idPompa"] = idPompa;
      JsonDoc1["cmd"] = "0";

      char payload1[72];

      serializeJson(JsonDoc1, payload1);

      if (client.publish(topicRequests, payload1)) {
        Serial.println("MQTT publish to topic beer/requests");
        serializeJson(JsonDoc1, Serial);
        Serial.println();
      }

      //--------------------------------------

      const int capacity2 = JSON_OBJECT_SIZE(2) + 8;  //In caso di null, aggiungere bytes alla capacità
      StaticJsonDocument<capacity2> JsonDoc2;
      //Serial.println(String(duration));
      JsonDoc2["id"] = uid_tag.c_str();
      JsonDoc2["duration"] = String(duration);
      char payload2[48];

      Serial.print("\n");
      serializeJson(JsonDoc2, payload2);

      if (client.publish(topicDuration, payload2)) {
        Serial.println("MQTT publish to topic beer/duration");
        serializeJsonPretty(JsonDoc2, Serial);
        Serial.println("\n----------------------");
      }
      //  noted the last tag's time, reset
      tagPresent = false;
    }
  }
  status = rfid.PICC_WakeupA(bufferATQA, &bufferSize);
  //Serial.print("End, status - ");
  //Serial.println(status, DEC);
}
