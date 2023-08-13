import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:http/http.dart' as http;

final key = encrypt.Key.fromUtf8('fh934fhdwofj340rjf390hf390h43232');
final iv = encrypt.IV.fromUtf8('hf934fhewfudsifs');

const url = '192.168.1.104:80';

const Map<String, String> header = {
  'Content-Type': 'application/x-www-form-urlencoded'
};

String encrypt_string(String str) {
  final encrypter =
      encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  return encrypter.encrypt(str, iv: iv).base64;
}

String decrypt_string(String str) {
  final encrypter =
      encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  return encrypter.decrypt(encrypt.Encrypted.fromBase64(str), iv: iv);
}

Future<String> DBPost(String url, String path, Map<String, String> header,
    Map<String, String> payload) async {
  final response = await http.post(
    Uri.http(url, path),
    headers: header,
    body: payload,
  );
  print("DEBUG: Response code = {$response.statusCode}");
  return response.statusCode == 200 && response.body.isNotEmpty
      ? decrypt_string(response.body)
      : "???";
}
