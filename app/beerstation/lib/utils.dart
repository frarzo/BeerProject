import 'package:encrypt/encrypt.dart' as encrypt;

final key = encrypt.Key.fromUtf8('fh934fhdwofj340rjf390hf390h43232');
final iv = encrypt.IV.fromUtf8('hf934fhewfudsifs');

const url = '192.168.1.104:80';
Map<String, String> header = {
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
