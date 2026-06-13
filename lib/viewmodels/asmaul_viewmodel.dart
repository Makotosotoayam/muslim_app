import 'package:flutter/material.dart';
import '../models/asmaul_model.dart';
import '../services/storage_service.dart';

class AsmaulViewModel extends ChangeNotifier {
  List<AsmaulHusna> _asmaulList = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _searchQuery = '';

  List<AsmaulHusna> get asmaulList => _asmaulList;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  List<AsmaulHusna> get filteredAsmaul {
    if (_searchQuery.isEmpty) return _asmaulList;
    return _asmaulList
        .where((item) =>
            item.namaLatin.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            item.arti.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  Future<void> fetchAndSaveAsmaul() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Cek storage dulu
      bool hasData = await StorageService.hasAsmaul();

      if (hasData) {
        _asmaulList = await StorageService.loadAsmaul();
        print('✅ Loaded ${_asmaulList.length} Asmaul Husna from storage');
      } else {
        // Gunakan DATA LOKAL (tanpa API)
        print('📡 Using local Asmaul Husna data');
        _asmaulList = AsmaulHusna.getLocalData();
        print('✅ Loaded ${_asmaulList.length} Asmaul Husna from local data');

        // Simpan ke storage
        await StorageService.saveAsmaul(_asmaulList);
      }
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
      print('❌ Error: $e');

      // Fallback: gunakan data lokal jika terjadi error
      _asmaulList = AsmaulHusna.getLocalData();
      print('✅ Fallback to local data: ${_asmaulList.length} items');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> refreshData() async {
    await StorageService.clearAsmaul();
    await fetchAndSaveAsmaul();
  }
}
