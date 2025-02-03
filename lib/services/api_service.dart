// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/data_api_model.dart';

class ApiService {
  Future<DataAPIModel> fetchData() async {
    final response =
        await http.get(Uri.parse('https://api.mocklets.com/p6764/test_mint'));
    if (response.statusCode == 200) {
      final decodedJson = json.decode(response.body);
      return DataAPIModel.fromJson(decodedJson);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
// lib/models/data_api_model.dart
