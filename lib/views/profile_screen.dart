import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'login_screen.dart';
import 'package:animate_do/animate_do.dart';

// Shared — pindahkan ke lib/utils/colors.dart
class AppColors {
  static const emerald = Color(0xFF1A237E);
  static const emeraldMid = Color(0xFF283593);
  static const emeraldLight = Color(0xFF3F51B5);
  static const goldLight = Color(0xFFB39DDB);
  static const cream = Color(0xFFF3F3FF);
  static const cream2 = Color(0xFFE8E8F5);
  static const textPrimary = Color(0xFF0D1B46);
  static const textMuted = Color(0xFF5A5A80);
  static const white = Color(0xFFFFFFFF);
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordLamaController = TextEditingController();
  final _passwordBaruController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isEditing = false;
  bool _isChangingPassword = false;
  bool _obscureLama = true;
  bool _obscureBaru = true;
  File? _selectedImage;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authVM = context.read<AuthViewModel>();
      _namaController.text = authVM.currentUser?.nama ?? '';
      _emailController.text = authVM.currentUser?.email ?? '';
    });
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordLamaController.dispose();
    _passwordBaruController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _selectedImage = File(picked.path));
  }

  Future<void> _saveProfile() async {
    final authVM = context.read<AuthViewModel>();
    final newEmail = _emailController.text.trim();

    final success = await authVM.updateProfile(
      nama: _namaController.text.trim(),
      email: newEmail == authVM.currentUser?.email ? null : newEmail,
      passwordLama: _isChangingPassword ? _passwordLamaController.text : null,
      passwordBaru: _isChangingPassword ? _passwordBaruController.text : null,
      foto: _selectedImage,
    );

    if (success && mounted) {
      setState(() {
        _isEditing = false;
        _isChangingPassword = false;
        _passwordLamaController.clear();
        _passwordBaruController.clear();
        _confirmPasswordController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profil berhasil diupdate',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          backgroundColor: AppColors.emerald,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Consumer<AuthViewModel>(
        builder: (context, authVM, _) {
          if (authVM.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.emeraldLight),
            );
          }

          final user = authVM.currentUser;
          if (user == null) {
            return const Center(
              child: Text('User tidak ditemukan',
                  style: TextStyle(color: AppColors.textMuted)),
            );
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // ── HEADER + AVATAR (satu blok) ──
                FadeInDown(
                    duration: const Duration(milliseconds: 600),
                    child: _buildHeader(user)),

                // ── BODY ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeInUp(
                          duration: const Duration(milliseconds: 500),
                          child: _sectionLabel('Informasi Akun')),
                      const SizedBox(height: 12),
                      FadeInUp(
                          duration: const Duration(milliseconds: 600),
                          delay: const Duration(milliseconds: 100),
                          child: _buildInfoCard(user)),
                      if (_isEditing) ...[
                        const SizedBox(height: 20),
                        FadeInUp(
                            duration: const Duration(milliseconds: 700),
                            delay: const Duration(milliseconds: 200),
                            child: _sectionLabel('Keamanan')),
                        const SizedBox(height: 12),
                        FadeInUp(
                            duration: const Duration(milliseconds: 700),
                            delay: const Duration(milliseconds: 250),
                            child: _buildPasswordToggle()),
                        if (_isChangingPassword) ...[
                          const SizedBox(height: 10),
                          FadeInUp(
                              duration: const Duration(milliseconds: 800),
                              delay: const Duration(milliseconds: 300),
                              child: _buildPasswordFields()),
                        ],
                      ],
                      const SizedBox(height: 28),
                      FadeInUp(
                          duration: const Duration(milliseconds: 800),
                          delay: const Duration(milliseconds: 350),
                          child: _buildLogoutButton(authVM)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────
  //  HEADER
  // ─────────────────────────────────────────
  Widget _buildHeader(user) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.emerald, AppColors.emeraldMid, Color(0xFF1F6B45)],
          stops: [0.0, 0.6, 1.0],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -40,
            top: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.white.withOpacity(0.04), width: 50),
              ),
            ),
          ),
          Positioned(
            left: -60,
            top: 80,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.white.withOpacity(0.03), width: 30),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              child: Column(
                children: [
                  // ── TOP BAR ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: _circleButton(Icons.arrow_back_ios_new_rounded),
                      ),
                      const Text(
                        'Profil Saya',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
                      ),
                      GestureDetector(
                        onTap: _isEditing
                            ? _saveProfile
                            : () => setState(() => _isEditing = true),
                        child: _circleButton(
                          _isEditing
                              ? Icons.check_rounded
                              : Icons.edit_outlined,
                          accent: _isEditing,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // ── AVATAR ──
                  _buildAvatarSection(user),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleButton(IconData icon, {bool accent = false}) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: accent
            ? AppColors.goldLight.withOpacity(0.2)
            : Colors.white.withOpacity(0.12),
        border: Border.all(
          color: accent
              ? AppColors.goldLight.withOpacity(0.4)
              : Colors.white.withOpacity(0.2),
        ),
      ),
      child: Icon(icon,
          color: accent ? AppColors.goldLight : Colors.white, size: 17),
    );
  }

  // ─────────────────────────────────────────
  //  AVATAR SECTION
  // ─────────────────────────────────────────
  Widget _buildAvatarSection(user) {
    ImageProvider? imageProvider;
    if (_selectedImage != null) {
      imageProvider = FileImage(_selectedImage!);
    } else if (user.foto != null) {
      imageProvider = FileImage(File(user.foto!));
    }

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Avatar ring
            Container(
              width: 108,
              height: 108,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppColors.goldLight, AppColors.emeraldLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white,
                ),
                child: ClipOval(
                  child: imageProvider != null
                      ? Image(image: imageProvider, fit: BoxFit.cover)
                      : Container(
                          color: AppColors.emeraldLight.withOpacity(0.1),
                          child: const Icon(Icons.person_outline_rounded,
                              size: 48, color: AppColors.emeraldLight),
                        ),
                ),
              ),
            ),

            // Camera button
            if (_isEditing)
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.emerald,
                    ),
                    child: const Icon(Icons.camera_alt_rounded,
                        color: Colors.white, size: 15),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          user.nama,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          user.email,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 12),
        // Badge premium
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF9C7FEE), Color(0xFF7C4DFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7C4DFF).withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.workspace_premium_rounded,
                  color: Colors.white, size: 14),
              const SizedBox(width: 4),
              const Text(
                'Muslim Premium',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  //  INFO CARD
  // ─────────────────────────────────────────
  Widget _buildInfoCard(user) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        children: [
          _infoRow(
            icon: Icons.person_outline_rounded,
            label: 'Nama Lengkap',
            controller: _namaController,
            editing: _isEditing,
            value: user.nama,
          ),
          Divider(
              height: 1, thickness: 0.5, color: Colors.black.withOpacity(0.06)),
          _infoRow(
            icon: Icons.email_outlined,
            label: 'Email',
            controller: _emailController,
            editing: _isEditing,
            value: user.email,
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required bool editing,
    required String value,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.emeraldLight.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppColors.emeraldLight),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 2),
                editing
                    ? TextField(
                        controller: controller,
                        keyboardType: keyboardType,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                        decoration: const InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      )
                    : Text(
                        value,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
              ],
            ),
          ),
          if (editing)
            Icon(Icons.edit_outlined,
                size: 14, color: AppColors.textMuted.withOpacity(0.4)),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  //  PASSWORD SECTION
  // ─────────────────────────────────────────
  Widget _buildPasswordToggle() {
    return GestureDetector(
      onTap: () => setState(() => _isChangingPassword = !_isChangingPassword),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _isChangingPassword
              ? AppColors.emeraldLight.withOpacity(0.06)
              : AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _isChangingPassword
                ? AppColors.emeraldLight.withOpacity(0.2)
                : Colors.black.withOpacity(0.06),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.emeraldLight.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.lock_outline_rounded,
                  size: 18, color: AppColors.emeraldLight),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Text(
                'Ganti Password',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Icon(
              _isChangingPassword
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordFields() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: Column(
        children: [
          _passwordRow(
            label: 'Password Lama',
            controller: _passwordLamaController,
            obscure: _obscureLama,
            onToggle: () => setState(() => _obscureLama = !_obscureLama),
          ),
          Divider(
              height: 1, thickness: 0.5, color: Colors.black.withOpacity(0.06)),
          _passwordRow(
            label: 'Password Baru',
            controller: _passwordBaruController,
            obscure: _obscureBaru,
            onToggle: () => setState(() => _obscureBaru = !_obscureBaru),
          ),
        ],
      ),
    );
  }

  Widget _passwordRow({
    required String label,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.emeraldLight.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.lock_reset_rounded,
                size: 18, color: AppColors.emeraldLight),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                    )),
                const SizedBox(height: 2),
                TextField(
                  controller: controller,
                  obscureText: obscure,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    hintText: '••••••••',
                    hintStyle: TextStyle(color: AppColors.textMuted),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onToggle,
            child: Icon(
              obscure
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 18,
              color: AppColors.textMuted.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  //  LOGOUT BUTTON
  // ─────────────────────────────────────────
  Widget _buildLogoutButton(AuthViewModel authVM) {
    return GestureDetector(
      onTap: () async {
        // Konfirmasi dialog
        final confirm = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: AppColors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text('Keluar Akun',
                style: TextStyle(
                    fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            content: const Text('Apakah kamu yakin ingin keluar dari akun ini?',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Batal',
                    style: TextStyle(color: AppColors.textMuted)),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context, true),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFA32D2D),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text('Keluar',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        );

        if (confirm == true && mounted) {
          await authVM.logout();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF0F0),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout_rounded,
                size: 18, color: Color(0xFFE24B4A)),
            const SizedBox(width: 8),
            const Text(
              'Keluar Akun',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Color(0xFFE24B4A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  //  HELPERS
  // ─────────────────────────────────────────
  Widget _sectionLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
        color: AppColors.textMuted,
      ),
    );
  }
}
