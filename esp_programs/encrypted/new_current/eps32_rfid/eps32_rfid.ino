#include <SPI.h>
#include <MFRC522.h>
#include <PubSubClient.h>
#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <ArduinoJson.h>

#define SS_PIN 5    // ESP32 pin GPIO5
#define RST_PIN 27  // ESP32 pin GPIO27

unsigned long timeStart = 0;
unsigned long timeEnd = 0;
bool tagPresent = false;

const char* ssid = "dev";
const char* password = "WbdL57ak12";
const char* broker = "192.168.1.110";
const char* topicRequests = "beer/requests";
const char* topicDuration = "beer/duration";
const int port = 8883; //port 8883 for TLS, otherwise 1883 for thesis test
const uint8_t pageAddress = 0x06;
const int idPompa = 1;

byte PSWBuff[] = { 0x31, 0x32, 0x33, 0x34 };  // 32 bit password
byte pACK[] = { 0x00, 0x00 };                 // 16 bit password ACK returned by the NFC tag

byte bufferATQA[2];
byte bufferSize = sizeof(bufferATQA);

//certs for esp32 station

const char* ca_cert= \
"-----BEGIN CERTIFICATE-----\n" \
"MIIDnTCCAoWgAwIBAgIUcb6V2nxgsru5LWsgMkslH7WswiowDQYJKoZIhvcNAQEL\n" \
"BQAwXjELMAkGA1UEBhMCSVQxDjAMBgNVBAgMBWl0YWx5MRAwDgYDVQQHDAd0cmll\n" \
"c3RlMQ4wDAYDVQQKDAV1bml1ZDENMAsGA1UECwwEZG1pZjEOMAwGA1UEAwwFYXJ6\n" \
"b24wHhcNMjMxMTMwMTE0NzEwWhcNMjQxMTI5MTE0NzEwWjBeMQswCQYDVQQGEwJJ\n" \
"VDEOMAwGA1UECAwFaXRhbHkxEDAOBgNVBAcMB3RyaWVzdGUxDjAMBgNVBAoMBXVu\n" \
"aXVkMQ0wCwYDVQQLDARkbWlmMQ4wDAYDVQQDDAVhcnpvbjCCASIwDQYJKoZIhvcN\n" \
"AQEBBQADggEPADCCAQoCggEBAMunCxSraNNn1J0TAM6T1V1G6NosALZM+4Pd80PI\n" \
"1ghUU2GN5qkt71pYGr2ugeb8dzk3cfWkAnULzXDSxc2jDcY2pgz4pt7i7fO6/1Uj\n" \
"eWqwoZXGurtctOPGZqPKtHjDOFiyR6HConXse0fHhVqw15jGZZb06CXV+JmP959r\n" \
"D1s1DpcZx/pAxRmQu3xnzc0xkOFl2222EMlRuMbqaxxkStb3c+ebO7EuFQ0ONenf\n" \
"dNRSjIxpZpn1FvFOgQ2P5qMCmSEtT8qiE9NQ8/HpXTZANTkvAuRACMnXJrkBslow\n" \
"7MMtCP6fiMT+4s+cXLR16smOpdModmsDJ5sDWREirzW1TQMCAwEAAaNTMFEwHQYD\n" \
"VR0OBBYEFPQFKgjLzjTOruqfJiVJgMRWx2UAMB8GA1UdIwQYMBaAFPQFKgjLzjTO\n" \
"ruqfJiVJgMRWx2UAMA8GA1UdEwEB/wQFMAMBAf8wDQYJKoZIhvcNAQELBQADggEB\n" \
"AB/0ULDIrUhrEpXLc3/hZPpHYdgheDksHN5clOr4o/mvUP76iJvQu+S3AqtyGyOv\n" \
"ouoSCTW+55es/LeMB2zy9U9LJyHZ9s0v3Frf2/FDla/CoJ9Ue+2gLeCkZaxbbL8m\n" \
"XRhujm/1vK4vqW+S2RjIcw8deKO5aRqUb4ZJ5bfeyg+ok2E5nk0SCzXvaibKRs5L\n" \
"uJW3g7MHZ5WfkVW+sq1bhKZpUu59e7k3JSFJ7JaI2t4/ycMK7vaLL+8s2txi6I0W\n" \
"dmRTvQ6a+u2o+UcKBX3qfneqzfH6NuywwCFmjmxfgjY6A5I4U+DGkcnECc5fE9uD\n" \
"xt/tqr1FYpVHlOvBkGVRPdI=\n"\
"-----END CERTIFICATE-----\n";

