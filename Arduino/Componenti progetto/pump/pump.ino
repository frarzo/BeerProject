#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <SPI.h>

const char* ssid = "dev";
const char* password = "WbdL57ak12";
const char* mqtt_server = "192.168.1.110";

WiFiClient espClient;
PubSubClient client(espClient);

#define SCREEN_WIDTH 128  // OLED display width, in pixels
#define SCREEN_HEIGHT 64  // OLED display height, in pixels
#define OLED_RESET -1     // Reset pin # (or -1 if sharing Arduino reset pin)
#define LOGO_HEIGHT 32
#define LOGO_WIDTH 32
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);
static const unsigned char PROGMEM logo_bmp[] = { B00000000, B00000000, B00000000, B00000000,
                                                  B00000000, B00000111, B10011100, B00000000,
                                                  B00000000, B00001111, B11111111, B00000000,
                                                  B00000000, B11111100, B11100011, B11110000,
                                                  B00000011, B11111000, B00000001, B11111000,
                                                  B00000011, B00000000, B00000000, B00011100,
                                                  B00000110, B00000000, B00000000, B00001100,
                                                  B00000110, B00000000, B00000000, B00001100,
                                                  B00000110, B00000000, B00100000, B00001100,
                                                  B00000011, B00000000, B01110000, B00011100,
                                                  B00000011, B11111000, B01111111, B11111000,
                                                  B00000000, B11111100, B11101111, B11110000,
                                                  B00000000, B11001111, B11000000, B01100000,
                                                  B00001111, B11000111, B10000000, B01100000,
                                                  B00011111, B11000100, B01000100, B01100000,
                                                  B00110000, B11001100, B11000110, B01100000,
                                                  B00110000, B11001100, B11000110, B01100000,
                                                  B00110000, B11001100, B11000110, B01100000,
                                                  B00110000, B11001100, B11000110, B01100000,
                                                  B00110000, B11001100, B11000110, B01100000,
                                                  B00110000, B11001100, B11000110, B01100000,
                                                  B00110000, B11001100, B11000110, B01100000,
                                                  B00110000, B11001100, B11000110, B01100000,
                                                  B00111000, B11001100, B11000110, B01100000,
                                                  B00011111, B11001100, B11000110, B01100000,
                                                  B00001111, B11000100, B01000100, B01100000,
                                                  B00000000, B11000000, B00000000, B01100000,
                                                  B00000000, B01100000, B00000000, B11000000,
                                                  B00000000, B01110000, B00000001, B11000000,
                                                  B00000000, B00111111, B11111111, B10000000,
                                                  B00000000, B00011111, B11111111, B00000000,
                                                  B00000000, B00000000, B00000000, B00000000 };

int idPompa = 1;
const char* mqtt_topic = "beer/pump1";
void setup_wifi() {

  delay(10);
  // We start by connecting to a WiFi network
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);

  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
}

void callback(char* topic, byte* payload, unsigned int length) {

  // Switch on the LED if an 1 was received as first character
  // TODO: Se 2 invia un messaggio di errore su LCD per 5 secondi

  switch ((char)payload[0]) {
    case '1':  //Eroga
      digitalWrite(BUILTIN_LED, LOW);
      showErogazione();
      break;
    case '0':  //Stop
      digitalWrite(BUILTIN_LED, HIGH);

      showBeer();
      break;
    case '2':  //Errore
      showError();
      break;
  }
}

void reconnect() {

  while (!client.connected()) {
    Serial.print("Connessione MQTT...");
    String clientId = "ESP8266 - Pump 1 ";

    if (client.connect(clientId.c_str())) {
      Serial.println("connected");
      client.subscribe(mqtt_topic);
    } else {
      //Serial.println("Fallito, riprovo");
      Serial.print("failed, rc=");
      Serial.print(client.state());
      delay(2000);
    }
  }
}

void resetScreen(){
        display.stopscroll();
        display.invertDisplay(false);
        display.clearDisplay();
        display.display();
        delay(50);
}

void showBeer() {
  display.clearDisplay();
  display.invertDisplay(true);
  display.drawBitmap(
    10,
    (display.height() - LOGO_HEIGHT) / 2,
    logo_bmp, LOGO_WIDTH, LOGO_HEIGHT, 1);
  display.setTextSize(2);
  display.setTextColor(WHITE);
  display.setCursor(48, 10 + (display.height() - LOGO_HEIGHT) / 2);
  display.println(F("Enjoy!"));
  display.display();
  display.startscrollright(0x00, 0x0F);
  delay(3000);
  resetScreen();
}

void showErogazione() {
  display.clearDisplay();
  display.invertDisplay(true);
  display.setTextSize(2);
  display.setTextColor(WHITE);
  display.setCursor(2, 10 + (display.height() - LOGO_HEIGHT) / 2);
  display.println(F("Erogazione"));
  display.display();
  display.startscrollright(0x00, 0x0F);
}

void showError() {
  display.clearDisplay();
  display.setCursor(5, 1);
  display.setTextSize(2);
  display.setTextColor(WHITE);
  display.println(F("- ERRORE -"));
  display.setCursor(3, 20);
  display.println(F("Utente non"));
  display.setCursor(3, 40);
  display.println(F("registrato"));
  display.display();
  delay(3000);
  resetScreen();
}

void setup() {
  pinMode(BUILTIN_LED, OUTPUT);  // Initialize the BUILTIN_LED pin as an output
  digitalWrite(BUILTIN_LED, HIGH);
  Serial.begin(115200);
  setup_wifi();
  client.setServer(mqtt_server, 1883);
  client.setCallback(callback);
  if (!display.begin(SSD1306_SWITCHCAPVCC, 0x3C)) {
    Serial.println(F("SSD1306 allocation failed"));
    for (;;)
      ;  // Don't proceed, loop forever
  }
  display.clearDisplay();
  display.display();
}

void loop() {

  if (!client.connected()) {
    reconnect();
  }
  client.loop();
}
