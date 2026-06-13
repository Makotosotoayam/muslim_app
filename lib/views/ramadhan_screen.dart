import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/ramadhan_viewmodel.dart';
import 'package:animate_do/animate_do.dart';

// Reuse AppColors from home_screen.dart
class AppColors {
  static const emerald = Color(0xFF1A237E);
  static const emeraldMid = Color(0xFF283593);
  static const emeraldLight = Color(0xFF3F51B5);
  static const gold = Color(0xFF7C4DFF);
  static const goldLight = Color(0xFFB39DDB);
  static const cream = Color(0xFFF3F3FF);
  static const cream2 = Color(0xFFE8E8F5);
  static const textPrimary = Color(0xFF0D1B46);
  static const textMuted = Color(0xFF5A5A80);
  static const white = Color(0xFFFFFFFF);
  static const doaIcon = Color(0xFF6F42C1);
  static const asmaulIcon = Color(0xFF9C27B0);
}

class RamadhanScreen extends StatefulWidget {
  const RamadhanScreen({super.key});

  @override
  State<RamadhanScreen> createState() => _RamadhanScreenState();
}

class _RamadhanScreenState extends State<RamadhanScreen> {
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RamadhanViewModel>().loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      extendBody: true,
      body: Consumer<RamadhanViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.emeraldLight),
                  SizedBox(height: 16),
                  Text('Memuat data Ramadhan...',
                      style: TextStyle(color: AppColors.textMuted)),
                ],
              ),
            );
          }

          return Column(
            children: [
              FadeInDown(
                  duration: const Duration(milliseconds: 600),
                  child: _buildHeader(viewModel)),
              const SizedBox(height: 16),
              _buildTabSelector(),
              const SizedBox(height: 8),
              Expanded(
                child: FadeInUp(
                  key: ValueKey<int>(_selectedTab),
                  duration: const Duration(milliseconds: 400),
                  child: IndexedStack(
                    index: _selectedTab,
                    children: [
                      _buildShalatTab(viewModel),
                      _buildInfaqTab(viewModel),
                      _buildCeramahTab(viewModel),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────
  //  HEADER  (same style as HomeScreen)
  // ─────────────────────────────────────────
  Widget _buildHeader(RamadhanViewModel viewModel) {
    final ramadhanDay = _getRamadhanDay(DateTime.now());

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
          // Decorative circle (same as HomeScreen)
          Positioned(
            right: -40,
            top: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.04),
                  width: 50,
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── TOP ROW: back + title + refresh ──
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.2)),
                          ),
                          child: const Icon(Icons.arrow_back,
                              color: Colors.white, size: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ramadhan Tracker',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Hari ke-$ramadhanDay · 1446 H',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.55),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => viewModel.loadData(),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.2)),
                          ),
                          child: const Icon(Icons.refresh,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ── STATS STRIP  (matches countdown strip style) ──
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.18)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildHeaderStat(
                          '${viewModel.totalShalatTerisi}/5',
                          'Shalat',
                          Icons.mosque_outlined,
                        ),
                        Container(
                            width: 1,
                            height: 40,
                            color: Colors.white.withOpacity(0.2)),
                        _buildHeaderStat(
                          'Rp ${_formatNumber(viewModel.totalInfaqHariIni)}',
                          'Infaq Hari Ini',
                          Icons.payments_outlined,
                        ),
                        Container(
                            width: 1,
                            height: 40,
                            color: Colors.white.withOpacity(0.2)),
                        _buildHeaderStat(
                          '${viewModel.ceramahList.length}',
                          'Catatan',
                          Icons.description_outlined,
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

  Widget _buildHeaderStat(String value, String label, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.8), size: 18),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 15)),
        const SizedBox(height: 2),
        Text(label,
            style:
                TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 10)),
      ],
    );
  }

  // ─────────────────────────────────────────
  //  TAB SELECTOR  (same pattern as HomeScreen menu cards)
  // ─────────────────────────────────────────
  Widget _buildTabSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          _buildTabItem(0, 'Shalat', Icons.mosque_outlined),
          _buildTabItem(1, 'Infaq', Icons.payments_outlined),
          _buildTabItem(2, 'Ceramah', Icons.description_outlined),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String label, IconData icon) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.emeraldMid : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 17,
                  color: isSelected ? Colors.white : AppColors.textMuted),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: isSelected ? Colors.white : AppColors.textMuted,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  //  SHALAT TAB
  // ─────────────────────────────────────────
  Widget _buildShalatTab(RamadhanViewModel viewModel) {
    final shalat = viewModel.shalatHariIni;
    if (shalat == null) return const SizedBox();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('Progress Ibadah'),
          const SizedBox(height: 12),
          // Progress card — same as _StatCard in HomeScreen
          Container(
            padding: const EdgeInsets.all(16),
            decoration: _cardDecoration(),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Shalat Hari Ini',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: AppColors.textPrimary)),
                    Text(
                      '${viewModel.totalShalatTerisi}/5',
                      style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 22,
                          color: AppColors.emeraldLight),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: viewModel.totalShalatTerisi / 5,
                    backgroundColor: AppColors.cream2,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.emeraldLight),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          _sectionLabel('Waktu Shalat'),
          const SizedBox(height: 12),

          _buildShalatItem(
              'Subuh', shalat.subuh, () => viewModel.toggleShalat('subuh')),
          _buildShalatItem(
              'Dzuhur', shalat.dzuhur, () => viewModel.toggleShalat('dzuhur')),
          _buildShalatItem(
              'Ashar', shalat.ashar, () => viewModel.toggleShalat('ashar')),
          _buildShalatItem('Maghrib', shalat.maghrib,
              () => viewModel.toggleShalat('maghrib')),
          _buildShalatItem(
              'Isya', shalat.isya, () => viewModel.toggleShalat('isya')),

          const SizedBox(height: 24),
          _sectionLabel('Inspirasi'),
          const SizedBox(height: 12),
          _buildQuoteCard(),
        ],
      ),
    );
  }

  Widget _buildShalatItem(String name, bool isChecked, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: _cardDecoration(),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.emeraldLight, AppColors.emerald],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.mosque, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: AppColors.textPrimary)),
            ),
            // Custom checkbox matching HomeScreen aesthetic
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: isChecked ? AppColors.emeraldLight : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isChecked
                      ? AppColors.emeraldLight
                      : Colors.black.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: isChecked
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  //  INFAQ TAB
  // ─────────────────────────────────────────
  Widget _buildInfaqTab(RamadhanViewModel viewModel) {
    final infaqHariIni = viewModel.infaqList
        .where((i) => i.tanggal == viewModel.selectedDate)
        .toList();
    final totalInfaqHariIni =
        infaqHariIni.fold(0, (sum, item) => sum + item.nominal);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionLabel('Ringkasan'),
              const SizedBox(height: 12),

              // Summary card — same 2-column layout as stats in header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: _cardDecoration(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildInfaqStat(
                        'Hari Ini', 'Rp ${_formatNumber(totalInfaqHariIni)}'),
                    Container(width: 1, height: 44, color: AppColors.cream2),
                    _buildInfaqStat('Bulan Ini',
                        'Rp ${_formatNumber(viewModel.totalInfaqBulanIni)}'),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showAddInfaqDialog(viewModel),
                  icon: const Icon(Icons.add, color: Colors.white, size: 20),
                  label: const Text('Tambah Infaq',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.emeraldMid,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _sectionLabel('Riwayat Hari Ini'),
              const SizedBox(height: 12),
            ],
          ),
        ),
        Expanded(
          child: infaqHariIni.isEmpty
              ? _buildEmptyState(
                  Icons.payments_outlined, 'Belum ada infaq hari ini')
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  itemCount: infaqHariIni.length,
                  itemBuilder: (context, index) {
                    final item = infaqHariIni[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: _cardDecoration(),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor:
                                AppColors.emeraldMid.withOpacity(0.1),
                            child: const Icon(Icons.payments_outlined,
                                color: AppColors.emeraldMid, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Rp ${_formatNumber(item.nominal)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: AppColors.textPrimary),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item.keterangan.isNotEmpty
                                      ? item.keterangan
                                      : 'Infaq',
                                  style: const TextStyle(
                                      fontSize: 12, color: AppColors.textMuted),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Color(0xFFE24B4A), size: 20),
                            onPressed: () =>
                                _confirmDeleteInfaq(viewModel, item.id),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildInfaqStat(String label, String value) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: AppColors.emeraldLight)),
      ],
    );
  }

  // ─────────────────────────────────────────
  //  CERAMAH TAB
  // ─────────────────────────────────────────
  Widget _buildCeramahTab(RamadhanViewModel viewModel) {
    final ceramahHariIni = viewModel.ceramahList
        .where((c) => c.tanggal == viewModel.selectedDate)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showAddCeramahDialog(viewModel),
                  icon: const Icon(Icons.add, color: Colors.white, size: 20),
                  label: const Text('Tambah Catatan Ceramah',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.emeraldMid,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _sectionLabel('Catatan Hari Ini'),
              const SizedBox(height: 12),
            ],
          ),
        ),
        Expanded(
          child: ceramahHariIni.isEmpty
              ? _buildEmptyState(
                  Icons.description_outlined, 'Belum ada catatan ceramah')
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  itemCount: ceramahHariIni.length,
                  itemBuilder: (context, index) {
                    final item = ceramahHariIni[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: _cardDecoration(),
                      child: ExpansionTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                        collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundColor:
                              AppColors.emeraldMid.withOpacity(0.1),
                          child: const Icon(Icons.record_voice_over,
                              color: AppColors.emeraldMid, size: 20),
                        ),
                        title: Text(item.judul,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: AppColors.textPrimary)),
                        subtitle: Text(
                          '${item.penceramah} · ${item.lokasi}',
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textMuted),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: Color(0xFFE24B4A), size: 20),
                              onPressed: () =>
                                  _confirmDeleteCeramah(viewModel, item.id),
                            ),
                          ],
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(color: AppColors.cream2),
                                const SizedBox(height: 4),
                                const Text('Catatan',
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.8,
                                        color: AppColors.textMuted)),
                                const SizedBox(height: 6),
                                Text(item.catatan,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        height: 1.6,
                                        color: AppColors.textPrimary)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  //  SHARED WIDGETS
  // ─────────────────────────────────────────

  /// Quote card — identical to HomeScreen's _buildQuoteCard()
  Widget _buildQuoteCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.emerald,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 10,
            bottom: -20,
            child: Text(
              '"',
              style: TextStyle(
                fontSize: 100,
                color: Colors.white.withOpacity(0.04),
                height: 1,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Hadits Pilihan',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.goldLight,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                '"Barang siapa yang berpuasa Ramadhan karena iman dan mengharap pahala dari Allah, maka dosa-dosanya yang telah lalu akan diampuni."',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.7,
                  color: Colors.white.withOpacity(0.88),
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '— HR. Bukhari & Muslim',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.goldLight,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Section label — exact copy of HomeScreen's _sectionLabel()
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

  Widget _buildEmptyState(IconData icon, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 56, color: AppColors.textMuted.withOpacity(0.35)),
          const SizedBox(height: 14),
          Text(message,
              style: const TextStyle(color: AppColors.textMuted, fontSize: 14)),
        ],
      ),
    );
  }

  /// Flat white card — same as HomeScreen's _MenuCard / _StatCard
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: Colors.black.withOpacity(0.06)),
    );
  }

  // ─────────────────────────────────────────
  //  DIALOGS (unchanged logic, updated style)
  // ─────────────────────────────────────────
  void _showAddInfaqDialog(RamadhanViewModel viewModel) {
    final nominalController = TextEditingController();
    final keteranganController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Tambah Infaq',
            style: TextStyle(
                fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nominalController,
              keyboardType: TextInputType.number,
              decoration:
                  _inputDecoration('Nominal (Rp)', Icons.payments_outlined),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: keteranganController,
              decoration: _inputDecoration(
                  'Keterangan (opsional)', Icons.description_outlined),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal',
                  style: TextStyle(color: AppColors.textMuted))),
          ElevatedButton(
            onPressed: () {
              final nominal = int.tryParse(nominalController.text) ?? 0;
              if (nominal > 0) {
                viewModel.addInfaq(nominal, keteranganController.text);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.emeraldMid,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Simpan',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _showAddCeramahDialog(RamadhanViewModel viewModel) {
    final judulController = TextEditingController();
    final penceramahController = TextEditingController();
    final catatanController = TextEditingController();
    final lokasiController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Tambah Catatan Ceramah',
            style: TextStyle(
                fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: judulController,
                  decoration: _inputDecoration('Judul Ceramah', Icons.title)),
              const SizedBox(height: 12),
              TextField(
                  controller: penceramahController,
                  decoration: _inputDecoration(
                      'Nama Penceramah', Icons.person_outline)),
              const SizedBox(height: 12),
              TextField(
                  controller: lokasiController,
                  decoration:
                      _inputDecoration('Lokasi', Icons.location_on_outlined)),
              const SizedBox(height: 12),
              TextField(
                controller: catatanController,
                maxLines: 3,
                decoration:
                    _inputDecoration('Catatan / Poin Penting', Icons.notes),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal',
                  style: TextStyle(color: AppColors.textMuted))),
          ElevatedButton(
            onPressed: () {
              if (judulController.text.isNotEmpty) {
                viewModel.addCeramah(
                  judul: judulController.text,
                  penceramah: penceramahController.text,
                  catatan: catatanController.text,
                  lokasi: lokasiController.text,
                );
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.emeraldMid,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Simpan',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.textMuted),
      prefixIcon: Icon(icon, color: AppColors.emeraldLight, size: 20),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.emeraldLight, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
      ),
    );
  }

  void _confirmDeleteInfaq(RamadhanViewModel viewModel, String id) {
    _showDeleteDialog(
      title: 'Hapus Infaq',
      content: 'Yakin ingin menghapus catatan infaq ini?',
      onConfirm: () => viewModel.deleteInfaq(id),
    );
  }

  void _confirmDeleteCeramah(RamadhanViewModel viewModel, String id) {
    _showDeleteDialog(
      title: 'Hapus Catatan',
      content: 'Yakin ingin menghapus catatan ceramah ini?',
      onConfirm: () => viewModel.deleteCeramah(id),
    );
  }

  void _showDeleteDialog({
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        content:
            Text(content, style: const TextStyle(color: AppColors.textMuted)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal',
                  style: TextStyle(color: AppColors.textMuted))),
          TextButton(
            onPressed: () {
              onConfirm();
              Navigator.pop(context);
            },
            style:
                TextButton.styleFrom(foregroundColor: const Color(0xFFE24B4A)),
            child: const Text('Hapus',
                style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  //  HELPERS
  // ─────────────────────────────────────────
  int _getRamadhanDay(DateTime now) {
    final ramadhanStart = DateTime(2025, 3, 1);
    final diff = now.difference(ramadhanStart).inDays + 1;
    if (diff < 1) return 1;
    if (diff > 30) return 30;
    return diff;
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}jt';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(0)}rb';
    }
    return number.toString();
  }
}
