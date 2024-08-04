import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/auto_model.dart';

class AutoRepository {
  final String apiUrl;

  AutoRepository({required this.apiUrl});

  Future<List<AutoModel>> getAllAutos() async {
    final response = await http.get(
      Uri.parse('$apiUrl/get'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> l = json.decode(response.body);
      return List<AutoModel>.from(l.map((model) => AutoModel.fromJson(model)));
    } else {
      throw Exception('Ocurrió un error al obtener los autos');
    }
  }

  Future<void> createAuto(AutoModel auto) async {
    final response = await http.post(
      Uri.parse('$apiUrl/post'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(auto.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Ocurrió un error al crear el auto');
    }
  }

  Future<void> updateAuto(AutoModel auto) async {
    final response = await http.put(
      Uri.parse('$apiUrl/put'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(auto.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Ocurrió un error al actualizar el auto');
    }
  }

  Future<void> deleteAuto(int id) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/delete'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'id': id}),
    );

    if (response.statusCode != 200) {
      throw Exception('Ocurrió un error al eliminar el auto');
    }
  }
}
