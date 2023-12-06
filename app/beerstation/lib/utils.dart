import 'package:encrypt/encrypt.dart'
    as encryptPackage; //altrimenti ambiguous import

import 'package:encrypt/encrypt.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:beerstation/obj/user.dart';
import 'package:beerstation/obj/consumazione.dart';
import 'dart:convert';

const url = '192.168.1.104:80';
const loginUrl = '/API/login.php';
const registerUrl = '/API/register.php';
const resetUrl = '/API/resetdebt.php';
const retrieveConsumazioniUrl = '/API/getconsumazioni.php';
List<dynamic> pippo = [];

class Encryption {
  static final Encryption instance = Encryption._();

  // non puo essere nullable, promessa per il futuro
  // underscore serve per rendere le var private al file dart
  // TODO: usa underscore nelle altre classi quando serve
  late IV _iv;
  late Encrypter _encrypter;

  Encryption._() {
    final utf8_key = utf8.encode('fh934fhdwofj340rjf390hf390h43232');
    final utf8_iv = utf8.encode('hf934fhewfudsifs');

    final key = sha256.convert(utf8_key).toString().substring(0, 32);
    final iv = sha256.convert(utf8_iv).toString().substring(0, 16);
    _iv = IV.fromUtf8(iv);
    _encrypter =
        Encrypter(AES(encryptPackage.Key.fromUtf8(key), mode: AESMode.cbc));
  }

  String encrypt(String toEncrypt) {
    return _encrypter.encrypt(toEncrypt, iv: _iv).base64;
  }

  String decrypt(String toDecrypt) {
    final coso = Encrypted.fromBase64(toDecrypt);
    return _encrypter.decrypt(coso, iv: _iv);
  }
}

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

/*
String encrypt_string(String str) {
  final encrypter =
      encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  return encrypter.encrypt(str, iv: iv).base64;
}
*/

/*
String decrypt_string(String str) {
  final encrypter =
      encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  return encrypter.decrypt(encrypt.Encrypted.fromBase64(str), iv: iv);
}
*/

bool checkFields(mail, psw) {
  return mail.text.isNotEmpty && psw.text.isNotEmpty;
}

Future<User> DBPost(String url, String path, Map<String, String> header,
    Map<String, String> payload) async {
  print("$url, $path");
  //final encryptedpayload = Encryption.instance.encrypt(payload.toString());
  final response = await http.post(
    Uri.http(url, path),
    headers: header,
    body: payload,
  );
  print(response.statusCode == 200 ? "DEBUG: Response code = 200" : 'NOT GOOD');

  if (response.statusCode == 200) {
    print(response.body);

    return User.fromEncryptedJson(jsonDecode(response.body));
  } else {
    throw Exception('Fallita creazione obj utente');
  }
  //return response.statusCode == 200 && response.body.isNotEmpty? decrypt_string(response.body): "???";
}

Future<bool> resetdebt(
    String url, String path, String id, Map<String, String> header) async {
  print(Uri.http(url, path, {'id': id}));
  var encryptedId = Encryption.instance.encrypt(id);
  var response =
      await http.get(Uri.http(url, path, {'id': encryptedId}), headers: header);
  var esito = jsonDecode(response.body);
  return Encryption.instance.decrypt(esito['status']).toString() == '0'
      ? true
      : false;
}

Future<List<dynamic>> DBGetCons(
    String url, String path, String id, Map<String, String> header) async {
  List<Consumazione> consumazioni;
  //print(path);
  var response =
      await http.get(Uri.http(url, path, {'id': id}), headers: header);

  if (response.statusCode == 200) {
    print('Got Consumazioni');
    print(response.body);
    var encrypted_pippo = jsonDecode(response.body);

    // Decrypting every consumazione field in every consumazione in cosumazione list
    for (var i = 0; i < encrypted_pippo.length; i++) {
      pippo[i]['id'] = Encryption.instance.decrypt(encrypted_pippo[i]['id']);
      pippo[i]['user_id'] =
          Encryption.instance.decrypt(encrypted_pippo[i]['user_id']);
      pippo[i]['beer_id'] =
          Encryption.instance.decrypt(encrypted_pippo[i]['beer_id']);
      pippo[i]['quantita'] =
          Encryption.instance.decrypt(encrypted_pippo[i]['quantita']);
      pippo[i]['importo'] =
          Encryption.instance.decrypt(encrypted_pippo[i]['importo']);
      pippo[i]['data_consumazione'] =
          Encryption.instance.decrypt(encrypted_pippo[i]['data_consumazione']);
    }
  } else {
    consumazioni = [];
  }
  print(pippo.isEmpty ? "VUOTO" : pippo[0]);
  return pippo;
}
