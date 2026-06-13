class Doa {
  final String id;
  final String judul;
  final String arab;
  final String latin;
  final String artinya;

  Doa({
    required this.id,
    required this.judul,
    required this.arab,
    required this.latin,
    required this.artinya,
  });

  factory Doa.fromJson(Map<String, dynamic> json) {
    // Debug print untuk melihat struktur JSON
    print('📦 Parsing doa: ${json.keys}');

    return Doa(
      id: json['id']?.toString() ?? '',
      judul: json['doa']?.toString() ?? 'Doa ${json['id']}',
      arab: json['ayat']?.toString() ??
          '', // ← Perhatikan: field 'ayat' untuk Arab
      latin: json['latin']?.toString() ?? '',
      artinya: json['artinya']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'arab': arab,
      'latin': latin,
      'artinya': artinya,
    };
  }
}
