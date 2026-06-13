class AsmaulHusna {
  final int id;
  final String namaArab;
  final String namaLatin;
  final String arti;

  AsmaulHusna({
    required this.id,
    required this.namaArab,
    required this.namaLatin,
    required this.arti,
  });

  factory AsmaulHusna.fromJson(Map<String, dynamic> json) {
    return AsmaulHusna(
      id: json['id'] ?? 0,
      namaArab: json['arab'] ?? '',
      namaLatin: json['latin'] ?? '',
      arti: json['arti'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'namaArab': namaArab,
      'namaLatin': namaLatin,
      'arti': arti,
    };
  }

  // DATA LOKAL ASMAUL HUSNA (99 Nama Allah)
  static List<AsmaulHusna> getLocalData() {
    return [
      AsmaulHusna(
          id: 1,
          namaArab: 'الرَّحْمَنُ',
          namaLatin: 'Ar-Rahman',
          arti: 'Yang Maha Pengasih'),
      AsmaulHusna(
          id: 2,
          namaArab: 'الرَّحِيمُ',
          namaLatin: 'Ar-Rahim',
          arti: 'Yang Maha Penyayang'),
      AsmaulHusna(
          id: 3,
          namaArab: 'الْمَلِكُ',
          namaLatin: 'Al-Malik',
          arti: 'Yang Maha Merajai'),
      AsmaulHusna(
          id: 4,
          namaArab: 'الْقُدُّوسُ',
          namaLatin: 'Al-Quddus',
          arti: 'Yang Maha Suci'),
      AsmaulHusna(
          id: 5,
          namaArab: 'السَّلاَمُ',
          namaLatin: 'As-Salam',
          arti: 'Yang Maha Memberi Kesejahteraan'),
      AsmaulHusna(
          id: 6,
          namaArab: 'الْمُؤْمِنُ',
          namaLatin: 'Al-Mu\'min',
          arti: 'Yang Maha Memberi Keamanan'),
      AsmaulHusna(
          id: 7,
          namaArab: 'الْمُهَيْمِنُ',
          namaLatin: 'Al-Muhaymin',
          arti: 'Yang Maha Memelihara'),
      AsmaulHusna(
          id: 8,
          namaArab: 'الْعَزِيزُ',
          namaLatin: 'Al-Aziz',
          arti: 'Yang Maha Perkasa'),
      AsmaulHusna(
          id: 9,
          namaArab: 'الْجَبَّارُ',
          namaLatin: 'Al-Jabbar',
          arti: 'Yang Maha Perkasa (Memaksa)'),
      AsmaulHusna(
          id: 10,
          namaArab: 'الْمُتَكَبِّرُ',
          namaLatin: 'Al-Mutakabbir',
          arti: 'Yang Maha Megah'),
      AsmaulHusna(
          id: 11,
          namaArab: 'الْخَالِقُ',
          namaLatin: 'Al-Khaliq',
          arti: 'Yang Maha Pencipta'),
      AsmaulHusna(
          id: 12,
          namaArab: 'الْبَارِئُ',
          namaLatin: 'Al-Bari\'',
          arti: 'Yang Maha Mengadakan'),
      AsmaulHusna(
          id: 13,
          namaArab: 'الْمُصَوِّرُ',
          namaLatin: 'Al-Musawwir',
          arti: 'Yang Maha Membentuk Rupa'),
      AsmaulHusna(
          id: 14,
          namaArab: 'الْغَفَّارُ',
          namaLatin: 'Al-Ghaffar',
          arti: 'Yang Maha Pengampun'),
      AsmaulHusna(
          id: 15,
          namaArab: 'الْقَهَّارُ',
          namaLatin: 'Al-Qahhar',
          arti: 'Yang Maha Mengalahkan'),
      AsmaulHusna(
          id: 16,
          namaArab: 'الْوَهَّابُ',
          namaLatin: 'Al-Wahhab',
          arti: 'Yang Maha Pemberi Karunia'),
      AsmaulHusna(
          id: 17,
          namaArab: 'الرَّزَّاقُ',
          namaLatin: 'Ar-Razzaq',
          arti: 'Yang Maha Pemberi Rezeki'),
      AsmaulHusna(
          id: 18,
          namaArab: 'الْفَتَّاحُ',
          namaLatin: 'Al-Fattah',
          arti: 'Yang Maha Pembuka Rahmat'),
      AsmaulHusna(
          id: 19,
          namaArab: 'الْعَلِيمُ',
          namaLatin: 'Al-Alim',
          arti: 'Yang Maha Mengetahui'),
      AsmaulHusna(
          id: 20,
          namaArab: 'الْقَابِضُ',
          namaLatin: 'Al-Qabid',
          arti: 'Yang Maha Menyempitkan'),
      AsmaulHusna(
          id: 21,
          namaArab: 'الْبَاسِطُ',
          namaLatin: 'Al-Basit',
          arti: 'Yang Maha Melapangkan'),
      AsmaulHusna(
          id: 22,
          namaArab: 'الْخَافِضُ',
          namaLatin: 'Al-Khafid',
          arti: 'Yang Maha Merendahkan'),
      AsmaulHusna(
          id: 23,
          namaArab: 'الرَّافِعُ',
          namaLatin: 'Ar-Rafi\'',
          arti: 'Yang Maha Meninggikan'),
      AsmaulHusna(
          id: 24,
          namaArab: 'الْمُعِزُّ',
          namaLatin: 'Al-Mu\'izz',
          arti: 'Yang Maha Memuliakan'),
      AsmaulHusna(
          id: 25,
          namaArab: 'الْمُذِلُّ',
          namaLatin: 'Al-Mudhill',
          arti: 'Yang Maha Menghinakan'),
      AsmaulHusna(
          id: 26,
          namaArab: 'السَّمِيعُ',
          namaLatin: 'As-Sami\'',
          arti: 'Yang Maha Mendengar'),
      AsmaulHusna(
          id: 27,
          namaArab: 'الْبَصِيرُ',
          namaLatin: 'Al-Basir',
          arti: 'Yang Maha Melihat'),
      AsmaulHusna(
          id: 28,
          namaArab: 'الْحَكَمُ',
          namaLatin: 'Al-Hakam',
          arti: 'Yang Maha Menetapkan Hukum'),
      AsmaulHusna(
          id: 29,
          namaArab: 'الْعَدْلُ',
          namaLatin: 'Al-Adl',
          arti: 'Yang Maha Adil'),
      AsmaulHusna(
          id: 30,
          namaArab: 'اللَّطِيفُ',
          namaLatin: 'Al-Latif',
          arti: 'Yang Maha Lembut'),
      AsmaulHusna(
          id: 31,
          namaArab: 'الْخَبِيرُ',
          namaLatin: 'Al-Khabir',
          arti: 'Yang Maha Mengetahui Rahasia'),
      AsmaulHusna(
          id: 32,
          namaArab: 'الْحَلِيمُ',
          namaLatin: 'Al-Halim',
          arti: 'Yang Maha Penyantun'),
      AsmaulHusna(
          id: 33,
          namaArab: 'الْعَظِيمُ',
          namaLatin: 'Al-Azim',
          arti: 'Yang Maha Agung'),
      AsmaulHusna(
          id: 34,
          namaArab: 'الْغَفُورُ',
          namaLatin: 'Al-Ghafur',
          arti: 'Yang Maha Pengampun'),
      AsmaulHusna(
          id: 35,
          namaArab: 'الشَّكُورُ',
          namaLatin: 'Asy-Syakur',
          arti: 'Yang Maha Pembalas Budi'),
      AsmaulHusna(
          id: 36,
          namaArab: 'الْعَلِيُّ',
          namaLatin: 'Al-Aliyy',
          arti: 'Yang Maha Tinggi'),
      AsmaulHusna(
          id: 37,
          namaArab: 'الْكَبِيرُ',
          namaLatin: 'Al-Kabir',
          arti: 'Yang Maha Besar'),
      AsmaulHusna(
          id: 38,
          namaArab: 'الْحَفِيظُ',
          namaLatin: 'Al-Hafiz',
          arti: 'Yang Maha Memelihara'),
      AsmaulHusna(
          id: 39,
          namaArab: 'الْمُقِيتُ',
          namaLatin: 'Al-Muqit',
          arti: 'Yang Maha Pemberi Kekuatan'),
      AsmaulHusna(
          id: 40,
          namaArab: 'الْحَسِيبُ',
          namaLatin: 'Al-Hasib',
          arti: 'Yang Maha Membuat Perhitungan'),
      AsmaulHusna(
          id: 41,
          namaArab: 'الْجَلِيلُ',
          namaLatin: 'Al-Jalil',
          arti: 'Yang Maha Luhur'),
      AsmaulHusna(
          id: 42,
          namaArab: 'الْكَرِيمُ',
          namaLatin: 'Al-Karim',
          arti: 'Yang Maha Mulia'),
      AsmaulHusna(
          id: 43,
          namaArab: 'الرَّقِيبُ',
          namaLatin: 'Ar-Raqib',
          arti: 'Yang Maha Mengawasi'),
      AsmaulHusna(
          id: 44,
          namaArab: 'الْمُجِيبُ',
          namaLatin: 'Al-Mujib',
          arti: 'Yang Maha Mengabulkan'),
      AsmaulHusna(
          id: 45,
          namaArab: 'الْوَاسِعُ',
          namaLatin: 'Al-Wasi\'',
          arti: 'Yang Maha Luas'),
      AsmaulHusna(
          id: 46,
          namaArab: 'الْحَكِيمُ',
          namaLatin: 'Al-Hakim',
          arti: 'Yang Maha Bijaksana'),
      AsmaulHusna(
          id: 47,
          namaArab: 'الْوَدُودُ',
          namaLatin: 'Al-Wadud',
          arti: 'Yang Maha Mengasihi'),
      AsmaulHusna(
          id: 48,
          namaArab: 'الْمَجِيدُ',
          namaLatin: 'Al-Majid',
          arti: 'Yang Maha Mulia'),
      AsmaulHusna(
          id: 49,
          namaArab: 'الْبَاعِثُ',
          namaLatin: 'Al-Ba\'its',
          arti: 'Yang Maha Membangkitkan'),
      AsmaulHusna(
          id: 50,
          namaArab: 'الشَّهِيدُ',
          namaLatin: 'Asy-Syahid',
          arti: 'Yang Maha Menyaksikan'),
      AsmaulHusna(
          id: 51,
          namaArab: 'الْحَقُّ',
          namaLatin: 'Al-Haqq',
          arti: 'Yang Maha Benar'),
      AsmaulHusna(
          id: 52,
          namaArab: 'الْوَكِيلُ',
          namaLatin: 'Al-Wakil',
          arti: 'Yang Maha Memelihara'),
      AsmaulHusna(
          id: 53,
          namaArab: 'الْقَوِيُّ',
          namaLatin: 'Al-Qawiyy',
          arti: 'Yang Maha Kuat'),
      AsmaulHusna(
          id: 54,
          namaArab: 'الْمَتِينُ',
          namaLatin: 'Al-Matin',
          arti: 'Yang Maha Kokoh'),
      AsmaulHusna(
          id: 55,
          namaArab: 'الْوَلِيُّ',
          namaLatin: 'Al-Waliyy',
          arti: 'Yang Maha Melindungi'),
      AsmaulHusna(
          id: 56,
          namaArab: 'الْحَمِيدُ',
          namaLatin: 'Al-Hamid',
          arti: 'Yang Maha Terpuji'),
      AsmaulHusna(
          id: 57,
          namaArab: 'الْمُحْصِي',
          namaLatin: 'Al-Muhsi',
          arti: 'Yang Maha Menghitung'),
      AsmaulHusna(
          id: 58,
          namaArab: 'الْمُبْدِئُ',
          namaLatin: 'Al-Mubdi\'',
          arti: 'Yang Maha Memulai'),
      AsmaulHusna(
          id: 59,
          namaArab: 'الْمُعِيدُ',
          namaLatin: 'Al-Mu\'id',
          arti: 'Yang Maha Mengembalikan'),
      AsmaulHusna(
          id: 60,
          namaArab: 'الْمُحْيِي',
          namaLatin: 'Al-Muhyi',
          arti: 'Yang Maha Menghidupkan'),
      AsmaulHusna(
          id: 61,
          namaArab: 'الْمُمِيتُ',
          namaLatin: 'Al-Mumit',
          arti: 'Yang Maha Mematikan'),
      AsmaulHusna(
          id: 62,
          namaArab: 'الْحَيُّ',
          namaLatin: 'Al-Hayyu',
          arti: 'Yang Maha Hidup'),
      AsmaulHusna(
          id: 63,
          namaArab: 'الْقَيُّومُ',
          namaLatin: 'Al-Qayyum',
          arti: 'Yang Maha Mandiri'),
      AsmaulHusna(
          id: 64,
          namaArab: 'الْوَاجِدُ',
          namaLatin: 'Al-Wajid',
          arti: 'Yang Maha Kaya'),
      AsmaulHusna(
          id: 65,
          namaArab: 'الْمَاجِدُ',
          namaLatin: 'Al-Majid',
          arti: 'Yang Maha Mulia'),
      AsmaulHusna(
          id: 66,
          namaArab: 'الْوَاحِدُ',
          namaLatin: 'Al-Wahid',
          arti: 'Yang Maha Esa'),
      AsmaulHusna(
          id: 67,
          namaArab: 'الْأَحَدُ',
          namaLatin: 'Al-Ahad',
          arti: 'Yang Maha Tunggal'),
      AsmaulHusna(
          id: 68,
          namaArab: 'الصَّمَدُ',
          namaLatin: 'As-Samad',
          arti: 'Yang Maha Dibutuhkan'),
      AsmaulHusna(
          id: 69,
          namaArab: 'الْقَادِرُ',
          namaLatin: 'Al-Qadir',
          arti: 'Yang Maha Kuasa'),
      AsmaulHusna(
          id: 70,
          namaArab: 'الْمُقْتَدِرُ',
          namaLatin: 'Al-Muqtadir',
          arti: 'Yang Maha Berkuasa'),
      AsmaulHusna(
          id: 71,
          namaArab: 'الْمُقَدِّمُ',
          namaLatin: 'Al-Muqaddim',
          arti: 'Yang Maha Mendahulukan'),
      AsmaulHusna(
          id: 72,
          namaArab: 'الْمُؤَخِّرُ',
          namaLatin: 'Al-Mu\'akhkhir',
          arti: 'Yang Maha Mengakhirkan'),
      AsmaulHusna(
          id: 73,
          namaArab: 'الْأَوَّلُ',
          namaLatin: 'Al-Awwal',
          arti: 'Yang Maha Awal'),
      AsmaulHusna(
          id: 74,
          namaArab: 'الْآخِرُ',
          namaLatin: 'Al-Akhir',
          arti: 'Yang Maha Akhir'),
      AsmaulHusna(
          id: 75,
          namaArab: 'الظَّاهِرُ',
          namaLatin: 'Az-Zahir',
          arti: 'Yang Maha Nyata'),
      AsmaulHusna(
          id: 76,
          namaArab: 'الْبَاطِنُ',
          namaLatin: 'Al-Batin',
          arti: 'Yang Maha Tersembunyi'),
      AsmaulHusna(
          id: 77,
          namaArab: 'الْوَالِي',
          namaLatin: 'Al-Wali',
          arti: 'Yang Maha Memerintah'),
      AsmaulHusna(
          id: 78,
          namaArab: 'الْمُتَعَالِي',
          namaLatin: 'Al-Muta\'ali',
          arti: 'Yang Maha Tinggi'),
      AsmaulHusna(
          id: 79,
          namaArab: 'الْبَرُّ',
          namaLatin: 'Al-Barr',
          arti: 'Yang Maha Penderma'),
      AsmaulHusna(
          id: 80,
          namaArab: 'التَّوَّابُ',
          namaLatin: 'At-Tawwab',
          arti: 'Yang Maha Penerima Taubat'),
      AsmaulHusna(
          id: 81,
          namaArab: 'الْمُنْتَقِمُ',
          namaLatin: 'Al-Muntaqim',
          arti: 'Yang Maha Pemberi Balasan'),
      AsmaulHusna(
          id: 82,
          namaArab: 'الْعَفُوُّ',
          namaLatin: 'Al-Afuw',
          arti: 'Yang Maha Pemaaf'),
      AsmaulHusna(
          id: 83,
          namaArab: 'الرَّؤُوفُ',
          namaLatin: 'Ar-Ra\'uf',
          arti: 'Yang Maha Pengasih'),
      AsmaulHusna(
          id: 84,
          namaArab: 'مَالِكُ الْمُلْكِ',
          namaLatin: 'Malikul Mulk',
          arti: 'Yang Maha Penguasa Kerajaan'),
      AsmaulHusna(
          id: 85,
          namaArab: 'ذُو الْجَلَالِ وَالْإِكْرَامِ',
          namaLatin: 'Zul Jalali Wal Ikram',
          arti: 'Yang Maha Pemilik Kebesaran dan Kemuliaan'),
      AsmaulHusna(
          id: 86,
          namaArab: 'الْمُقْسِطُ',
          namaLatin: 'Al-Muqsit',
          arti: 'Yang Maha Adil'),
      AsmaulHusna(
          id: 87,
          namaArab: 'الْجَامِعُ',
          namaLatin: 'Al-Jami\'',
          arti: 'Yang Maha Mengumpulkan'),
      AsmaulHusna(
          id: 88,
          namaArab: 'الْغَنِيُّ',
          namaLatin: 'Al-Ghaniyy',
          arti: 'Yang Maha Kaya'),
      AsmaulHusna(
          id: 89,
          namaArab: 'الْمُغْنِي',
          namaLatin: 'Al-Mughni',
          arti: 'Yang Maha Memberi Kekayaan'),
      AsmaulHusna(
          id: 90,
          namaArab: 'الْمَانِعُ',
          namaLatin: 'Al-Mani\'',
          arti: 'Yang Maha Mencegah'),
      AsmaulHusna(
          id: 91,
          namaArab: 'الضَّارُ',
          namaLatin: 'Ad-Darr',
          arti: 'Yang Maha Memberi Derita'),
      AsmaulHusna(
          id: 92,
          namaArab: 'النَّافِعُ',
          namaLatin: 'An-Nafi\'',
          arti: 'Yang Maha Memberi Manfaat'),
      AsmaulHusna(
          id: 93,
          namaArab: 'النُّورُ',
          namaLatin: 'An-Nur',
          arti: 'Yang Maha Bercahaya'),
      AsmaulHusna(
          id: 94,
          namaArab: 'الْهَادِي',
          namaLatin: 'Al-Hadi',
          arti: 'Yang Maha Pemberi Petunjuk'),
      AsmaulHusna(
          id: 95,
          namaArab: 'الْبَدِيعُ',
          namaLatin: 'Al-Badi\'',
          arti: 'Yang Maha Pencipta'),
      AsmaulHusna(
          id: 96,
          namaArab: 'الْبَاقِي',
          namaLatin: 'Al-Baqi',
          arti: 'Yang Maha Kekal'),
      AsmaulHusna(
          id: 97,
          namaArab: 'الْوَارِثُ',
          namaLatin: 'Al-Waris',
          arti: 'Yang Maha Pewaris'),
      AsmaulHusna(
          id: 98,
          namaArab: 'الرَّشِيدُ',
          namaLatin: 'Ar-Rasyid',
          arti: 'Yang Maha Pandai'),
      AsmaulHusna(
          id: 99,
          namaArab: 'الصَّبُورُ',
          namaLatin: 'As-Sabur',
          arti: 'Yang Maha Sabar'),
    ];
  }
}
