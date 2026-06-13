import 'package:flutter/material.dart';
import 'dart:io';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class AuthViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  UserModel? _currentUser;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  // ========== REGISTER ==========
  Future<bool> register(String nama, String email, String password,
      String confirmPassword) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    // Validasi
    if (nama.isEmpty) {
      _errorMessage = 'Nama tidak boleh kosong';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (email.isEmpty) {
      _errorMessage = 'Email tidak boleh kosong';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (!email.contains('@') || !email.contains('.')) {
      _errorMessage = 'Email tidak valid';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (password.length < 6) {
      _errorMessage = 'Password minimal 6 karakter';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (password != confirmPassword) {
      _errorMessage = 'Password tidak cocok';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    final success = await AuthService.register(nama, email, password);

    if (!success) {
      _errorMessage = 'Email sudah terdaftar';
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }

  // ========== LOGIN ==========
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    if (email.isEmpty) {
      _errorMessage = 'Email tidak boleh kosong';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (password.isEmpty) {
      _errorMessage = 'Password tidak boleh kosong';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    try {
      final user = await AuthService.login(email, password);
      if (user != null) {
        _currentUser = user;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Email atau password salah';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Email atau password salah';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // ========== LOGOUT ==========
  Future<void> logout() async {
    await AuthService.logout();
    _currentUser = null;
    notifyListeners();
  }

  // ========== LOAD CURRENT USER ==========
  Future<void> loadCurrentUser() async {
    _currentUser = await AuthService.getCurrentUser();
    notifyListeners();
  }

  // ========== UPDATE PROFILE ==========
  Future<bool> updateProfile({
    required String nama,
    String? email,
    String? passwordLama,
    String? passwordBaru,
    File? foto,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    // Validasi Nama
    if (nama.isEmpty) {
      _errorMessage = 'Nama tidak boleh kosong';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    // Validasi Email
    if (email != null && email.isNotEmpty) {
      if (!email.contains('@') || !email.contains('.')) {
        _errorMessage = 'Email tidak valid';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    }

    // Validasi Password
    if (passwordLama != null && passwordBaru != null) {
      if (passwordLama != _currentUser?.password) {
        _errorMessage = 'Password lama salah';
        _isLoading = false;
        notifyListeners();
        return false;
      }
      if (passwordBaru.length < 6) {
        _errorMessage = 'Password baru minimal 6 karakter';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    }

    final success = await AuthService.updateProfile(
      nama: nama,
      email: email,
      passwordBaru: passwordBaru,
      foto: foto,
    );

    if (success) {
      await loadCurrentUser();
    } else {
      _errorMessage = 'Gagal update profil';
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }
}
