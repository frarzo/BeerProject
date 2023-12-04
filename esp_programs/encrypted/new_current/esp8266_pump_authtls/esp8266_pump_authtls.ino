#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <SPI.h>


// Le righe di codice che azionano il pin per attivare il relay sono state commentate in quanto la scheda
// non è in grado di fornire una corrente sufficiente a mantenere sia il realy che lo schermo attivi.


const char* ssid = "dev";
const char* password = "WbdL57ak12";
const char* broker = "192.168.1.110";
const char* topic = "beer/pump1";
const int port = 8883; //8883 per tls, 1883 per testing

int idPompa = 1;
int relayPin = 4;

#define SCREEN_WIDTH 128  // OLED display width, in pixels
#define SCREEN_HEIGHT 64  // OLED display height, in pixels
#define OLED_RESET -1     // Reset pin # (or -1 if sharing Arduino reset pin)
#define beer_height 32
#define beer_width 32
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


//certs for esp8266 pump
const char* ca_cert = \
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
"xt/tqr1FYpVHlOvBkGVRPdI=\n" \
"-----END CERTIFICATE-----\n";

const char* client_cert = \
"-----BEGIN CERTIFICATE-----\n" \
"MIIDRTCCAi0CFBgVnFDC2qnHMF4kDigUAHqvxH4hMA0GCSqGSIb3DQEBCwUAMF4x\n" \
"CzAJBgNVBAYTAklUMQ4wDAYDVQQIDAVpdGFseTEQMA4GA1UEBwwHdHJpZXN0ZTEO\n" \
"MAwGA1UECgwFdW5pdWQxDTALBgNVBAsMBGRtaWYxDjAMBgNVBAMMBWFyem9uMB4X\n" \
"DTIzMTEzMDE3MzIxN1oXDTI0MTEyOTE3MzIxN1owYDELMAkGA1UEBhMCSVQxDjAM\n" \
"BgNVBAgMBWl0YWx5MRAwDgYDVQQHDAd0cmllc3RlMQ4wDAYDVQQKDAV1bml1ZDEN\n" \
"MAsGA1UECwwEZG1pZjEQMA4GA1UEAwwHZXNwODI2NjCCASIwDQYJKoZIhvcNAQEB\n" \
"BQADggEPADCCAQoCggEBAOJYko7Ny/6hw5z8h3L4zwvyBzzWcJyluky46JHE1J4z\n" \
"jdeT6CRagzjgOpkbBMCUeami2QtNuDbfHyINEAfGLiHoSk7YKJwoHdod5kmH7vaq\n" \
"b8Ely5LWGvnWEfy/OFDSYlMk9WhGtq//+02DKO6OE+p+g1ZIirNF4WWO7eBXl9RK\n" \
"Fw+4iHb54mUCp7leVuZFn6ATyGNBIgdoT4iyFzGyukHlucLY1qr/2y6pJE9mmy3y\n" \
"9xBrs8Nl9sXjNPTO1Ww+aEmqnqoczy8EnGS2LvAqH3aY8ijvrcE39TkTWqwyE/hQ\n" \
"QUk9S8IWEOWENE9gmUklsgzwsO78b50UWb4V1x7GmF0CAwEAATANBgkqhkiG9w0B\n" \
"AQsFAAOCAQEAuwKCPIiLDHRAwnR2QyF/+pJyPaeEgzTY4bdmgEja6egM/t4j4DBM\n" \
"Ha3GN2r6undDn7VPtJj418y67jAmlsz5zU3wPAoWJEO0FGb0XdggX0y3s8LSfUxS\n" \
"JBLksHxNNpA18/cfzHoSDJ/7Xs2aOMu+E9+PpDwRQEdCrb6PH2nfCKclsUf60RnM\n" \
"/OVJcNwyYqc5Fzl4DI2ueU74ZGZXaASRbGN5dSDYnIK3Buzhv0rBnPVmCBpjdGTL\n" \
"j0jZOtOEdqNjhy8It4ce9d7iWG05mYG49FxkWK/4hvd0ucTnHZZCIm3z5PDMnZ+G\n" \
"8Lm/beUwwsv4vBp+1DnjE0JI2kr58hzaQQ==\n" \
"-----END CERTIFICATE-----\n";

