import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/doa_model.dart';

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

class DoaDetailScreen extends StatelessWidget {
  final Doa doa;

  const DoaDetailScreen({super.key, required this.doa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── HEADER ──
          SliverToBoxAdapter(child: _buildHeader(context)),

          // ── CONTENT ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 48),
              child: Column(
                children: [
                  // Arab
                  _buildArabCard(),
                  const SizedBox(height: 14),

                  // Latin
                  _buildContentCard(
                    icon: Icons.text_fields_rounded,
                    label: 'Latin',
                    content: doa.latin.isNotEmpty
                        ? doa.latin
                        : 'Latin tidak tersedia',
                    isItalic: true,
                    fontSize: 15,
                  ),
                  const SizedBox(height: 14),

                  // Arti
                  _buildContentCard(
                    icon: Icons.translate_rounded,
                    label: 'Artinya',
                    content: doa.artinya.isNotEmpty
                        ? doa.artinya
                        : 'Artinya tidak tersedia',
                    fontSize: 14,
                  ),
                  const SizedBox(height: 24),

                  // Copy button
                  _buildCopyButton(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  //  HEADER
  // ─────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.emerald, AppColors.emeraldMid, Color(0xFF1F6B45)],
          stops: [0.0, 0.6, 1.0],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Stack(
        children: [
          // Deco circle
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
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
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
                  const SizedBox(height: 20),

                  // Tag
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Doa Harian',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.goldLight.withOpacity(0.9),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Judul
                  Text(
                    doa.judul,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                      height: 1.2,
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

  // ─────────────────────────────────────────
  //  ARAB CARD
  // ─────────────────────────────────────────
  Widget _buildArabCard() {
    final hasArab = doa.arab.isNotEmpty;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.emerald,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            'ARAB',
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: Colors.white.withOpacity(0.45),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            hasArab ? doa.arab : 'Teks Arab tidak tersedia',
            style: TextStyle(
              fontSize: hasArab ? 28 : 14,
              fontFamily: hasArab ? 'serif' : null,
              fontWeight: FontWeight.w700,
              height: 2.0,
              color: hasArab ? Colors.white : Colors.white54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  //  CONTENT CARD (Latin / Arti)
  // ─────────────────────────────────────────
  Widget _buildContentCard({
    required IconData icon,
    required String label,
    required String content,
    double fontSize = 14,
    bool isItalic = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label row
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.emeraldLight.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 14, color: AppColors.emeraldLight),
              ),
              const SizedBox(width: 8),
              Text(
                label.toUpperCase(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  color: AppColors.emeraldLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, thickness: 0.5),
          const SizedBox(height: 14),

          // Content
          Text(
            content,
            style: TextStyle(
              fontSize: fontSize,
              fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
              height: 1.7,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  //  COPY BUTTON
  // ─────────────────────────────────────────
  Widget _buildCopyButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final text = '${doa.judul}\n\n'
            '${doa.arab}\n\n'
            '${doa.latin}\n\n'
            'Artinya: ${doa.artinya}';
        Clipboard.setData(ClipboardData(text: text));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Doa berhasil disalin',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
            backgroundColor: AppColors.emerald,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.cream2,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black.withOpacity(0.06)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.copy_rounded, size: 16, color: AppColors.textMuted),
            const SizedBox(width: 8),
            Text(
              'Salin Doa',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
