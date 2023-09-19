#include <MFRC522.h>
#include <PubSubClient.h>
#define RST_PIN 5  // RST-PIN for RC522 - RFID - SPI - Modul GPIO5
#define SS_PIN 4

MFRC522 mfrc522(SS_PIN, RST_PIN);
MFRC522::MIFARE_Key key;
MFRC522::StatusCode status;

uint8_t pageAddress = 0x06;

byte buffer[18];
byte size = sizeof(buffer);


void setup() {
  Serial.begin(115200);  // Initialize serial communications
  SPI.begin();           // Init SPI bus
  mfrc522.PCD_Init();    // Init MFRC522
  memcpy(buffer, "00aaa000", 8);
}

void loop() {

  // Look for new cards
  if (!mfrc522.PICC_IsNewCardPresent()) {
    delay(50);
    return;
  }
  // Select one of the cards
  if (!mfrc522.PICC_ReadCardSerial()) {
    delay(50);
    return;
  }
  //WRITE THE DATA
  for (int i = 0; i < 4; i++) {
    status = mfrc522.MIFARE_Ultralight_Write(pageAddress + i, &buffer[i * 4], 4);
    if (status != MFRC522::STATUS_OK) {
      Serial.print(F("MIFARE WRITE FAILED: "));
      Serial.println(mfrc522.GetStatusCodeName(status));
      return;
    }
  }
  Serial.println(F("MIFARE WRITE OK"));
  Serial.println();

  //READ THE DATA
  status = (MFRC522::StatusCode)mfrc522.MIFARE_Read(pageAddress, buffer, &size);
  if (status != MFRC522::STATUS_OK) {
    Serial.print(F("MIFARE_Read() failed: "));
    Serial.println(mfrc522.GetStatusCodeName(status));
    return;
  }

  for (int i = 0; i < 8; i++) {
    Serial.print((char)buffer[i]);
  }


  Serial.println();
  Serial.println("------------------");
  mfrc522.PICC_HaltA();
}