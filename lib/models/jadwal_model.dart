class JadwalResponse {
  final int code;
  final String status;
  final JadwalData data;

  JadwalResponse({
    required this.code,
    required this.status,
    required this.data,
  });

  factory JadwalResponse.fromJson(Map<String, dynamic> json) {
    return JadwalResponse(
      code: json['code'] ?? 0,
      status: json['status']?.toString() ?? '',
      data: JadwalData.fromJson(json['data'] ?? {}),
    );
  }
}

class JadwalData {
  final String tahun;
  final String bulan;
  final String tanggal;
  final String hari;
  final Jadwal jadwal;

  JadwalData({
    required this.tahun,
    required this.bulan,
    required this.tanggal,
    required this.hari,
    required this.jadwal,
  });

  factory JadwalData.fromJson(Map<String, dynamic> json) {
    return JadwalData(
      tahun: _toStringSafe(json['tahun']),
      bulan: _toStringSafe(json['bulan']),
      tanggal: _toStringSafe(json['tanggal']),
      hari: _toStringSafe(json['hari']),
      jadwal: Jadwal.fromJson(json['jadwal'] ?? {}),
    );
  }
}

class Jadwal {
  final String imsak;
  final String subuh;
  final String terbit;
  final String dhuha;
  final String dzuhur;
  final String ashar;
  final String maghrib;
  final String isya;

  Jadwal({
    required this.imsak,
    required this.subuh,
    required this.terbit,
    required this.dhuha,
    required this.dzuhur,
    required this.ashar,
    required this.maghrib,
    required this.isya,
  });

  factory Jadwal.fromJson(Map<String, dynamic> json) {
    return Jadwal(
      imsak: _toStringSafe(json['imsak']),
      subuh: _toStringSafe(json['subuh']),
      terbit: _toStringSafe(json['terbit']),
      dhuha: _toStringSafe(json['dhuha']),
      dzuhur: _toStringSafe(json['dzuhur']),
      ashar: _toStringSafe(json['ashar']),
      maghrib: _toStringSafe(json['maghrib']),
      isya: _toStringSafe(json['isya']),
    );
  }
}

class Kota {
  final int id;
  final String nama;

  Kota({
    required this.id,
    required this.nama,
  });
}

// Helper function untuk mengkonversi apapun ke String dengan aman
String _toStringSafe(dynamic value) {
  if (value == null) return '';
  if (value is bool) return value ? 'true' : 'false';
  return value.toString();
}
