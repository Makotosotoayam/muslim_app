import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/alquran_model.dart';
import '../models/doa_model.dart';
import '../models/jadwal_model.dart';
import '../models/ramadhan_model.dart';
import '../models/asmaul_model.dart'; // ← IMPORT MODEL RAMADHAN

class StorageService {
  static const String _suratKey = 'alquran_surat';
  static const String _doaKey = 'doa_harian';

  static Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  // ========== AL-QURAN OPERATIONS ==========

  static Future<void> saveAlQuran(List<Surat> suratList) async {
    try {
      final prefs = await _getPrefs();
      List<Map<String, dynamic>> suratMaps = suratList
          .map((surat) => {
                'nomor': surat.nomor,
                'nama': surat.nama,
                'namaLatin': surat.namaLatin,
                'jumlahAyat': surat.jumlahAyat,
                'tempatTurun': surat.tempatTurun,
                'arti': surat.arti,
                'deskripsi': surat.deskripsi,
                'audio': surat.audio,
              })
          .toList();

      await prefs.setString(_suratKey, jsonEncode(suratMaps));
      print('✅ Al-Quran saved: ${suratList.length} surat');
    } catch (e) {
      print('❌ Error saving Al-Quran: $e');
    }
  }

  static Future<List<Surat>> loadAlQuran() async {
    try {
      final prefs = await _getPrefs();
      String? suratString = prefs.getString(_suratKey);
      if (suratString == null || suratString.isEmpty) return [];

      List<dynamic> suratMaps = jsonDecode(suratString);
      return suratMaps
          .map((map) => Surat(
                nomor: map['nomor'] ?? 0,
                nama: map['nama'] ?? '',
                namaLatin: map['namaLatin'] ?? '',
                jumlahAyat: map['jumlahAyat'] ?? 0,
                tempatTurun: map['tempatTurun'] ?? '',
                arti: map['arti'] ?? '',
                deskripsi: map['deskripsi'] ?? '',
                audio: map['audio'] ?? '',
              ))
          .toList();
    } catch (e) {
      print('❌ Error loading Al-Quran: $e');
      return [];
    }
  }

  static Future<bool> hasAlQuran() async {
    try {
      final prefs = await _getPrefs();
      return prefs.containsKey(_suratKey);
    } catch (e) {
      return false;
    }
  }

  // ========== DOA OPERATIONS ==========

  static Future<void> saveDoa(List<Doa> doaList) async {
    try {
      final prefs = await _getPrefs();
      List<Map<String, dynamic>> doaMaps = doaList
          .map((doa) => {
                'id': doa.id,
                'judul': doa.judul,
                'arab': doa.arab,
                'latin': doa.latin,
                'artinya': doa.artinya,
              })
          .toList();

      await prefs.setString(_doaKey, jsonEncode(doaMaps));
      print('✅ Doa saved: ${doaList.length} items');
    } catch (e) {
      print('❌ Error saving Doa: $e');
    }
  }

  static Future<List<Doa>> loadDoa() async {
    try {
      final prefs = await _getPrefs();
      String? doaString = prefs.getString(_doaKey);
      if (doaString == null || doaString.isEmpty) return [];

      List<dynamic> doaMaps = jsonDecode(doaString);
      List<Doa> doaList = [];
      for (var map in doaMaps) {
        doaList.add(Doa(
          id: map['id']?.toString() ?? '',
          judul: map['judul'] ?? '',
          arab: map['arab'] ?? '',
          latin: map['latin'] ?? '',
          artinya: map['artinya'] ?? '',
        ));
      }
      return doaList;
    } catch (e) {
      print('❌ Error loading Doa: $e');
      return [];
    }
  }

  static Future<bool> hasDoa() async {
    try {
      final prefs = await _getPrefs();
      return prefs.containsKey(_doaKey);
    } catch (e) {
      return false;
    }
  }

  // ========== JADWAL SHALAT OPERATIONS ==========

  static Future<void> saveJadwal(JadwalData jadwal, int kotaId) async {
    try {
      final prefs = await _getPrefs();
      final key =
          'jadwal_${kotaId}_${jadwal.tahun}_${jadwal.bulan}_${jadwal.tanggal}';

      final Map<String, dynamic> data = {
        'tahun': jadwal.tahun,
        'bulan': jadwal.bulan,
        'tanggal': jadwal.tanggal,
        'hari': jadwal.hari,
        'imsak': jadwal.jadwal.imsak,
        'subuh': jadwal.jadwal.subuh,
        'terbit': jadwal.jadwal.terbit,
        'dhuha': jadwal.jadwal.dhuha,
        'dzuhur': jadwal.jadwal.dzuhur,
        'ashar': jadwal.jadwal.ashar,
        'maghrib': jadwal.jadwal.maghrib,
        'isya': jadwal.jadwal.isya,
      };

      await prefs.setString(key, jsonEncode(data));
      print('✅ Jadwal saved for kota $kotaId');
    } catch (e) {
      print('❌ Error saving jadwal: $e');
    }
  }