const char* client_cert= \
"-----BEGIN CERTIFICATE-----\n" \
"MIIDQzCCAisCFBgVnFDC2qnHMF4kDigUAHqvxH4gMA0GCSqGSIb3DQEBCwUAMF4x\n" \
"CzAJBgNVBAYTAklUMQ4wDAYDVQQIDAVpdGFseTEQMA4GA1UEBwwHdHJpZXN0ZTEO\n" \
"MAwGA1UECgwFdW5pdWQxDTALBgNVBAsMBGRtaWYxDjAMBgNVBAMMBWFyem9uMB4X\n" \
"DTIzMTEzMDE3MjkxNFoXDTI0MTEyOTE3MjkxNFowXjELMAkGA1UEBhMCSVQxDjAM\n" \
"BgNVBAgMBWl0YWx5MRAwDgYDVQQHDAd0cmllc3RlMQ4wDAYDVQQKDAV1bml1ZDEN\n" \
"MAsGA1UECwwEZG1pZjEOMAwGA1UEAwwFZXNwMzIwggEiMA0GCSqGSIb3DQEBAQUA\n" \
"A4IBDwAwggEKAoIBAQDLTWoHSatdxgZlqMSTkpEeRMLEj/+URJKlGqTMqw1AwKcs\n" \
"9TB9V9F8FPODUxOHaNNyfUVgSXrcT7EJLuLSkwzKsmAjyTklMfB+vpy3XNcvgwN/\n" \
"pau9kRkG/6X3hgzMOfAM6FCRJ1B0LZWF1UyM0/u16DAWxcu2Du3HP2yvGH7tBVkc\n" \
"65+VLQAaP0cIH9H3g8ERGvC2jJIzMu0sIHfX3HAoFuZ8+y74J0b96RuWBRpnMPmh\n" \
"4OvhL63d7fB1mhfgHK5rsYB3JokX2mNKQJLJwqZCXq+YpMWEFTUIbEIKQnkBsHRB\n" \
"Qnuiy0CDI7hPZjxb0A4d4zAR+45iOswlXcxUlfizAgMBAAEwDQYJKoZIhvcNAQEL\n" \
"BQADggEBAGsk+Cef7q3Z+ErXCtJK6aBJk89r7ZEFe9v8CFNY2XvxQVSzw5H3McIu\n" \
"Yh1kR8TpzDQYTu8JFJTT7yDhz/MMgdYeCx3rIzpdTqkUaQYuxoPKcQofuX3ZdC+Q\n" \
"XVtZSFLDXxgwXqdUDQ3VfvJFPxMMLLMK+Ur8WTsqN6gryAlnOpGmu6qbvm8aoexD\n" \
"ZS8SIdmctWLrj2ry5GbY1m2Zahw4YWOi86PFMSnHJlJiRRUA5LhU2AIFfuGqLhPr\n" \
"M7rYJ/GJ7G2zPNOzczeFhhUHiVAgaFjRFW1FGGSj+YCfrSMkoWVqgjus8oOySdSg\n" \
"ra8AESN/B5Ncodwcw7z63gn39rE1ogU=\n" \
"-----END CERTIFICATE-----\n";

