import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/alquran_viewmodel.dart';
import '../models/alquran_model.dart';
import 'surat_detail_screen.dart';
import 'package:animate_do/animate_do.dart';

// Gunakan AppColors dari colors.dart (shared)
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

class AlQuranScreen extends StatefulWidget {
  const AlQuranScreen({super.key});

  @override
  State<AlQuranScreen> createState() => _AlQuranScreenState();
}

class _AlQuranScreenState extends State<AlQuranScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AlQuranViewModel>().fetchAndSaveAlQuran();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          FadeInDown(
              duration: const Duration(milliseconds: 600),
              child: _buildHeader()),
          Expanded(
            child: Consumer<AlQuranViewModel>(
              builder: (context, vm, _) {
                if (vm.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.emeraldLight),
                  );
                }

                if (vm.errorMessage.isNotEmpty) {
                  return _buildErrorState(vm);
                }

                final list = _searchQuery.isEmpty
                    ? vm.suratList
                    : vm.suratList
                        .where(
                          (s) =>
                              s.namaLatin
                                  .toLowerCase()
                                  .contains(_searchQuery.toLowerCase()) ||
                              s.arti
                                  .toLowerCase()
                                  .contains(_searchQuery.toLowerCase()),
                        )
                        .toList();

                if (list.isEmpty) {
                  return _buildEmptySearch();
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                  physics: const BouncingScrollPhysics(),
                  itemCount: list.length,
                  itemBuilder: (context, i) => FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    delay: Duration(milliseconds: (i < 15 ? i : 15) * 50),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _SuratCard(
                        surat: list[i],
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SuratDetailScreen(surat: list[i]),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
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
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── TOP BAR ──
                  Row(
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
                            border: Border.all(
                                color: Colors.white.withOpacity(0.2)),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new_rounded,
                              color: Colors.white, size: 16),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Title
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Al-Qur\'an',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.3,
                              ),
                            ),
                            Text(
                              '114 Surat · 6.236 Ayat',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Refresh button
                      GestureDetector(
                        onTap: () =>
                            context.read<AlQuranViewModel>().refreshData(),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.12),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.2)),
                          ),
                          child: Icon(Icons.refresh_rounded,
                              color: Colors.white.withOpacity(0.8), size: 18),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // ── SEARCH BAR ──
                  Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white.withOpacity(0.18)),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        Icon(Icons.search_rounded,
                            color: Colors.white.withOpacity(0.5), size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (v) => setState(() => _searchQuery = v),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Cari surat atau arti...',
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.4),
                                fontSize: 13,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                        if (_searchQuery.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Icon(Icons.close_rounded,
                                  color: Colors.white.withOpacity(0.5),
                                  size: 16),
                            ),
                          ),
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

  // ─────────────────────────────────────────
  //  STATES
  // ─────────────────────────────────────────
  Widget _buildErrorState(AlQuranViewModel vm) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off_rounded,
              size: 48, color: AppColors.textMuted.withOpacity(0.4)),
          const SizedBox(height: 12),
          Text(vm.errorMessage,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
              textAlign: TextAlign.center),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: vm.fetchAndSaveAlQuran,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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

  Widget _buildEmptySearch() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded,
              size: 48, color: AppColors.textMuted.withOpacity(0.4)),
          const SizedBox(height: 12),
          Text(
            'Tidak ada hasil untuk "$_searchQuery"',
            style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
//  SURAT CARD WIDGET
// ─────────────────────────────────────────
class _SuratCard extends StatelessWidget {
  final Surat surat;
  final VoidCallback onTap;

  const _SuratCard({required this.surat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withOpacity(0.06)),
        ),
        child: Row(
          children: [
            // Nomor surat
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.emeraldLight.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '${surat.nomor}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.emeraldLight,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Nama latin + arti + meta
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    surat.namaLatin,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    surat.arti,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _MetaPill(label: '${surat.jumlahAyat} Ayat'),
                      const SizedBox(width: 6),
                      _MetaPill(label: surat.tempatTurun),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),

            // Arab + arrow
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  surat.nama,
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'serif',
                    fontWeight: FontWeight.w700,
                    color: AppColors.emerald,
                  ),
                ),
                const SizedBox(height: 4),
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 12, color: AppColors.textMuted.withOpacity(0.5)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  final String label;
  const _MetaPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.emeraldLight.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
          color: AppColors.emeraldLight,
        ),
      ),
    );
  }
}
