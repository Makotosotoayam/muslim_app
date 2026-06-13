class ShalatChecklist {
  bool subuh;
  bool dzuhur;
  bool ashar;
  bool maghrib;
  bool isya;
  String tanggal;

  ShalatChecklist({
    required this.subuh,
    required this.dzuhur,
    required this.ashar,
    required this.maghrib,
    required this.isya,
    required this.tanggal,
  });

  Map<String, dynamic> toMap() {
    return {
      'subuh': subuh,
      'dzuhur': dzuhur,
      'ashar': ashar,
      'maghrib': maghrib,
      'isya': isya,
      'tanggal': tanggal,
    };
  }

  factory ShalatChecklist.fromMap(Map<String, dynamic> map) {
    return ShalatChecklist(
      subuh: map['subuh'] ?? false,
      dzuhur: map['dzuhur'] ?? false,
      ashar: map['ashar'] ?? false,
      maghrib: map['maghrib'] ?? false,
      isya: map['isya'] ?? false,
      tanggal: map['tanggal'] ?? '',
    );
  }
}

class InfaqRecord {
  final String id;
  final String tanggal;
  final int nominal;
  final String keterangan;
  final DateTime createdAt;

  InfaqRecord({
    required this.id,
    required this.tanggal,
    required this.nominal,
    required this.keterangan,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tanggal': tanggal,
      'nominal': nominal,
      'keterangan': keterangan,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory InfaqRecord.fromMap(Map<String, dynamic> map) {
    return InfaqRecord(
      id: map['id'] ?? '',
      tanggal: map['tanggal'] ?? '',
      nominal: map['nominal'] ?? 0,
      keterangan: map['keterangan'] ?? '',
      createdAt:
          DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class CeramahRecord {
  final String id;
  final String tanggal;
  final String judul;
  final String penceramah;
  final String catatan;
  final String lokasi;
  final DateTime createdAt;

  CeramahRecord({
    required this.id,
    required this.tanggal,
    required this.judul,
    required this.penceramah,
    required this.catatan,
    required this.lokasi,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tanggal': tanggal,
      'judul': judul,
      'penceramah': penceramah,
      'catatan': catatan,
      'lokasi': lokasi,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CeramahRecord.fromMap(Map<String, dynamic> map) {
    return CeramahRecord(
      id: map['id'] ?? '',
      tanggal: map['tanggal'] ?? '',
      judul: map['judul'] ?? '',
      penceramah: map['penceramah'] ?? '',
      catatan: map['catatan'] ?? '',
      lokasi: map['lokasi'] ?? '',
      createdAt:
          DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}
