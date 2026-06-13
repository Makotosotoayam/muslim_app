import 'package:flutter/material.dart';
import '../models/ramadhan_model.dart';
import '../services/storage_service.dart';

class RamadhanViewModel extends ChangeNotifier {
  ShalatChecklist? _shalatHariIni;
  List<InfaqRecord> _infaqList = [];
  List<CeramahRecord> _ceramahList = [];
  bool _isLoading = false;
  String _selectedDate = _getTodayDate();

  ShalatChecklist? get shalatHariIni => _shalatHariIni;
  List<InfaqRecord> get infaqList => _infaqList;
  List<CeramahRecord> get ceramahList => _ceramahList;
  bool get isLoading => _isLoading;
  String get selectedDate => _selectedDate;

  // Hitung statistik
  int get totalShalatTerisi {
    if (_shalatHariIni == null) return 0;
    int count = 0;
    if (_shalatHariIni!.subuh) count++;
    if (_shalatHariIni!.dzuhur) count++;
    if (_shalatHariIni!.ashar) count++;
    if (_shalatHariIni!.maghrib) count++;
    if (_shalatHariIni!.isya) count++;
    return count;
  }

  int get totalInfaqHariIni {
    return _infaqList
        .where((item) => item.tanggal == _selectedDate)
        .fold(0, (sum, item) => sum + item.nominal);
  }

  int get totalInfaqBulanIni {
    final bulanIni = _selectedDate.substring(0, 7); // YYYY-MM
    return _infaqList
        .where((item) => item.tanggal.substring(0, 7) == bulanIni)
        .fold(0, (sum, item) => sum + item.nominal);
  }

  static String _getTodayDate() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    await Future.wait([
      _loadShalat(),
      _loadInfaq(),
      _loadCeramah(),
    ]);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadShalat() async {
    final data = await StorageService.loadShalatChecklist(_selectedDate);
    if (data != null) {
      _shalatHariIni = data;
    } else {
      _shalatHariIni = ShalatChecklist(
        subuh: false,
        dzuhur: false,
        ashar: false,
        maghrib: false,
        isya: false,
        tanggal: _selectedDate,
      );
    }
  }

  Future<void> _loadInfaq() async {
    _infaqList = await StorageService.loadInfaqRecords();
    _infaqList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> _loadCeramah() async {
    _ceramahList = await StorageService.loadCeramahRecords();
    _ceramahList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> toggleShalat(String shalatName) async {
    if (_shalatHariIni == null) return;

    switch (shalatName) {
      case 'subuh':
        _shalatHariIni!.subuh = !_shalatHariIni!.subuh;
        break;
      case 'dzuhur':
        _shalatHariIni!.dzuhur = !_shalatHariIni!.dzuhur;
        break;
      case 'ashar':
        _shalatHariIni!.ashar = !_shalatHariIni!.ashar;
        break;
      case 'maghrib':
        _shalatHariIni!.maghrib = !_shalatHariIni!.maghrib;
        break;
      case 'isya':
        _shalatHariIni!.isya = !_shalatHariIni!.isya;
        break;
    }

    await StorageService.saveShalatChecklist(_shalatHariIni!);
    notifyListeners();
  }

  Future<void> addInfaq(int nominal, String keterangan) async {
    final newInfaq = InfaqRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      tanggal: _selectedDate,
      nominal: nominal,
      keterangan: keterangan,
      createdAt: DateTime.now(),
    );
    _infaqList.insert(0, newInfaq);
    await StorageService.saveInfaqRecord(newInfaq);
    notifyListeners();
  }

  Future<void> deleteInfaq(String id) async {
    _infaqList.removeWhere((item) => item.id == id);
    await StorageService.deleteInfaqRecord(id);
    notifyListeners();
  }

  Future<void> addCeramah({
    required String judul,
    required String penceramah,
    required String catatan,
    required String lokasi,
  }) async {
    final newCeramah = CeramahRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      tanggal: _selectedDate,
      judul: judul,
      penceramah: penceramah,
      catatan: catatan,
      lokasi: lokasi,
      createdAt: DateTime.now(),
    );
    _ceramahList.insert(0, newCeramah);
    await StorageService.saveCeramahRecord(newCeramah);
    notifyListeners();
  }

  Future<void> deleteCeramah(String id) async {
    _ceramahList.removeWhere((item) => item.id == id);
    await StorageService.deleteCeramahRecord(id);
    notifyListeners();
  }

  void changeDate(DateTime newDate) {
    _selectedDate =
        '${newDate.year}-${newDate.month.toString().padLeft(2, '0')}-${newDate.day.toString().padLeft(2, '0')}';
    loadData();
  }
}
