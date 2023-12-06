import 'package:beerstation/utils.dart';

class User {
  final String id;
  final String nome;
  final String cognome;
  final String email;
  final String saldo;
  final String datareg;

  const User(
      {required this.id,
      required this.nome,
      required this.cognome,
      required this.email,
      required this.saldo,
      required this.datareg});

  String getId() {
    return this.id;
  }

  factory User.fromEncryptedJson(Map<String, dynamic> json) {
    return User(
        id: Encryption.instance.decrypt(json['id']),
        nome: Encryption.instance.decrypt(json['nome']),
        cognome: Encryption.instance.decrypt(json['cognome']),
        email: Encryption.instance.decrypt(json['email']),
        saldo: Encryption.instance.decrypt(json['saldo']),
        datareg: Encryption.instance.decrypt(json['data_reg']));
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        nome: json['nome'],
        cognome: json['cognome'],
        email: json['email'],
        saldo: json['saldo'],
        datareg: json['data_reg']);
  }
}
