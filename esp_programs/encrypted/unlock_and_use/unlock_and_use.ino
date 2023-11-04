/*
 * This example show how you can get Authenticated by the NTAG213,215,216. By default the tags are unprotected in order to protect them we need to write 4 different values:
 * Using mfrc522.MIFARE_Ultralight_Write(PageNum, Data, #Databytes))
 * 1.- We need to write the 32bit passWord to page 0xE5 !for ntag 213 and 215 page is different refer to nxp documentation!
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

#define RST_PIN 5  //
#define SS_PIN 4   //

MFRC522 mfrc522(SS_PIN, RST_PIN);  // Create MFRC522 instance
MFRC522::StatusCode status;

byte message[4] = { 0xAA, 0xAA, 0xAA, 0xAA };
byte messagesize = sizeof(message);

void setup() {
  Serial.begin(9600);  // Initialize serial communications with the PC
  while (!Serial)
    ;                  // Do nothing if no serial port is opened (added for Arduinos based on ATMEGA32U4)
  SPI.begin();         // Init SPI bus
  mfrc522.PCD_Init();  // Init MFRC522
  Serial.println(F("Scan PICC to see UID, type, and data blocks..."));
}

void loop() {
  // Reset the loop if no new card present on the sensor/reader. This saves the entire process when idle.
  if (!mfrc522.PICC_IsNewCardPresent()) {
    return;
  }

  // Select one of the cards
  if (!mfrc522.PICC_ReadCardSerial()) {
    return;
  }

  byte PSWBuff[] = { 0x31, 0x32, 0x33, 0x34 };  // 32 bit password default FFFFFFFF.
  byte pACK[] = { 0x80, 0x80 };                 // 16 bit password ACK returned by the NFCtag.

  /*
  ATTENZIONE: Ora è necessario l'auth pure per leggere i dati!!!
  */


  Serial.print("Auth: ");
  status = (MFRC522::StatusCode)mfrc522.PCD_NTAG216_AUTH(&PSWBuff[0], pACK);
  if (status != MFRC522::STATUS_OK) {
    Serial.print(F(" FAILED "));
    Serial.println(mfrc522.GetStatusCodeName(status));
    return;
  } else {
    Serial.println("SUCCESSFUL");
  }
  // Serial.println(mfrc522.PCD_NTAG216_AUTH(&PSWBuff[0], pACK));  // Request authentification if return STATUS_OK we are good.


  status = (MFRC522::StatusCode)mfrc522.MIFARE_Ultralight_Write(0x0A, &message[0], 4);
  if (status != MFRC522::STATUS_OK) {
    Serial.print(F("MIFARE WRITE FAILED: "));
    Serial.println(mfrc522.GetStatusCodeName(status));
    return;
  } else {
    Serial.println("0A WRITE SUCCESSFUL");
  }

  //Print PassWordACK
  Serial.print(pACK[0], HEX);
  Serial.println(pACK[1], HEX);

  byte WBuff[] = { 0x00, 0x00, 0x00, 0x04 };
  byte RBuff[18];

  //Serial.print("CHG BLK: ");
  //Serial.println(mfrc522.MIFARE_Ultralight_Write(0xE3, WBuff, 4));  // How to write to a page.

  mfrc522.PICC_DumpMifareUltralightToSerial();  // This is a modifier dump just change the for circle to < 232 instead of < 16 in order to see all the pages on NTAG216.
  //Non posso stampare la 44-esima pagina ma non importa perché sarebbe comunque vista come 00 00 00 00 per via della crittografia



  delay(3000);
}