  static Future<JadwalData?> loadJadwal(int kotaId, DateTime date) async {
    try {
      final prefs = await _getPrefs();
      final key = 'jadwal_${kotaId}_${date.year}_${date.month}_${date.day}';
      final String? dataString = prefs.getString(key);

      if (dataString == null) return null;

      final Map<String, dynamic> json = jsonDecode(dataString);

      return JadwalData(
        tahun: json['tahun'] ?? '',
        bulan: json['bulan'] ?? '',
        tanggal: json['tanggal'] ?? '',
        hari: json['hari'] ?? '',
        jadwal: Jadwal(
          imsak: json['imsak'] ?? '',
          subuh: json['subuh'] ?? '',
          terbit: json['terbit'] ?? '',
          dhuha: json['dhuha'] ?? '',
          dzuhur: json['dzuhur'] ?? '',
          ashar: json['ashar'] ?? '',
          maghrib: json['maghrib'] ?? '',
          isya: json['isya'] ?? '',
        ),
      );
    } catch (e) {
      print('❌ Error loading jadwal: $e');
      return null;
    }
  }

  // ========== RAMADHAN / SHAUM TRACKER ==========

  static const String _shalatKey = 'shalat_checklist_';
  static const String _infaqKey = 'infaq_records';
  static const String _ceramahKey = 'ceramah_records';

  // Shalat Checklist
  static Future<void> saveShalatChecklist(ShalatChecklist checklist) async {
    try {
      final prefs = await _getPrefs();
      final key = '$_shalatKey${checklist.tanggal}';
      await prefs.setString(key, jsonEncode(checklist.toMap()));
      print('✅ Shalat checklist saved for ${checklist.tanggal}');
    } catch (e) {
      print('❌ Error saving shalat checklist: $e');
    }
  }

  static Future<ShalatChecklist?> loadShalatChecklist(String tanggal) async {
    try {
      final prefs = await _getPrefs();
      final key = '$_shalatKey$tanggal';
      final String? data = prefs.getString(key);
      if (data == null) return null;
      return ShalatChecklist.fromMap(jsonDecode(data));
    } catch (e) {
      print('❌ Error loading shalat checklist: $e');
      return null;
    }
  }

  // Infaq Records
  static Future<void> saveInfaqRecord(InfaqRecord record) async {
    try {
      final prefs = await _getPrefs();
      List<String> records = prefs.getStringList(_infaqKey) ?? [];
      records.add(jsonEncode(record.toMap()));
      await prefs.setStringList(_infaqKey, records);
      print('✅ Infaq record saved: Rp ${record.nominal}');
    } catch (e) {
      print('❌ Error saving infaq record: $e');
    }
  }

  static Future<List<InfaqRecord>> loadInfaqRecords() async {
    try {
      final prefs = await _getPrefs();
      List<String> records = prefs.getStringList(_infaqKey) ?? [];
      return records.map((r) => InfaqRecord.fromMap(jsonDecode(r))).toList();
    } catch (e) {
      print('❌ Error loading infaq records: $e');
      return [];
    }
  }

  static Future<void> deleteInfaqRecord(String id) async {
    try {
      final prefs = await _getPrefs();
      List<String> records = prefs.getStringList(_infaqKey) ?? [];
      records.removeWhere((r) {
        final record = InfaqRecord.fromMap(jsonDecode(r));
        return record.id == id;
      });
      await prefs.setStringList(_infaqKey, records);
      print('✅ Infaq record deleted');
    } catch (e) {
      print('❌ Error deleting infaq record: $e');
    }
  }

  // Ceramah Records
  static Future<void> saveCeramahRecord(CeramahRecord record) async {
    try {
      final prefs = await _getPrefs();
      List<String> records = prefs.getStringList(_ceramahKey) ?? [];
      records.add(jsonEncode(record.toMap()));
      await prefs.setStringList(_ceramahKey, records);
      print('✅ Ceramah record saved: ${record.judul}');
    } catch (e) {
      print('❌ Error saving ceramah record: $e');
    }
  }

