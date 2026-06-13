import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  static const String _usersKey = 'registered_users';
  static const String _currentUserKey = 'current_user';

  // ========== REGISTER ==========
  static Future<bool> register(
      String nama, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();

    List<String>? usersJson = prefs.getStringList(_usersKey);
    List<UserModel> users = [];

    if (usersJson != null) {
      users =
          usersJson.map((json) => UserModel.fromMap(jsonDecode(json))).toList();
    }

    // Cek email sudah terdaftar
    if (users.any((user) => user.email == email)) {
      return false;
    }

    final newUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nama: nama,
      email: email,
      password: password,
      createdAt: DateTime.now(),
    );

    users.add(newUser);

    final updatedUsersJson =
        users.map((user) => jsonEncode(user.toMap())).toList();
    await prefs.setStringList(_usersKey, updatedUsersJson);

    return true;
  }

  // ========== LOGIN ==========
  static Future<UserModel?> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();

    List<String>? usersJson = prefs.getStringList(_usersKey);
    if (usersJson == null) return null;

    List<UserModel> users =
        usersJson.map((json) => UserModel.fromMap(jsonDecode(json))).toList();

    final user = users.firstWhere(
      (user) => user.email == email && user.password == password,
      orElse: () => throw Exception('Email atau password salah'),
    );

    await prefs.setString(_currentUserKey, jsonEncode(user.toMap()));

    return user;
  }

  // ========== LOGOUT ==========
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  // ========== GET CURRENT USER ==========
  static Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userJson = prefs.getString(_currentUserKey);
    if (userJson == null) return null;
    return UserModel.fromMap(jsonDecode(userJson));
  }

  // ========== UPDATE PROFILE ==========
  static Future<bool> updateProfile({
    required String nama,
    String? email,
    String? passwordBaru,
    File? foto,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final currentUser = await getCurrentUser();
    if (currentUser == null) return false;

    final updatedUser = UserModel(
      id: currentUser.id,
      nama: nama,
      email: email ?? currentUser.email,
      password: passwordBaru ?? currentUser.password,
      foto: foto != null ? foto.path : currentUser.foto,
      createdAt: currentUser.createdAt,
    );

    // Update di list users
    List<String>? usersJson = prefs.getStringList(_usersKey);
    if (usersJson != null) {
      List<UserModel> users =
          usersJson.map((json) => UserModel.fromMap(jsonDecode(json))).toList();

      final index = users.indexWhere((user) => user.id == currentUser.id);
      if (index != -1) {
        users[index] = updatedUser;
      }

      final updatedUsersJson =
          users.map((user) => jsonEncode(user.toMap())).toList();
      await prefs.setStringList(_usersKey, updatedUsersJson);
    }

    // Update current user
    await prefs.setString(_currentUserKey, jsonEncode(updatedUser.toMap()));

    return true;
  }

  // ========== DEBUG: VIEW ALL ACCOUNTS ==========
  static Future<List<UserModel>> getAllRegisteredUsers() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? usersJson = prefs.getStringList(_usersKey);
    
    if (usersJson == null) {
      print('📭 Tidak ada akun terdaftar');
      return [];
    }

    List<UserModel> users =
        usersJson.map((json) => UserModel.fromMap(jsonDecode(json))).toList();
    
    print('📋 DAFTAR AKUN TERDAFTAR (${users.length}):');
    for (var user in users) {
      print('  • Email: ${user.email}, Password: ${user.password}, Nama: ${user.nama}');
    }
    
    return users;
  }
}
