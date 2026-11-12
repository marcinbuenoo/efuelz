import 'dart:convert';
import 'package:http/http.dart' as http;

class VehicleCatalog {
  static const _baseUrl = 'https://brasilapi.com.br/api/fipe';

  Future<List<Map<String, dynamic>>> brands() async {
    final response = await http
        .get(Uri.parse('$_baseUrl/marcas/v1/carros'))
        .timeout(const Duration(seconds: 12));
    if (response.statusCode != 200) {
      throw const FormatException('Não foi possível consultar as marcas.');
    }
    return (jsonDecode(response.body) as List).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> models(String brandCode) async {
    final response = await http
        .get(Uri.parse('$_baseUrl/veiculos/v1/carros/$brandCode'))
        .timeout(const Duration(seconds: 12));
    if (response.statusCode != 200) {
      throw const FormatException('Não foi possível consultar os modelos.');
    }
    return (jsonDecode(response.body) as List).cast<Map<String, dynamic>>();
  }
}