const char* client_key= \
"-----BEGIN RSA PRIVATE KEY-----\n" \
"MIIEpAIBAAKCAQEAy01qB0mrXcYGZajEk5KRHkTCxI//lESSpRqkzKsNQMCnLPUw\n" \
"fVfRfBTzg1MTh2jTcn1FYEl63E+xCS7i0pMMyrJgI8k5JTHwfr6ct1zXL4MDf6Wr\n" \
"vZEZBv+l94YMzDnwDOhQkSdQdC2VhdVMjNP7tegwFsXLtg7txz9srxh+7QVZHOuf\n" \
"lS0AGj9HCB/R94PBERrwtoySMzLtLCB319xwKBbmfPsu+CdG/ekblgUaZzD5oeDr\n" \
"4S+t3e3wdZoX4Byua7GAdyaJF9pjSkCSycKmQl6vmKTFhBU1CGxCCkJ5AbB0QUJ7\n" \
"ostAgyO4T2Y8W9AOHeMwEfuOYjrMJV3MVJX4swIDAQABAoIBAAFMvmfLhcf0syfF\n" \
"O3SCFGFwKRqenRCym4losTMJyOzoDmmQK74xaIp1i9UEG/Taq7doq5/g+GMeM1CO\n" \
"ty6HeCZ3m3u/FplxR0tYJqJZepq4KLaRNZbhrZpI2iPJ/Jz1pd4/Qfyblr0XaYRQ\n" \
"h8vCszJHiL8sho/kaorCkgxQiMc1JaAxQvO3GD/nW+EVGILPE9cUXtsSBvgrw+YL\n" \
"0wQYWr9cctPU8ZfHcfdXbrHoMVH5XaQkPO+Cfsp5We3NvuxqZ5CDgB/jZ7YqUYoL\n" \
"URDlMfF2VzNmdW8wDZsMok3H9X5a4SdHQfungCksvsF23sMgasC9IJhFRmRKDjVP\n" \
"pbgSGnECgYEA7nCe0tV2xBNqBIZRPSvDPE/MhXa5+OKn6z08/izPIKmW75hjhrC3\n" \
"+H6smTkUu9ve+SWvdZiUPSVjb99aCIMFNRGg8BS3Ysahq82E8OMNotJtLtyKW1La\n" \
"w4DtnhnkMFg+xUhdjw32FtFh4YaXVztHnoEPPnhKMrqGwudzbXN8G9sCgYEA2kZV\n" \
"4FB8NodgsgvnRNDkK3TOJylJtyGo5ypSoqco5pRgFAxyIM+o5O2Ud8Tfu+wL+XRT\n" \
"BMu0ToZamYrXI21jP1vboUEeIk2Ji+LauZmQdBEResiH4YyTxcgcqwReuhyw6iQF\n" \
"wd3axk2dOQYide5SvlVqptFfFQw90DJlKKyqWgkCgYEAlOndJ0uN6xM86SqB3jRQ\n" \
"sIAd+VSW/SuBN9d9Gjkd+wYvb9+6eMoxe46RePg/TLwa23t/w2/RVQbevWW+swYw\n" \
"4F3sJ0So65WmLsgiONd1ErVc3yF5f2OVoPgKbu04qEDUox144PkVMlb+TH1kU2SA\n" \
"bCuqO5egr2Hy/BLU8gxn/HUCgYBPVlNuhjKv60MVVEhKdhcJSJqKF3LI0r4+z95b\n" \
"aqDuNq45e1CcZn6AP27Andmox6KOmF54lsZB6InT12hdYyw44l2RXkbitwYwx1Mz\n" \
"NQMRfQa6d1sUe3FW6WaqLptz0GvpnxBMqCQWAi4MhRNPhEGlFwz994o0708kdrzY\n" \
"LPJ6aQKBgQCyQCMz2WUvNzl5GOKTsiXQaeYhKM9gX3ZTZKPB1OfIC7fxusAenhG3\n" \
"I+I2cL+rDSS2I74cAClkeGnW0xjOrP1SBjCXpcvUAQdQwfM5HKfBqXcfqkzLur3d\n" \
"KsIcydHbkv3NBDfZ+Pv6wG4RJazPMwIuFSkIDP+k5lvUksGf35yl0w==\n" \
"-----END RSA PRIVATE KEY-----\n";

MFRC522 rfid(SS_PIN, RST_PIN);
WiFiClientSecure WIFIclient;
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
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());

  //Setting up certs for TLS connection esp32-rasp(broker)
  WIFIclient.setCACert(ca_cert);
  WIFIclient.setCertificate(client_cert);
  WIFIclient.setPrivateKey(client_key);

  client.setServer(broker, port);

  while (!client.connected()) {
    Serial.println("Connecting to MQTT Broker ...");

    if (client.connect("ESP32-NFCTagReader"),"admin","password") {
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
    if (client.connect(clientId.c_str(),"admin","password")) {
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
