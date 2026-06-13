import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'login_screen.dart';
import 'package:animate_do/animate_do.dart';

// Import shared widgets dari login_screen.dart atau pindah ke shared_widgets.dart
// Untuk sekarang didefinisikan ulang di sini

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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Consumer<AuthViewModel>(
        builder: (context, vm, _) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // ── HEADER ──
                FadeInDown(
                    duration: const Duration(milliseconds: 800),
                    child: _buildHeader(context)),

                // ── FORM ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeInUp(
                        duration: const Duration(milliseconds: 500),
                        delay: const Duration(milliseconds: 100),
                        child: _sectionLabel('Nama Lengkap'),
                      ),
                      const SizedBox(height: 8),
                      FadeInUp(
                        duration: const Duration(milliseconds: 500),
                        delay: const Duration(milliseconds: 150),
                        child: _buildInputField(
                          controller: _namaController,
                          hint: 'Masukkan nama lengkap',
                          icon: Icons.person_outline_rounded,
                        ),
                      ),
                      const SizedBox(height: 20),

                      FadeInUp(
                        duration: const Duration(milliseconds: 500),
                        delay: const Duration(milliseconds: 200),
                        child: _sectionLabel('Email'),
                      ),
                      const SizedBox(height: 8),
                      FadeInUp(
                        duration: const Duration(milliseconds: 500),
                        delay: const Duration(milliseconds: 250),
                        child: _buildInputField(
                          controller: _emailController,
                          hint: 'Masukkan email',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      const SizedBox(height: 20),

                      FadeInUp(
                        duration: const Duration(milliseconds: 500),
                        delay: const Duration(milliseconds: 300),
                        child: _sectionLabel('Password'),
                      ),
                      const SizedBox(height: 8),
                      FadeInUp(
                        duration: const Duration(milliseconds: 500),
                        delay: const Duration(milliseconds: 350),
                        child: _buildInputField(
                          controller: _passwordController,
                          hint: 'Minimal 6 karakter',
                          icon: Icons.lock_outline_rounded,
                          obscure: _obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textMuted,
                              size: 20,
                            ),
                            onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      FadeInUp(
                        duration: const Duration(milliseconds: 500),
                        delay: const Duration(milliseconds: 400),
                        child: _sectionLabel('Konfirmasi Password'),
                      ),
                      const SizedBox(height: 8),
                      FadeInUp(
                        duration: const Duration(milliseconds: 500),
                        delay: const Duration(milliseconds: 450),
                        child: _buildInputField(
                          controller: _confirmPasswordController,
                          hint: 'Ulangi password',
                          icon: Icons.lock_outline_rounded,
                          obscure: _obscureConfirmPassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textMuted,
                              size: 20,
                            ),
                            onPressed: () => setState(() =>
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword),
                          ),
                        ),
                      ),

                      // Error message
                      if (vm.errorMessage.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        FadeIn(
                            duration: const Duration(milliseconds: 300),
                            child: _buildErrorBanner(vm.errorMessage)),
                      ],

                      const SizedBox(height: 32),

                      // Register button
                      FadeInUp(
                        duration: const Duration(milliseconds: 500),
                        delay: const Duration(milliseconds: 500),
                        child: _buildPrimaryButton(
                          label: 'Daftar',
                          isLoading: vm.isLoading,
                          onTap: () async {
                            final ok = await vm.register(
                              _namaController.text.trim(),
                              _emailController.text.trim(),
                              _passwordController.text,
                              _confirmPasswordController.text,
                            );
                            if (ok && mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Registrasi berhasil! Silakan login.',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  backgroundColor: AppColors.emerald,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  margin: const EdgeInsets.all(16),
                                ),
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen()),
                              );
                            }
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Login link
                      FadeInUp(
                        duration: const Duration(milliseconds: 500),
                        delay: const Duration(milliseconds: 600),
                        child: _buildFooterLink(
                          prefix: 'Sudah punya akun? ',
                          action: 'Masuk Sekarang',
                          onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()),
                          ),
                        ),
                      ),
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
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
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
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.white.withOpacity(0.04), width: 55),
              ),
            ),
          ),
          Positioned(
            left: -30,
            bottom: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.white.withOpacity(0.03), width: 40),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 20, 28, 44),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.12),
                        border:
                            Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 16),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Logo
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.2), width: 1.5),
                    ),
                    child: const Icon(Icons.person_add_outlined,
                        color: Colors.white, size: 26),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Buat Akun',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Isi data berikut untuk mendaftar',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.55),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
//  SHARED FORM WIDGETS
// ─────────────────────────────────────────

Widget _sectionLabel(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w800,
      color: AppColors.textPrimary,
    ),
  );
}

Widget _buildInputField({
  required TextEditingController controller,
  required String hint,
  required IconData icon,
  bool obscure = false,
  Widget? suffixIcon,
  TextInputType keyboardType = TextInputType.text,
}) {
  return Container(
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 10,
          offset: const Offset(0, 4),
        )
      ],
      border: Border.all(color: Colors.black.withOpacity(0.04)),
    ),
    child: TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(
        fontSize: 14,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: AppColors.textMuted,
          fontSize: 13,
        ),
        prefixIcon: Icon(icon, color: AppColors.textMuted, size: 20),
        suffixIcon: suffixIcon,
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
      ),
    ),
  );
}

Widget _buildErrorBanner(String message) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(
      color: const Color(0xFFFCEBEB),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFF09595)),
    ),
    child: Row(
      children: [
        const Icon(Icons.error_outline_rounded,
            size: 16, color: Color(0xFFA32D2D)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(
              color: Color(0xFFA32D2D),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildPrimaryButton({
  required String label,
  required bool isLoading,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: isLoading ? null : onTap,
    child: Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isLoading
              ? [AppColors.emeraldLight.withOpacity(0.6), AppColors.emeraldLight.withOpacity(0.6)]
              : [AppColors.emeraldLight, AppColors.emerald],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: isLoading ? null : [
          BoxShadow(
            color: AppColors.emeraldLight.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Center(
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
            : Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2,
                ),
              ),
      ),
    ),
  );
}

Widget _buildFooterLink({
  required String prefix,
  required String action,
  required VoidCallback onTap,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(prefix,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
      GestureDetector(
        onTap: onTap,
        child: Text(
          action,
          style: const TextStyle(
            color: AppColors.emeraldLight,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    ],
  );
}