const char* client_key = \
"-----BEGIN RSA PRIVATE KEY-----\n" \
"MIIEpQIBAAKCAQEA4liSjs3L/qHDnPyHcvjPC/IHPNZwnKW6TLjokcTUnjON15Po\n" \
"JFqDOOA6mRsEwJR5qaLZC024Nt8fIg0QB8YuIehKTtgonCgd2h3mSYfu9qpvwSXL\n" \
"ktYa+dYR/L84UNJiUyT1aEa2r//7TYMo7o4T6n6DVkiKs0XhZY7t4FeX1EoXD7iI\n" \
"dvniZQKnuV5W5kWfoBPIY0EiB2hPiLIXMbK6QeW5wtjWqv/bLqkkT2abLfL3EGuz\n" \
"w2X2xeM09M7VbD5oSaqeqhzPLwScZLYu8CofdpjyKO+twTf1ORNarDIT+FBBST1L\n" \
"whYQ5YQ0T2CZSSWyDPCw7vxvnRRZvhXXHsaYXQIDAQABAoIBAQCaczYOm/+HUXrZ\n" \
"tLf4jC88R3sI2IsfWTc3AzYvwdAT47n2UMcnh1vjg554uycTAj3Cs4zHWdFKIBZu\n" \
"ddtqcqEoIgoSow2TAQzduWla45b8WnDHq7KuD8t4j8rWXOVgwS627ZFIBnjCwDoL\n" \
"OmTD489TQ+D7D6UVj6muU0mevCauhFcqsEWOnTBYNUvEkJEq6r2Hs0SQy07WdLt3\n" \
"Gw0sfOXJmph/QbBCjil3p5NbwpgTlBp3OX9M6rpFKvmLAiy+pHRkLtGUnl6J+y22\n" \
"OK7ZsMQ4EPuLhUDuWf/rtOrZtlsfJUD+Z5DDI19d2Q6ufrhyMnpvpUfj3B4Qzjoz\n" \
"eheb4PtBAoGBAP0OAZpIrYXXAUjJfWueccKMLAFpBSB6beoWy/xEh0fUNOhQPDM5\n" \
"4Iod9KKpSsSQ1o8IbPBewmJMFzj0ooJgeOayzUP5Fh84Jy7RL8ptJoMVdoQBbwqW\n" \
"W8crrIuyIKM+nssyZpmhipjeaJYyMe7EQCwNkBXkYLSaJAmiEm0grE0LAoGBAOT6\n" \
"/FsXHBk0HwYgt9pcpHZMI2zT26c7EwYHnVtFxfMrd6cTY6vAoiILkenFH9ivXBL4\n" \
"CRNoba7DaCgFsXR48UUWzO0grV3xCf1Gu/Hqm2QXX4Bmskz1ZjgYRfshz+yeNqKs\n" \
"c4GdFiAAMLQk+4SYQGbviJaXupYGn6YazE2/fwE3AoGBAJzi7R1xB5udw98ThF2P\n" \
"WuoJq1KogJQ1MyXZQlhBSDnBF5gb/man8EzQ65VZLdCWF1+QErInnY4BrLgT+xin\n" \
"pO0qV1ZX/F4YmzpMWLvAVgsY6GRI20YOGBJwQkZNhiyPKzXBJpkC7QF/ignsTsbA\n" \
"ByUIt5bLAyWVFtieEZx0kD4nAoGBAJwUeO+eUQjc/kivBKNTgscgHwWPY6oaGl2B\n" \
"00DjzopylpzMGqR4KgwK1usB8zNAVQKZD5arGBiIGfct6kf6KHtvj0AThhkCtExw\n" \
"aqv7vu/6/p4HYoISxBp4cTs9UP142sUHx7QR34LwnkIs80TugvenTvNXeVfKLAiN\n" \
"O7XDUk8BAoGASp3BAV6qvLhbodcv4JoT9m8fc5mR08ZlBrJVae2fqZ/blr1kM4Bu\n" \
"Mt69yW2JJ+mmZQ/oKDBog8fGccUYfFSAY9c+rPe59UIiNdttCqaTz7wMOHU6xjDY\n" \
"fxHg38hCZy0Y6tgf6zQkxgAkD5xxEj/URNjUDjhgT4PivuRYrY4yfWw=\n" \
"-----END RSA PRIVATE KEY-----\n";


