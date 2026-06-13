import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/doa_model.dart';
import '../services/storage_service.dart';

class DoaViewModel extends ChangeNotifier {
  List<Doa> _doaList = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Doa> get doaList => _doaList;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchAndSaveDoa() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // LANGSUNG FETCH DARI API, IGNORE STORAGE DULU
      print('📡 Fetching Doa from API...');
      final response = await http
          .get(
            Uri.parse('https://doa-doa-api-ahmadramadhan.fly.dev/api'),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('✅ API returned ${data.length} doa');

        // Debug: print doa pertama
        if (data.isNotEmpty) {
          print('📝 First doa from API: ${data[0]}');
        }

        _doaList = data.map((json) => Doa.fromJson(json)).toList();
        print('✅ Parsed ${_doaList.length} doa');

        // Debug: print doa pertama setelah parsing
        if (_doaList.isNotEmpty) {
          print('📝 First doa parsed - Judul: ${_doaList[0].judul}');
          print('📝 First doa parsed - Arab: ${_doaList[0].arab}');
          print('📝 First doa parsed - Latin: ${_doaList[0].latin}');
          print('📝 First doa parsed - Arti: ${_doaList[0].artinya}');
        }

        // Simpan ke storage
        await StorageService.saveDoa(_doaList);
        print('✅ Saved to storage');
      } else {
        _errorMessage = 'Gagal memuat doa (Status: ${response.statusCode})';
      }
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
      print('❌ Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshData() async {
    // Bersihkan storage dulu
    await StorageService.clearAll();
    print('🗑️ Storage cleared');
    // Ambil data baru
    await fetchAndSaveDoa();
  }
}
