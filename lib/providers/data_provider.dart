// lib/providers/data_provider.dart
import 'package:flutter/material.dart';
import '../models/data_api_model.dart';
import '../services/api_service.dart';

class DataProvider with ChangeNotifier {
  DataAPIModel? _data;
  bool _isLoading = false;
  String? _error;

  DataAPIModel? get data => _data;

  bool get isLoading => _isLoading;

  String? get error => _error;

  final ApiService _apiService = ApiService();

  Future<void> fetchData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _data = await _apiService.fetchData();
    } catch (e) {
      _error = e.toString();
      _data = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
