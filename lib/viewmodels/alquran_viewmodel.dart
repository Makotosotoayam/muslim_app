import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/alquran_model.dart';
import '../services/storage_service.dart';

class AlQuranViewModel extends ChangeNotifier {
  List<Surat> _suratList = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Surat> get suratList => _suratList;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchAndSaveAlQuran() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      bool hasData = false;
      try {
        hasData = await StorageService.hasAlQuran();
      } catch (e) {
        print('Storage check error: $e');
        hasData = false;
      }

      if (hasData) {
        try {
          _suratList = await StorageService.loadAlQuran();
          print('Loaded ${_suratList.length} surat from storage');
        } catch (e) {
          print('Error loading from storage: $e');
          _suratList = [];
        }
      }

      if (_suratList.isEmpty) {
        print('Fetching Al-Quran from API...');
        final response = await http
            .get(
              Uri.parse('https://equran.id/api/v2/surat'),
            )
            .timeout(const Duration(seconds: 30));

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          final suratResponse = SuratResponse.fromJson(data);
          _suratList = suratResponse.data;
          print('Fetched ${_suratList.length} surat from API');

          try {
            await StorageService.saveAlQuran(_suratList);
            print('Saved surat to storage');
          } catch (e) {
            print('Error saving to storage: $e');
          }
        } else {
          _errorMessage =
              'Failed to load Al-Quran data (Status: ${response.statusCode})';
        }
      }
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
      print('Error in fetchAndSaveAlQuran: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Method baru untuk ambil detail surat beserta ayat
  Future<SuratDetail?> fetchSuratDetail(int suratNomor) async {
    try {
      print('Fetching detail for surat $suratNomor...');
      final response = await http
          .get(
            Uri.parse('https://equran.id/api/v2/surat/$suratNomor'),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final suratDetail = SuratDetailResponse.fromJson(data);
        print(
            'Fetched ${suratDetail.data.ayat.length} ayat for surat $suratNomor');
        return suratDetail.data;
      } else {
        print('Failed to load surat detail: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching surat detail: $e');
      return null;
    }
  }

  Future<void> refreshData() async {
    try {
      await StorageService.clearAll();
    } catch (e) {
      print('Error clearing data: $e');
    }
    await fetchAndSaveAlQuran();
  }
}
