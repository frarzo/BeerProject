#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <PubSubClient.h>

const char* ssid = "dev";
const char* password = "WbdL57ak12";
const char* broker = "192.168.1.110";
const char* topic = "test";

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


WiFiClientSecure WIFIclient;
PubSubClient client(WIFIclient);


void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  WiFi.begin(ssid,password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());

  WIFIclient.setCACert(ca_cert);
  WIFIclient.setCertificate(client_cert);
  WIFIclient.setPrivateKey(client_key);


  client.setServer(broker,8883);

  if (!client.connected()) {
  Serial.print("Connessione MQTT...");
  String clientId = "ESP32";

  if (client.connect(clientId.c_str(), "admin", "password")) {
    Serial.println("connected");
    char test[8] = "abcdefg";
    client.publish(topic, test);
  } else {
    //Serial.println("Fallito, riprovo");
    Serial.print("failed, rc=");
    Serial.print(client.state());
    delay(2000);
  }
}

}

void loop() {
  // put your main code here, to run repeatedly:

}
