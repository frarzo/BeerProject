import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:http/http.dart' as http;
import 'package:beerstation/obj/user.dart';
import 'dart:convert';

final key = encrypt.Key.fromUtf8('fh934fhdwofj340rjf390hf390h43232');
final iv = encrypt.IV.fromUtf8('hf934fhewfudsifs');

const url = '192.168.1.104:80';
const loginUrl = '/API/api.php';
const retrieveConsumazioniUrl = '/API/consumazioni.api';

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


Future<List> DBGet(String userid){
  final response = await http.get(
    Uri.http(url,retrieveConsumazioniUrl),
    headers: header,
    
  );
  return 
}


Future<User> DBPost(String url, String path, Map<String, String> header,
    Map<String, String> payload) async {
  print("$url, $path");
  final response = await http.post(
    Uri.http(url, path),
    headers: header,
    body: payload,
  );
  print(response.statusCode == 200 ? "DEBUG: Response code = 200" : 'NOT GOOD');

  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Fallita creazione obj utente');
  }
  //return response.statusCode == 200 && response.body.isNotEmpty? decrypt_string(response.body): "???";
}
