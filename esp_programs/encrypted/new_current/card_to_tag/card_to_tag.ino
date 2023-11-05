/*
  Versione aggiornata: Adesso per accedere al tag NTAG213 (sia in Read che Write) bisogna autenticarsi con PCD_NTAG216_AUTH(&PSWBuff[0], pACK).
                       La PSW è 0x31, 0x32, 0x33, 0x34;
                       L'ACK di risposta è 0x80, 0x00

  Permette di trasferire l'ID di un utente registrato dalla sua card al tag nel bicchiere usato per accedere all'erogatore di bevande.

*/
#include <MFRC522.h>
#include <PubSubClient.h>
#define RST_PIN 5  // RST-PIN for RC522 - RFID - SPI - Modul GPIO5
#define SS_PIN 4

MFRC522 mfrc522(SS_PIN, RST_PIN);
MFRC522::MIFARE_Key key;
MFRC522::StatusCode status;

//DATI TAG NFC su cui scrivere
uint8_t pageAddress = 0x06;
byte PSWBuff[] = { 0x31, 0x32, 0x33, 0x34 };  // 32 bit password
byte pACK[] = { 0x00, 0x00 };                 // 16 bit password ACK returned by the NFCtag
//DATI CARD NFC per leggere
byte sector = 1;
byte block = 4;
byte trailerBlock = 7;

//Variabili di buffer
byte buffer[18];
byte size = sizeof(buffer);
boolean cardIsRead = false;

void setup() {
  Serial.begin(115200);  // Initialize serial communications
  SPI.begin();           // Init SPI bus
  mfrc522.PCD_Init();    // Init MFRC522
  //memcpy(buffer, "00aaa000", 8);
  for (byte i = 0; i < 6; i++) {
    key.keyByte[i] = 0xFF;
  }
  //Per un aiuto visivo se lettura e scrittura sono andate a buon fine
  pinMode(BUILTIN_LED, OUTPUT);
  digitalWrite(BUILTIN_LED, HIGH);
  Serial.print("Avvicina la carta di un utente registrato\n");
}

void loop() {

  // Look for new cards
  if (!mfrc522.PICC_IsNewCardPresent()) {
    delay(50);
    return;
  }
  if (!mfrc522.PICC_ReadCardSerial()) {
    delay(50);
    return;
  }

  // Se è la tessera, leggo i byte e li copio
  if (mfrc522.uid.sak == 0x08) {

    //Auth using key A
    status = (MFRC522::StatusCode)mfrc522.PCD_Authenticate(MFRC522::PICC_CMD_MF_AUTH_KEY_A, trailerBlock, &key, &(mfrc522.uid));
    if (status != MFRC522::STATUS_OK) {
      Serial.print(F("PCD_Authenticate() failed: "));
      Serial.println(mfrc522.GetStatusCodeName(status));
      return;
    }

    //Read the block
    status = (MFRC522::StatusCode)mfrc522.MIFARE_Read(block, buffer, &size);
    if (status != MFRC522::STATUS_OK) {
      Serial.print(F("MIFARE_Read() failed: "));
      Serial.println(mfrc522.GetStatusCodeName(status));
    } else {
      digitalWrite(BUILTIN_LED, LOW);
      cardIsRead = true;
      Serial.print("Letto ID dello user: ");
      for (int i = 0; i < 8; i++) {
        Serial.print((char)buffer[i]);
      }
    }
    mfrc522.PICC_HaltA();
    mfrc522.PCD_StopCrypto1();
  }
  // Se è il tag NTAG213 ed è in memoria un ID utente
  // a quanto pare uid può essere letto prima di avere eseguito l'auth
  if (cardIsRead == true && mfrc522.uid.sak == 0x00) {

    Serial.print("Auth: ");
    status = (MFRC522::StatusCode)mfrc522.PCD_NTAG216_AUTH(&PSWBuff[0], pACK);
    if (status != MFRC522::STATUS_OK) {
      Serial.print(F(" FAILED "));
      Serial.println(mfrc522.GetStatusCodeName(status));
      return;
    } else {
      Serial.println("SUCCESSFUL");
    }

    //Scrivi in memoria l'ID utente
    for (int i = 0; i < 4; i++) {
      status = mfrc522.MIFARE_Ultralight_Write(pageAddress + i, &buffer[i * 4], 4);
      if (status != MFRC522::STATUS_OK) {
        Serial.print(F("MIFARE WRITE FAILED: "));
        Serial.println(mfrc522.GetStatusCodeName(status));
        return;
      } else {
        digitalWrite(BUILTIN_LED, HIGH);
        cardIsRead = false;
      }
    }
    Serial.println("Salvato Id utente nel tag");
  }

  Serial.println();
  mfrc522.PICC_HaltA();
}