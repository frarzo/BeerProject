/*
 * This example show how you can get Authenticated by the NTAG213,215,216. By default the tags are unprotected, in order to protect them we need to write 4 different values:
 * Using mfrc522.MIFARE_Ultralight_Write(PageNum, Data, #Databytes))
 * 1.- We need to write the 32bit passWord to page 0xE5 [!for ntag 213 and 215 page is different refer to nxp documentation!]
 * 2.- Now Write the 16 bits pACK to the page 0xE6 use the 2 high bytes like this: pACKH + pACKL + 00 + 00 after an authentication the tag will return this secret bytes
 * 3.- Now we need to write the first page we want to protect this is a 1 byte data in page 0xE3 we need to write 00 + 00 + 00 + firstPage  all pages after this one are write protected
 *     Now WRITE protection is ACTIVATED so we need to get authenticated in order to write the last data
 * 4.- Finally we need to write an access record in order to READ protect the card this step is optional only if you want to read protect also write 80 + 00 + 00 + 00 to 0xE4
 * After completing all these steps you will nee to authenticate first in order to read or write ant page after the first page you selected to protect.
 * To disengage protection just write the page (0xE3) to 00 + 00 + 00 + FF that going to remove all protection.
 * 
 * @author GARGANTUA from RoboCreators.com & paradoxalabs.com
 * @license Released into the public domain.
 */

#include <SPI.h>
#include <MFRC522.h>
int flag = 0;
#define RST_PIN 5  //
#define SS_PIN 4  //

MFRC522 mfrc522(SS_PIN, RST_PIN);  // Create MFRC522 instance
MFRC522::StatusCode status;
uint8_t PSWAddress = 0x2B;
byte buffer[18];
byte size = sizeof(buffer);


void setup() {
  Serial.begin(9600);  // Initialize serial communications with the PC
  SPI.begin();         // Init SPI bus
  mfrc522.PCD_Init();  // Init MFRC522
  memcpy(buffer, "1234", 4);
}

void loop() {
  Serial.println("inizio 1 LOOP");
  if (flag == 1) { return; }
  Serial.println("inizio mfr522");
  // Look for new cards
  if (!mfrc522.PICC_IsNewCardPresent()) {
    delay(50);
    return;
  }
  Serial.println("New card ");
  if (!mfrc522.PICC_ReadCardSerial()) {
    delay(50);
    return;
  }
 

  Serial.println("prima di scrivi PACK");
  status = (MFRC522::StatusCode)mfrc522.MIFARE_Ultralight_Write(PSWAddress, &buffer[0], 4);
  if (status != MFRC522::STATUS_OK) {
    Serial.print(F("MIFARE WRITE FAILED: "));
    Serial.println(mfrc522.GetStatusCodeName(status));
    return;
  } else {
    Serial.println("PACK WRITE SUCCESSFUL");
    flag = 1;
  }
  Serial.println("dopo di scrivi PACK");

//---------------------------------
  Serial.println("prima di scrivi PSW");
  status = (MFRC522::StatusCode)mfrc522.MIFARE_Ultralight_Write(PSWAddress, &buffer[0], 4);
  if (status != MFRC522::STATUS_OK) {
    Serial.print(F("MIFARE WRITE FAILED: "));
    Serial.println(mfrc522.GetStatusCodeName(status));
    return;
  } else {
    Serial.println("PSW WRITE SUCCESSFUL");
    flag = 1;
  }
  Serial.println("dopo di scrivi PSW");
  mfrc522.PICC_HaltA();
}