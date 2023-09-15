#include <SPI.h>
#include <MFRC522.h>

#define SS_PIN 5    // ESP32 pin GPIO5
#define RST_PIN 27  // ESP32 pin GPIO27

MFRC522 rfid(SS_PIN, RST_PIN);

unsigned long timeStart = 0;
unsigned long timeEnd = 0;
bool tagPresent = false;

byte bufferATQA[2];
byte bufferSize = sizeof(bufferATQA);

void setup() {
  Serial.begin(9600);
  SPI.begin();      // init SPI bus
  rfid.PCD_Init();  // init MFRC522
  Serial.println("Use an RFID tag");
}

//Non so perché devo mettere 3 volte il wakeup ma così funziona, provato a caso
//Se elimino anche uno non funziona quindi non toccare

void loop() {
  MFRC522::StatusCode status = rfid.PICC_WakeupA(bufferATQA, &bufferSize);
  //Serial.print("Prima del controllo - ");
  //Serial.println(status, DEC);
  delay(500);

  if (rfid.PICC_IsNewCardPresent() && rfid.PICC_ReadCardSerial()) {
    status = rfid.PICC_WakeupA(bufferATQA, &bufferSize);
    //Serial.print("True - ");
    //Serial.println(status, DEC);
    //delay(500);
    
    if (!tagPresent) {  // if tagPresent = false, then the tag has just "arrived"
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
     //  noted the last tag's time, reset
      tagPresent = false;
    }
  }
  status = rfid.PICC_WakeupA(bufferATQA, &bufferSize);
  //Serial.print("Fuori da controllo - ");
  //Serial.println(status, DEC);
  //delay(500);

}
