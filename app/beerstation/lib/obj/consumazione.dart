import 'dart:ffi';

class Consumazione {
  final String id;
  final String user_id;
  final String beer_id;
  final int quantita;
  final Double importo;
  final String data_consumazione;

  const Consumazione(
      {required this.id,
      required this.user_id,
      required this.beer_id,
      required this.quantita,
      required this.importo,
      required this.data_consumazione});

  String getId() {
    return this.id;
  }

  factory Consumazione.fromJson(Map<String, dynamic> json) {
    return Consumazione(
        id: json['id'],
        user_id: json['user_id'],
        beer_id: json['beer_id'],
        quantita: json['quantita'],
        importo: json['importo'],
        data_consumazione: json['data_consumazione']);
  }
}
