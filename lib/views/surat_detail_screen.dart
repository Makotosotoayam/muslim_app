import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/alquran_model.dart';
import '../viewmodels/alquran_viewmodel.dart';

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

class SuratDetailScreen extends StatefulWidget {
  final Surat surat;
  const SuratDetailScreen({super.key, required this.surat});

  @override
  State<SuratDetailScreen> createState() => _SuratDetailScreenState();
}

class _SuratDetailScreenState extends State<SuratDetailScreen> {
  SuratDetail? _suratDetail;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadSuratDetail();
  }

  Future<void> _loadSuratDetail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final detail = await context
          .read<AlQuranViewModel>()
          .fetchSuratDetail(widget.surat.nomor);
      setState(() {
        _suratDetail = detail;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat ayat: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  //  HEADER
  // ─────────────────────────────────────────
  Widget _buildHeader() {
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
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
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
                  const SizedBox(height: 16),

                  // Nomor + nama latin
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Tag
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Surah ke-${widget.surat.nomor} · ${widget.surat.tempatTurun}',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.goldLight.withOpacity(0.9),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.surat.namaLatin,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.3,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.surat.arti,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.55),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Nama Arab
                      Text(
                        widget.surat.nama,
                        style: const TextStyle(
                          fontSize: 26,
                          fontFamily: 'serif',
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Info strip
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.15)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _headerStat(Icons.format_list_numbered_rounded,
                            '${widget.surat.jumlahAyat} Ayat'),
                        _divider(),
                        _headerStat(Icons.location_on_outlined,
                            widget.surat.tempatTurun),
                        _divider(),
                        _headerStat(Icons.tag_rounded,
                            'Juz ${_getJuz(widget.surat.nomor)}'),
                      ],
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

  Widget _headerStat(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 12, color: Colors.white.withOpacity(0.55)),
        const SizedBox(width: 5),
        Text(label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            )),
      ],
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 14,
      color: Colors.white.withOpacity(0.2),
    );
  }

  // ─────────────────────────────────────────
  //  BODY
  // ─────────────────────────────────────────
  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.emeraldLight),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded,
                size: 48, color: AppColors.textMuted.withOpacity(0.4)),
            const SizedBox(height: 12),
            Text(_errorMessage,
                style:
                    const TextStyle(color: AppColors.textMuted, fontSize: 13),
                textAlign: TextAlign.center),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _loadSuratDetail,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.emerald,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('Coba Lagi',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    )),
              ),
            ),
          ],
        ),
      );
    }

    if (_suratDetail == null) {
      return const Center(
        child: Text('Data tidak ditemukan',
            style: TextStyle(color: AppColors.textMuted)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      physics: const BouncingScrollPhysics(),
      itemCount: _suratDetail!.ayat.length,
      itemBuilder: (_, i) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: _AyatCard(
          ayat: _suratDetail!.ayat[i],
          suratName: widget.surat.namaLatin,
        ),
      ),
    );
  }

  // Estimasi juz sederhana
  String _getJuz(int nomor) {
    if (nomor <= 2) return '1-2';
    if (nomor <= 9) return '3-10';
    if (nomor <= 23) return '11-18';
    return '19-30';
  }
}

// ─────────────────────────────────────────
//  AYAT CARD WIDGET
// ─────────────────────────────────────────
class _AyatCard extends StatelessWidget {
  final dynamic ayat;
  final String suratName;

  const _AyatCard({required this.ayat, required this.suratName});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── AYAT HEADER ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.emeraldLight.withOpacity(0.06),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18)),
              border: Border(
                bottom: BorderSide(
                    color: Colors.black.withOpacity(0.05), width: 0.5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Nomor ayat pill
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.emerald,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Ayat ${ayat.nomorAyat}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                // Copy button
                GestureDetector(
                  onTap: () {
                    final text = '$suratName : ${ayat.nomorAyat}\n\n'
                        '${ayat.teksArab}\n\n'
                        '${ayat.teksLatin}\n\n'
                        'Artinya: ${ayat.teksIndonesia}';
                    Clipboard.setData(ClipboardData(text: text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Ayat berhasil disalin',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                        backgroundColor: AppColors.emerald,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        margin: const EdgeInsets.all(16),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Icon(Icons.copy_outlined,
                      size: 16, color: AppColors.textMuted.withOpacity(0.5)),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── ARAB ──
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  decoration: BoxDecoration(
                    color: AppColors.emerald,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    ayat.teksArab,
                    style: const TextStyle(
                      fontSize: 24,
                      fontFamily: 'serif',
                      fontWeight: FontWeight.w700,
                      height: 2.0,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                const SizedBox(height: 12),

                // ── LATIN ──
                _ContentSection(
                  icon: Icons.text_fields_rounded,
                  label: 'Latin',
                  child: Text(
                    ayat.teksLatin,
                    style: const TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      height: 1.6,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // ── ARTI ──
                _ContentSection(
                  icon: Icons.translate_rounded,
                  label: 'Artinya',
                  child: Text(
                    ayat.teksIndonesia,
                    style: const TextStyle(
                      fontSize: 13.5,
                      height: 1.6,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
//  CONTENT SECTION (Latin / Arti)
// ─────────────────────────────────────────
class _ContentSection extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget child;

  const _ContentSection({
    required this.icon,
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.emeraldLight.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, size: 13, color: AppColors.emeraldLight),
              ),
              const SizedBox(width: 7),
              Text(
                label.toUpperCase(),
                style: const TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: AppColors.emeraldLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
