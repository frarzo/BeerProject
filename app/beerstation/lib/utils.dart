import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:beerstation/obj/user.dart';
import 'package:beerstation/obj/consumazione.dart';
import 'dart:convert';

final key = encrypt.Key.fromUtf8('fh934fhdwofj340rjf390hf390h43232');
final iv = encrypt.IV.fromUtf8('hf934fhewfudsifs');

const url = '192.168.1.104:80';
const loginUrl = '/API/login.php';
const registerUrl = '/API/register.php';
const resetUrl = '/API/resetdebt.php';
List<dynamic> pippo = [];
const retrieveConsumazioniUrl = '/API/getconsumazioni.php';

const Map<String, String> header = {
  'Content-Type': 'application/x-www-form-urlencoded'
};

void showWindowDialog(String message, BuildContext context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('Indietro'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
}

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

bool checkFields(mail, psw) {
  return mail.text.isNotEmpty && psw.text.isNotEmpty;
}

Future<User> DBPost(String url, String path, Map<String, String> header,
    Map<String, String> payload) async {
  //print("$url, $path");
  final response = await http.post(
    Uri.http(url, path),
    headers: header,
    body: payload,
  );
  print(response.statusCode == 200 ? "DEBUG: Response code = 200" : 'NOT GOOD');

  if (response.statusCode == 200) {
    print(response.body);
    return User.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Fallita creazione obj utente');
  }
  //return response.statusCode == 200 && response.body.isNotEmpty? decrypt_string(response.body): "???";
}

Future<bool> resetdebt(
    String url, String path, String id, Map<String, String> header) async {
  print(Uri.http(url, path, {'id': id}));
  var response =
      await http.get(Uri.http(url, path, {'id': id}), headers: header);
  var esito = jsonDecode(response.body);
  return esito['status'] == '0' ? true : false;
}

Future<List<dynamic>> DBGetCons(
    String url, String path, String id, Map<String, String> header) async {
  List<Consumazione> consumazioni;
  //print(path);
  var response =
      await http.get(Uri.http(url, path, {'id': id}), headers: header);

  if (response.statusCode == 200) {
    print('got consumazioni');
    print(response.body);
    pippo = jsonDecode(response.body);
  } else {
    consumazioni = [];
  }
  print(pippo.isEmpty ? "VUOTO" : pippo[0]);
  return pippo;
}
