import 'package:flutter/material.dart';
import 'package:muslim_app/viewmodels/qiblat_view_model.dart';
import 'package:provider/provider.dart';
import '../viewmodels/ramadhan_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/qiblat_view_model.dart';
import '../painters/home_compass_painter.dart';
import 'package:animate_do/animate_do.dart';

// ─────────────────────────────────────────
//  COLOR TOKENS
// ─────────────────────────────────────────
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

  // Menu accent colors
  static const jadwalBg = Color(0xFFE8EAF6);
  static const jadwalIcon = Color(0xFF3F51B5);
  static const quranBg = Color(0xFFF3E5F5);
  static const quranIcon = Color(0xFF7C4DFF);
  static const doaBg = Color(0xFFE0F2F1);
  static const doaIcon = Color(0xFFBA7517);
  static const asmaulBg = Color(0xFFEEEDFE);
  static const asmaulIcon = Color(0xFF533AAB);
  static const ramadhanBg = Color(0xFFFFF4E6);
  static const ramadhanIcon = Color(0xFF9C6D2E);
}

// ─────────────────────────────────────────
//  HOME SCREEN
// ─────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthViewModel>().loadCurrentUser();
      context.read<RamadhanViewModel>().loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      drawer: _buildDrawer(),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── HEADER ──────────────────────────────
          SliverToBoxAdapter(
              child: FadeInDown(
                  duration: const Duration(milliseconds: 600),
                  child: _buildHeader())),

          // ── BODY ─────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── RAMADHAN + QIBLAT ROW ──
                  FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    child: Row(
                      children: [
                        Expanded(child: _buildRamadhanTrackerCard()),
                        const SizedBox(width: 12),
                        _buildQiblatCard(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  FadeInUp(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 100),
                      child: _sectionLabel('Menu Utama')),
                  const SizedBox(height: 10),
                  FadeInUp(
                      duration: const Duration(milliseconds: 600),
                      delay: const Duration(milliseconds: 150),
                      child: _buildMenuGrid()),
                  const SizedBox(height: 16),
                  FadeInUp(
                      duration: const Duration(milliseconds: 700),
                      delay: const Duration(milliseconds: 200),
                      child: _sectionLabel('Inspirasi')),
                  const SizedBox(height: 10),
                  FadeInUp(
                      duration: const Duration(milliseconds: 700),
                      delay: const Duration(milliseconds: 250),
                      child: _buildQuoteCard()),
                  const SizedBox(height: 16),
                  FadeInUp(
                      duration: const Duration(milliseconds: 800),
                      delay: const Duration(milliseconds: 300),
                      child: _sectionLabel('Progress Ibadah')),
                  const SizedBox(height: 10),
                  FadeInUp(
                    duration: const Duration(milliseconds: 800),
                    delay: const Duration(milliseconds: 350),
                    child: Consumer<RamadhanViewModel>(
                      builder: (context, vm, _) => _buildStatsRow(
                        shalat: vm.totalShalatTerisi,
                        infaq: vm.totalInfaqHariIni,
                        ceramah: vm.ceramahList.length,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeInUp(
                      duration: const Duration(milliseconds: 900),
                      delay: const Duration(milliseconds: 400),
                      child: _sectionLabel('Ayat Hari Ini')),
                  const SizedBox(height: 10),
                  FadeInUp(
                      duration: const Duration(milliseconds: 900),
                      delay: const Duration(milliseconds: 450),
                      child: _buildAyatCard()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  //  SIDEBAR DRAWER
  // ─────────────────────────────────────────
  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        color: AppColors.cream,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(0, 24, 0, 20),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Consumer<AuthViewModel>(
                builder: (context, authVM, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authVM.currentUser?.nama ?? 'User',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        authVM.currentUser?.email ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Divider(color: AppColors.textMuted.withOpacity(0.1)),
            const SizedBox(height: 12),
            _drawerItem('Jadwal Shalat', Icons.access_time_outlined, '/jadwal'),
            _drawerItem('Al-Qur\'an', Icons.menu_book_outlined, '/quran'),
            _drawerItem('Doa Harian', Icons.volunteer_activism_outlined, '/doa'),
            _drawerItem('Asmaul Husna', Icons.brightness_5_outlined, '/asmaul'),
            _drawerItem('Ramadhan', Icons.restaurant, '/ramadhan'),
            _drawerItem('Kiblat', Icons.explore_outlined, '/qiblat'),
            Divider(color: AppColors.textMuted.withOpacity(0.1)),
            _drawerItem('Profil', Icons.person_outline, '/profile'),
            _drawerItem('Keluar', Icons.logout_rounded, null, isRed: true),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(String label, IconData icon, String? route,
      {bool isRed = false}) {
    return ListTile(
      leading: Icon(icon, color: isRed ? Colors.red[400] : AppColors.textPrimary, size: 20),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isRed ? Colors.red[400] : AppColors.textPrimary,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        if (route != null) {
          Navigator.pushNamed(context, route);
        } else if (label == 'Keluar') {
          context.read<AuthViewModel>().logout();
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
    );
  }

  // ─────────────────────────────────────────
  //  QIBLAT CARD
  // ─────────────────────────────────────────
  Widget _buildQiblatCard() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/qiblat'),
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.jadwalIcon.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.jadwalIcon.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.explore_outlined,
                    color: AppColors.jadwalIcon,
                    size: 18,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.textMuted.withOpacity(0.3),
                  size: 12,
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Compass
            Consumer<QiblatViewModel>(
              builder: (context, vm, _) {
                final heading = vm?.currentDirection?.direction ?? 0.0;
                final qiblah = vm?.currentDirection?.qiblah ?? 293.0;

                return SizedBox(
                  width: 70,
                  height: 70,
                  child: CustomPaint(
                    painter: HomeCompassPainter(
                      headingAngle: heading,
                      qiblahAngle: qiblah,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            Text(
              'Kiblat',
              style: TextStyle(
                color: AppColors.jadwalIcon,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              'Tap untuk',
              style: TextStyle(
                color: AppColors.textMuted.withOpacity(0.6),
                fontSize: 9,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  //  RAMADHAN TRACKER CARD
  // ─────────────────────────────────────────
  Widget _buildRamadhanTrackerCard() {
    return Consumer<RamadhanViewModel>(
      builder: (context, vm, _) {
        final ramadhanDay = _getRamadhanDay(DateTime.now());

        return GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/ramadhan'),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF9C6D2E).withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFF9C6D2E).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.restaurant,
                        color: Color(0xFF9C6D2E),
                        size: 18,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.textMuted.withOpacity(0.3),
                      size: 12,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Ramadhan',
                  style: TextStyle(
                    color: const Color(0xFF9C6D2E),
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  'Hari ke-$ramadhanDay',
                  style: TextStyle(
                    color: AppColors.textMuted.withOpacity(0.7),
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSmallStat('${vm.totalShalatTerisi}/5', Icons.mosque),
                    _buildSmallStat(
                        _formatNumber(vm.totalInfaqHariIni), Icons.money),
                    _buildSmallStat(
                        '${vm.ceramahList.length}', Icons.description),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSmallStat(String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF9C6D2E).withOpacity(0.7), size: 13),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF9C6D2E),
            fontWeight: FontWeight.w700,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

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

  // ─────────────────────────────────────────
  //  HEADER
  // ─────────────────────────────────────────
  Widget _buildHeader() {
    return Consumer<AuthViewModel>(
      builder: (context, authVM, _) {
        final firstName = authVM.currentUser?.nama.split(' ').first ?? 'Akhi';
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.emerald,
                AppColors.emeraldMid,
                Color(0xFF1F6B45)
              ],
              stops: [0.0, 0.6, 1.0],
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          ),
          child: Stack(
            children: [
              // Decorative circle
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
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── TOP ROW: greeting + avatar ──
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Assalamu'alaikum,",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.55),
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  firstName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.3,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today_outlined,
                                        size: 10,
                                        color: Colors.white.withOpacity(0.4)),
                                    const SizedBox(width: 5),
                                    Text(
                                      '${_getDateString()} · 9 Syawal 1447H',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.4),
                                        fontSize: 10.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildAvatarButton(),
                              const SizedBox(height: 8),
                              _buildBadge(),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // ── COUNTDOWN STRIP ──
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(16),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.18)),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'SHALAT BERIKUTNYA',
                                      style: TextStyle(
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.8,
                                        color: Colors.white.withOpacity(0.5),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    const Text(
                                      'Ashar',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'Dalam 2j 34m lagi',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white.withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '15:22',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.goldLight,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: 0.65,
                                backgroundColor: Colors.white.withOpacity(0.15),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.goldLight.withOpacity(0.8),
                                ),
                                minHeight: 3,
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
      },
    );
  }

  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.goldLight,
            ),
          ),
          const SizedBox(width: 7),
          const Text(
            'Muslim Premium',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarButton() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/profile'),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.15),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
        ),
        child: const Icon(Icons.person_outline, color: Colors.white, size: 20),
      ),
    );
  }

  // ─────────────────────────────────────────
  //  MENU GRID
  // ─────────────────────────────────────────
  Widget _buildMenuGrid() {
    final menus = [
      _MenuData(
        title: 'Jadwal Shalat',
        subtitle: 'Jakarta · Hari ini',
        icon: Icons.access_time_outlined,
        route: '/jadwal',
        iconBg: AppColors.jadwalBg,
        iconColor: AppColors.jadwalIcon,
      ),
      _MenuData(
        title: 'Al-Qur\'an',
        subtitle: 'Lanjut Al-Baqarah',
        icon: Icons.menu_book_outlined,
        route: '/quran',
        iconBg: AppColors.quranBg,
        iconColor: AppColors.quranIcon,
      ),
      _MenuData(
        title: 'Doa Harian',
        subtitle: '45 doa tersedia',
        icon: Icons.volunteer_activism_outlined,
        route: '/doa',
        iconBg: AppColors.doaBg,
        iconColor: AppColors.doaIcon,
      ),
      _MenuData(
        title: 'Asmaul Husna',
        subtitle: '99 nama Allah',
        icon: Icons.brightness_5_outlined,
        route: '/asmaul',
        iconBg: AppColors.asmaulBg,
        iconColor: AppColors.asmaulIcon,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: menus.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.4,
      ),
      itemBuilder: (context, i) => _MenuCard(data: menus[i]),
    );
  }

  // ─────────────────────────────────────────
  //  QUOTE CARD
  // ─────────────────────────────────────────
  Widget _buildQuoteCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.emerald,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Stack(
        children: [
          // Decorative big quote mark
          Positioned(
            right: 8,
            bottom: -16,
            child: Text(
              '"',
              style: TextStyle(
                fontSize: 80,
                color: Colors.white.withOpacity(0.03),
                height: 1,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tag
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Hadits Pilihan',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: AppColors.goldLight,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Quote text
              Text(
                '"Sebaik-baik kalian adalah yang mempelajari Al-Qur\'an."',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.6,
                  color: Colors.white.withOpacity(0.87),
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '— HR. Bukhari',
                style: TextStyle(
                  fontSize: 10,
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

  // ─────────────────────────────────────────
  //  STATS ROW
  // ─────────────────────────────────────────
  Widget _buildStatsRow({
    required int shalat,
    required int infaq,
    required int ceramah,
  }) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            value: '$shalat/5',
            label: 'Shalat',
            color: AppColors.emeraldLight,
            progress: shalat / 5,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            value: infaq > 0 ? '${infaq}k' : '-',
            label: 'Infaq',
            color: AppColors.doaIcon,
            progress: infaq > 0 ? 0.5 : 0,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            value: '$ceramah',
            label: 'Catatan',
            color: AppColors.asmaulIcon,
            progress: ceramah / 10,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────
  //  AYAT CARD
  // ─────────────────────────────────────────
  Widget _buildAyatCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cream2,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            'إِنَّ مَعَ الْعُسْرِ يُسْرًا',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 20,
              height: 1.8,
              color: AppColors.emerald,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '"Sesungguhnya bersama kesulitan ada kemudahan."',
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: AppColors.textPrimary.withOpacity(0.85),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '— QS. Al-Insyirah: 6',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
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
        letterSpacing: 1.3,
        color: AppColors.textMuted,
      ),
    );
  }

  String _getDateString() {
    const days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu'
    ];
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    final now = DateTime.now();
    return '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}';
  }
}

// ─────────────────────────────────────────
//  DATA MODEL (menu)
// ─────────────────────────────────────────
class _MenuData {
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
  final Color iconBg;
  final Color iconColor;

  const _MenuData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
    required this.iconBg,
    required this.iconColor,
  });
}

// ─────────────────────────────────────────
//  MENU CARD WIDGET
// ─────────────────────────────────────────
class _MenuCard extends StatelessWidget {
  final _MenuData data;
  const _MenuCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, data.route),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: data.iconBg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: data.iconColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(data.icon, color: data.iconColor, size: 18),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: data.iconColor,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.subtitle,
                  style: TextStyle(
                    fontSize: 10,
                    color: data.iconColor.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
//  STAT CARD WIDGET
// ─────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final double progress;

  const _StatCard({
    required this.value,
    required this.label,
    required this.color,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: color,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: AppColors.cream2,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 3,
            ),
          ),
        ],
      ),
    );
  }
}
