import 'dart:convert';

import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchMyData() async {
  final response =
      await http.get(Uri.parse('http://www.delescaut.ch/conn_db.php'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Erreur de chargement des données');
  }
}