  static Future<List<CeramahRecord>> loadCeramahRecords() async {
    try {
      final prefs = await _getPrefs();
      List<String> records = prefs.getStringList(_ceramahKey) ?? [];
      return records.map((r) => CeramahRecord.fromMap(jsonDecode(r))).toList();
    } catch (e) {
      print('❌ Error loading ceramah records: $e');
      return [];
    }
  }

  static Future<void> deleteCeramahRecord(String id) async {
    try {
      final prefs = await _getPrefs();
      List<String> records = prefs.getStringList(_ceramahKey) ?? [];
      records.removeWhere((r) {
        final record = CeramahRecord.fromMap(jsonDecode(r));
        return record.id == id;
      });
      await prefs.setStringList(_ceramahKey, records);
      print('✅ Ceramah record deleted');
    } catch (e) {
      print('❌ Error deleting ceramah record: $e');
    }
  }

  // ========== GENERAL OPERATIONS ==========

  static Future<void> clearAll() async {
    try {
      final prefs = await _getPrefs();
      await prefs.clear();
      print('🗑️ All data cleared');
    } catch (e) {
      print('❌ Error clearing data: $e');
    }
  }

  static Future<void> clearAlQuran() async {
    try {
      final prefs = await _getPrefs();
      await prefs.remove(_suratKey);
      print('🗑️ Al-Quran data cleared');
    } catch (e) {
      print('❌ Error clearing Al-Quran: $e');
    }
  }

  static Future<void> clearDoa() async {
    try {
      final prefs = await _getPrefs();
      await prefs.remove(_doaKey);
      print('🗑️ Doa data cleared');
    } catch (e) {
      print('❌ Error clearing Doa: $e');
    }
  }

  static Future<void> clearAllJadwal() async {
    try {
      final prefs = await _getPrefs();
      final keys = prefs.getKeys();
      for (var key in keys) {
        if (key.startsWith('jadwal_')) {
          await prefs.remove(key);
        }
      }
      print('🗑️ All jadwal data cleared');
    } catch (e) {
      print('❌ Error clearing jadwal: $e');
    }
  }

  static Future<void> clearAllRamadhanData() async {
    try {
      final prefs = await _getPrefs();
      final keys = prefs.getKeys();
      for (var key in keys) {
        if (key.startsWith(_shalatKey) ||
            key == _infaqKey ||
            key == _ceramahKey) {
          await prefs.remove(key);
        }
      }
      print('🗑️ All Ramadhan data cleared');
    } catch (e) {
      print('❌ Error clearing Ramadhan data: $e');
    }
  }

  // ========== ASMAUL HUSNA OPERATIONS ==========
  static const String _asmaulKey = 'asmaul_husna';

  static Future<void> saveAsmaul(List<AsmaulHusna> asmaulList) async {
    try {
      final prefs = await _getPrefs();
      List<Map<String, dynamic>> asmaulMaps = asmaulList
          .map((item) => {
                'id': item.id,
                'namaArab': item.namaArab,
                'namaLatin': item.namaLatin,
                'arti': item.arti,
              })
          .toList();

      await prefs.setString(_asmaulKey, jsonEncode(asmaulMaps));
      print('✅ Asmaul Husna saved: ${asmaulList.length} items');
    } catch (e) {
      print('❌ Error saving Asmaul Husna: $e');
    }
  }

  static Future<List<AsmaulHusna>> loadAsmaul() async {
    try {
      final prefs = await _getPrefs();
      String? asmaulString = prefs.getString(_asmaulKey);
      if (asmaulString == null || asmaulString.isEmpty) return [];

      List<dynamic> asmaulMaps = jsonDecode(asmaulString);
      List<AsmaulHusna> asmaulList = [];
      for (var map in asmaulMaps) {
        asmaulList.add(AsmaulHusna(
          id: map['id'] ?? 0,
          namaArab: map['namaArab'] ?? '',
          namaLatin: map['namaLatin'] ?? '',
          arti: map['arti'] ?? '',
        ));
      }
      return asmaulList;
    } catch (e) {
      print('❌ Error loading Asmaul Husna: $e');
      return [];
    }
  }

  static Future<bool> hasAsmaul() async {
    try {
      final prefs = await _getPrefs();
      return prefs.containsKey(_asmaulKey);
    } catch (e) {
      return false;
    }
  }

  static Future<void> clearAsmaul() async {
    try {
      final prefs = await _getPrefs();
      await prefs.remove(_asmaulKey);
      print('🗑️ Asmaul Husna data cleared');
    } catch (e) {
      print('❌ Error clearing Asmaul Husna: $e');
    }
  }
}
