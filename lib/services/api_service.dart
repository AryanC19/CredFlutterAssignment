import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/stack_item_model.dart';

class ApiService {
  Future<List<StackItemModel>> fetchStackItems() async {
    final url = Uri.parse('https://api.mocklets.com/p6764/test_mint');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // The response body has a top-level "items" key
      final Map<String, dynamic> decodedData = json.decode(response.body);
      final List<dynamic> itemsList = decodedData['items'] ?? [];

      List<StackItemModel> result = itemsList
          .map((itemJson) => StackItemModel.fromJson(itemJson))
          .toList();

      return result;
    } else {
      throw Exception('Failed to load items');
    }
  }
}
