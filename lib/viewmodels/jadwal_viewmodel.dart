import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/jadwal_model.dart';
import '../services/storage_service.dart';

class JadwalViewModel extends ChangeNotifier {
  JadwalData? _jadwalHariIni;
  bool _isLoading = false;
  String _errorMessage = '';
  int _selectedKotaId = 1206;
  String _selectedKotaNama = 'Jakarta';
  DateTime _selectedDate = DateTime.now();

  JadwalData? get jadwalHariIni => _jadwalHariIni;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  int get selectedKotaId => _selectedKotaId;
  String get selectedKotaNama => _selectedKotaNama;
  DateTime get selectedDate => _selectedDate;

  final List<Kota> daftarKota = [
    Kota(id: 1206, nama: 'Jakarta'),
    Kota(id: 1207, nama: 'Bandung'),
    Kota(id: 1208, nama: 'Surabaya'),
    Kota(id: 1209, nama: 'Medan'),
    Kota(id: 1210, nama: 'Semarang'),
    Kota(id: 1211, nama: 'Yogyakarta'),
    Kota(id: 1212, nama: 'Makassar'),
    Kota(id: 1213, nama: 'Palembang'),
    Kota(id: 1214, nama: 'Denpasar'),
    Kota(id: 1215, nama: 'Manado'),
  ];

  Future<void> fetchJadwal() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final url =
          'https://api.myquran.com/v2/sholat/jadwal/$_selectedKotaId/${_selectedDate.year}/${_selectedDate.month}/${_selectedDate.day}';
      print('📡 Fetching: $url');

      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('✅ API Response received');

        if (data['status'] == false) {
          _errorMessage = 'Data jadwal tidak tersedia untuk tanggal ini';
          _jadwalHariIni = null;
        } else {
          final jadwalResp = JadwalResponse.fromJson(data);
          _jadwalHariIni = jadwalResp.data;
          await StorageService.saveJadwal(_jadwalHariIni!, _selectedKotaId);
          print(
              '✅ Jadwal saved for ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}');
        }
      } else {
        _errorMessage = 'Gagal memuat jadwal (${response.statusCode})';
        _jadwalHariIni =
            await StorageService.loadJadwal(_selectedKotaId, _selectedDate);
        if (_jadwalHariIni != null) {
          _errorMessage = '';
          print('📂 Loaded from storage');
        }
      }
    } catch (e) {
      print('❌ Error: $e');
      _errorMessage = 'Error: ${e.toString()}';
      _jadwalHariIni =
          await StorageService.loadJadwal(_selectedKotaId, _selectedDate);
      if (_jadwalHariIni == null) {
        _errorMessage = 'Periksa koneksi internet Anda';
      } else {
        _errorMessage = '';
        print('📂 Loaded from storage (offline mode)');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


 
  void changeKota(int id, String nama) {
    _selectedKotaId = id;
    _selectedKotaNama = nama;
    fetchJadwal();
  }

  void changeDate(DateTime newDate) {
    _selectedDate = newDate;
    fetchJadwal();
  }
}
