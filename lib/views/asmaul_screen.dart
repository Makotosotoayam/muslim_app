import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/asmaul_viewmodel.dart';
import '../models/asmaul_model.dart';
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

// Warna nomor berputar biar tidak monoton
const _numColors = [
  Color(0xFF3F51B5),
  Color(0xFFBA7517),
  Color(0xFF533AAB),
  Color(0xFF185FA5),
  Color(0xFF8B3A3A),
  Color(0xFF1A7A6E),
];
const _numBgColors = [
  Color(0xFFEAF5EE),
  Color(0xFFFAEEDA),
  Color(0xFFEEEDFE),
  Color(0xFFE6F1FB),
  Color(0xFFFCEBEB),
  Color(0xFFE1F5EE),
];

class AsmaulScreen extends StatefulWidget {
  const AsmaulScreen({super.key});

  @override
  State<AsmaulScreen> createState() => _AsmaulScreenState();
}

class _AsmaulScreenState extends State<AsmaulScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AsmaulViewModel>().fetchAndSaveAsmaul();
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
            child: Consumer<AsmaulViewModel>(
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

                final list = vm.filteredAsmaul;

                if (list.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded,
                            size: 48,
                            color: AppColors.textMuted.withOpacity(0.4)),
                        const SizedBox(height: 12),
                        const Text('Tidak ada hasil',
                            style: TextStyle(
                                color: AppColors.textMuted, fontSize: 13)),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                  physics: const BouncingScrollPhysics(),
                  itemCount: list.length,
                  itemBuilder: (_, i) => FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    delay: Duration(milliseconds: (i < 15 ? i : 15) * 50),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _AsmaulCard(
                        item: list[i],
                        colorIndex: (list[i].id - 1) % _numColors.length,
                        onTap: () => _showDetailSheet(context, list[i]),
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
                              'Asmaul Husna',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.3,
                              ),
                            ),
                            Text(
                              '99 Nama Allah Yang Indah',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            context.read<AsmaulViewModel>().refreshData(),
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
                            onChanged: (v) => context
                                .read<AsmaulViewModel>()
                                .setSearchQuery(v),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                            decoration: InputDecoration(
                              hintText: 'Cari nama Allah...',
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.4),
                                fontSize: 13,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                        if (_searchController.text.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              context
                                  .read<AsmaulViewModel>()
                                  .setSearchQuery('');
                              setState(() {});
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
  //  ERROR STATE
  // ─────────────────────────────────────────
  Widget _buildErrorState(AsmaulViewModel vm) {
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
            onTap: vm.fetchAndSaveAsmaul,
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

  // ─────────────────────────────────────────
  //  DETAIL BOTTOM SHEET
  // ─────────────────────────────────────────
  void _showDetailSheet(BuildContext context, AsmaulHusna item) {
    final ci = (item.id - 1) % _numColors.length;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 28),

            // Nomor
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _numBgColors[ci],
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  '${item.id}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: _numColors[ci],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Nama Arab
            Text(
              item.namaArab,
              style: const TextStyle(
                fontSize: 48,
                fontFamily: 'serif',
                fontWeight: FontWeight.w700,
                color: AppColors.emerald,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Nama Latin
            Text(
              item.namaLatin,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 16),

            // Divider
            Divider(height: 1, color: Colors.black.withOpacity(0.07)),
            const SizedBox(height: 16),

            // Arti
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.black.withOpacity(0.05)),
              ),
              child: Text(
                item.arti,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  height: 1.6,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tutup button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.cream2,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.black.withOpacity(0.06)),
                ),
                child: const Text(
                  'Tutup',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  ASMAUL CARD WIDGET
// ─────────────────────────────────────────
class _AsmaulCard extends StatelessWidget {
  final AsmaulHusna item;
  final int colorIndex;
  final VoidCallback onTap;

  const _AsmaulCard({
    required this.item,
    required this.colorIndex,
    required this.onTap,
  });

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
            // Nomor
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _numBgColors[colorIndex],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '${item.id}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: _numColors[colorIndex],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Nama latin + arti
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.namaLatin,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.arti,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColors.textMuted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Nama Arab
            Text(
              item.namaArab,
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'serif',
                fontWeight: FontWeight.w700,
                color: _numColors[colorIndex],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
