import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/doa_viewmodel.dart';
import '../models/doa_model.dart';
import 'doa_detail_screen.dart';
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

class DoaScreen extends StatefulWidget {
  const DoaScreen({super.key});

  @override
  State<DoaScreen> createState() => _DoaScreenState();
}

class _DoaScreenState extends State<DoaScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DoaViewModel>().fetchAndSaveDoa();
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
            child: Consumer<DoaViewModel>(
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
                    ? vm.doaList
                    : vm.doaList
                        .where(
                          (d) =>
                              d.judul
                                  .toLowerCase()
                                  .contains(_searchQuery.toLowerCase()) ||
                              d.artinya
                                  .toLowerCase()
                                  .contains(_searchQuery.toLowerCase()),
                        )
                        .toList();

                if (list.isEmpty) return _buildEmptySearch();

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                  physics: const BouncingScrollPhysics(),
                  itemCount: list.length,
                  itemBuilder: (_, i) => FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    delay: Duration(milliseconds: (i < 15 ? i : 15) * 50),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _DoaCard(
                        doa: list[i],
                        index: i,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DoaDetailScreen(doa: list[i]),
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── TOP BAR ──
                  Row(
                    children: [
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Doa Harian',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.3,
                              ),
                            ),
                            Text(
                              'Kumpulan doa sehari-hari',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.read<DoaViewModel>().refreshData(),
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
                                color: Colors.white, fontSize: 14),
                            decoration: InputDecoration(
                              hintText: 'Cari doa...',
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
  Widget _buildErrorState(DoaViewModel vm) {
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
            onTap: vm.fetchAndSaveDoa,
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
//  DOA CARD WIDGET
// ─────────────────────────────────────────
class _DoaCard extends StatelessWidget {
  final Doa doa;
  final int index;
  final VoidCallback onTap;

  const _DoaCard({
    required this.doa,
    required this.index,
    required this.onTap,
  });

  // Warna icon berputar supaya tidak monoton
  static const _iconColors = [
    Color(0xFF3F51B5), // blue
    Color(0xFFBA7517), // amber
    Color(0xFF533AAB), // purple
    Color(0xFF185FA5), // blue
    Color(0xFF8B3A3A), // rose
    Color(0xFF1A7A6E), // teal
  ];

  static const _iconBgColors = [
    Color(0xFFEAF5EE),
    Color(0xFFFAEEDA),
    Color(0xFFEEEDFE),
    Color(0xFFE6F1FB),
    Color(0xFFFCEBEB),
    Color(0xFFE1F5EE),
  ];

  static const _icons = [
    Icons.volunteer_activism_outlined,
    Icons.self_improvement_outlined,
    Icons.nights_stay_outlined,
    Icons.wb_sunny_outlined,
    Icons.favorite_border_rounded,
    Icons.spa_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    final ci = index % _iconColors.length;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withOpacity(0.06)),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _iconBgColors[ci],
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(_icons[ci], color: _iconColors[ci], size: 20),
            ),
            const SizedBox(width: 14),

            // Judul + preview arti
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doa.judul,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    doa.artinya.length > 55
                        ? '${doa.artinya.substring(0, 55)}...'
                        : doa.artinya,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColors.textMuted,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            Icon(Icons.arrow_forward_ios_rounded,
                size: 13, color: AppColors.textMuted.withOpacity(0.4)),
          ],
        ),
      ),
    );
  }
}
