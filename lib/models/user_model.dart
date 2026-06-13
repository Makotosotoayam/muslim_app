class UserModel {
  final String id;
  final String nama;
  final String email;
  final String password;
  final String? foto;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.nama,
    required this.email,
    required this.password,
    this.foto,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'password': password,
      'foto': foto,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      nama: map['nama'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      foto: map['foto'],
      createdAt:
          DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}
