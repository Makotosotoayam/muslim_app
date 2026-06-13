// Model untuk response detail surat
class SuratDetailResponse {
  final int code;
  final String message;
  final SuratDetail data;

  SuratDetailResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory SuratDetailResponse.fromJson(Map<String, dynamic> json) {
    return SuratDetailResponse(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: SuratDetail.fromJson(json['data'] ?? {}),
    );
  }
}

// Model untuk detail surat dengan ayat
class SuratDetail {
  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;
  final String tempatTurun;
  final String arti;
  final String deskripsi;
  final String audio;
  final List<Ayat> ayat; // Tambahkan list ayat

  SuratDetail({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
    required this.deskripsi,
    required this.audio,
    required this.ayat,
  });

  factory SuratDetail.fromJson(Map<String, dynamic> json) {
    return SuratDetail(
      nomor: json['nomor'] ?? 0,
      nama: json['nama'] ?? '',
      namaLatin: json['namaLatin'] ?? '',
      jumlahAyat: json['jumlahAyat'] ?? 0,
      tempatTurun: json['tempatTurun'] ?? '',
      arti: json['arti'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      audio: json['audio'] ?? '',
      ayat: json['ayat'] != null
          ? List<Ayat>.from(json['ayat'].map((x) => Ayat.fromJson(x)))
          : [],
    );
  }
}

// Model untuk Ayat
class Ayat {
  final int nomorAyat;
  final String teksArab;
  final String teksLatin;
  final String teksIndonesia;

  Ayat({
    required this.nomorAyat,
    required this.teksArab,
    required this.teksLatin,
    required this.teksIndonesia,
  });

  factory Ayat.fromJson(Map<String, dynamic> json) {
    return Ayat(
      nomorAyat: json['nomorAyat'] ?? 0,
      teksArab: json['teksArab'] ?? '',
      teksLatin: json['teksLatin'] ?? '',
      teksIndonesia: json['teksIndonesia'] ?? '',
    );
  }
}

// Model untuk list surat (tetap seperti sebelumnya)
class SuratResponse {
  final int code;
  final String message;
  final List<Surat> data;

  SuratResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory SuratResponse.fromJson(Map<String, dynamic> json) {
    return SuratResponse(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? List<Surat>.from(json['data'].map((x) => Surat.fromJson(x)))
          : [],
    );
  }
}

class Surat {
  final int nomor;
  final String nama;
  final String namaLatin;
  final int jumlahAyat;
  final String tempatTurun;
  final String arti;
  final String deskripsi;
  final String audio;

  Surat({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.jumlahAyat,
    required this.tempatTurun,
    required this.arti,
    required this.deskripsi,
    required this.audio,
  });

  factory Surat.fromJson(Map<String, dynamic> json) {
    return Surat(
      nomor: json['nomor'] ?? 0,
      nama: json['nama'] ?? '',
      namaLatin: json['namaLatin'] ?? '',
      jumlahAyat: json['jumlahAyat'] ?? 0,
      tempatTurun: json['tempatTurun'] ?? '',
      arti: json['arti'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      audio: json['audio'] ?? '',
    );
  }
}