BearSSL::WiFiClientSecure espClient;
PubSubClient client(espClient);

//Setting up clock for certificate requirements
void setClock(){
  configTime(3 * 3600, 0, "pool.ntp.org", "time.nist.gov");

  Serial.print("Waiting for NTP time sync: ");
  time_t now = time(nullptr);
  while (now < 8 * 3600 * 2) {
    delay(500);
    Serial.print(".");
    now = time(nullptr);
  }
  Serial.println("");
  struct tm timeinfo;
  gmtime_r(&now, &timeinfo);
  Serial.print("Current time: ");
  Serial.print(asctime(&timeinfo));
}

void setup_wifi() {
  delay(50);

  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("");
  Serial.print("Connected, IP address: ");
  Serial.println(WiFi.localIP());
}

void callback(char* topic, byte* payload, unsigned int length) {
  Serial.println("Arrivato un messaggio");
  // Test, 0 spegne led, 1 lo accende
  // TODO: Se 2 invia un messaggio di errore su LCD per 5 secondi - OK

  switch ((char)payload[0]) {
    case '1':  //Eroga
      digitalWrite(BUILTIN_LED, LOW);
      //digitalWrite(relayPin, HIGH);
      Serial.println("Apro pompa");
      showErogazione();
      break;
    case '0':  //Stop
      digitalWrite(BUILTIN_LED, HIGH);
      //digitalWrite(relayPin, LOW);
      Serial.println("Chiudo pompa");
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

    if (client.connect(clientId.c_str(),"admin","password")) {
      Serial.println("Connected");
      client.subscribe(topic);
    } else {
      //Serial.println("Fallito, riprovo");
      Serial.print("failed, rc=");
      Serial.print(client.state());
      delay(2000);
    }
  }
}

void resetScreen() {
  display.stopscroll();
  display.invertDisplay(false);
  display.clearDisplay();
  display.display();
  delay(50);
}

void showBeer() {
  display.clearDisplay();
  display.invertDisplay(false);
  display.drawBitmap(
    10,
    (display.height() - beer_height) / 2,
    logo_bmp, beer_width, beer_height, 1);
  display.setTextSize(2);
  display.setTextColor(WHITE);
  display.setCursor(48, 10 + (display.height() - beer_height) / 2);
  display.println(F("Enjoy!"));
  display.display();
  display.startscrollright(0x00, 0x0F);
  delay(3000);
  resetScreen();
}

void showErogazione() {
  display.clearDisplay();
  display.invertDisplay(false);
  display.setTextSize(2);
  display.setTextColor(WHITE);
  display.setCursor(2, 10 + (display.height() - beer_height) / 2);
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
  pinMode(BUILTIN_LED, OUTPUT);
  digitalWrite(BUILTIN_LED, HIGH);
  //pinMode(relayPin, OUTPUT);
  //digitalWrite(relayPin, LOW);
  Serial.begin(9600);

  //NB: BearSSL è l'evoluzione della lib WifiClientSecure, non provare ad usarla come per esp32
  //Setting up CA cert and clientesp8266 cert/key
  BearSSL::X509List *serverTrustedCA = new BearSSL::X509List(ca_cert);
  BearSSL::X509List *serverCertList = new BearSSL::X509List(client_cert);
  BearSSL::PrivateKey *serverPrivKey = new BearSSL::PrivateKey(client_key);

  //Nuovi metodi invece di setCAcert, setCertificate, setPrivateKey di esp32
  espClient.setTrustAnchors(serverTrustedCA);
  espClient.setClientRSACert(serverCertList, serverPrivKey);
  setup_wifi();
  //Deve controllare la scadenza del certificato
  setClock();
  client.setServer(broker, port);
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
