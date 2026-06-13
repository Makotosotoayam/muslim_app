import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/jadwal_viewmodel.dart';
import '../models/jadwal_model.dart';
import 'dart:async';
import 'package:animate_do/animate_do.dart';

// Reuse AppColors dari home_screen.dart (atau pindah ke colors.dart)
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
}

class JadwalScreen extends StatefulWidget {
  const JadwalScreen({super.key});

  @override
  State<JadwalScreen> createState() => _JadwalScreenState();
}

class _JadwalScreenState extends State<JadwalScreen> {
  Timer? _timer;
  String _nextPrayer = 'Menghitung...';
  String _timeRemaining = '';

  // Data shalat dengan icon & urutan
  static const _prayerMeta = [
    {'key': 'Imsak', 'icon': Icons.nights_stay_outlined},
    {'key': 'Subuh', 'icon': Icons.wb_twilight_outlined},
    {'key': 'Dzuhur', 'icon': Icons.wb_sunny_outlined},
    {'key': 'Ashar', 'icon': Icons.cloud_queue_outlined},
    {'key': 'Maghrib', 'icon': Icons.wb_cloudy_outlined},
    {'key': 'Isya', 'icon': Icons.dark_mode_outlined},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<JadwalViewModel>().fetchJadwal();
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateNextPrayer(context);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateNextPrayer(BuildContext context) {
    final vm = context.read<JadwalViewModel>();
    if (vm.jadwalHariIni == null) return;
    final now = DateTime.now();
    final jadwal = vm.jadwalHariIni!;

    final prayers = [
      {'name': 'Imsak', 'time': jadwal.jadwal.imsak},
      {'name': 'Subuh', 'time': jadwal.jadwal.subuh},
      {'name': 'Dzuhur', 'time': jadwal.jadwal.dzuhur},
      {'name': 'Ashar', 'time': jadwal.jadwal.ashar},
      {'name': 'Maghrib', 'time': jadwal.jadwal.maghrib},
      {'name': 'Isya', 'time': jadwal.jadwal.isya},
    ];

    for (final p in prayers) {
      final t = p['time'];
      if (t == null || t.isEmpty || t == '--:--') continue;
      final parsed = _parseTime(t);
      final dt =
          DateTime(now.year, now.month, now.day, parsed.hour, parsed.minute);
      if (dt.isAfter(now)) {
        final diff = dt.difference(now);
        if (mounted) {
          setState(() {
            _nextPrayer = p['name']!;
            _timeRemaining = _formatDuration(diff);
          });
        }
        return;
      }
    }
    if (mounted)
      setState(() {
        _nextPrayer = 'Subuh';
        _timeRemaining = 'Besok';
      });
  }

  DateTime _parseTime(String s) {
    final p = s.split(':');
    return DateTime(2000, 1, 1, int.parse(p[0]), int.parse(p[1]));
  }

  String _formatDuration(Duration d) {
    String z(int n) => n.toString().padLeft(2, '0');
    return '${z(d.inHours)}:${z(d.inMinutes.remainder(60))}:${z(d.inSeconds.remainder(60))}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Consumer<JadwalViewModel>(
        builder: (context, vm, _) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── HEADER ──
              SliverToBoxAdapter(
                  child: FadeInDown(
                      duration: const Duration(milliseconds: 600),
                      child: _buildHeader(vm))),

              // ── BODY ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeInUp(
                          duration: const Duration(milliseconds: 500),
                          child: _sectionLabel('Jadwal Hari Ini')),
                      const SizedBox(height: 14),
                      if (vm.isLoading)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(40),
                            child: CircularProgressIndicator(
                                color: AppColors.emeraldLight),
                          ),
                        )
                      else if (vm.jadwalHariIni == null)
                        _buildEmpty()
                      else
                        _buildJadwalList(vm.jadwalHariIni!),
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
  //  HEADER
  // ─────────────────────────────────────────
  Widget _buildHeader(JadwalViewModel vm) {
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
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
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
                      const Text(
                        'Jadwal Shalat',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const Spacer(),
                      // Location dropdown
                      _buildLocationDropdown(vm),
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
                      border: Border.all(color: Colors.white.withOpacity(0.18)),
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
                                Text(
                                  _nextPrayer,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'menuju waktu shalat',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              _timeRemaining.isEmpty
                                  ? '--:--:--'
                                  : _timeRemaining,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                color: AppColors.goldLight,
                                letterSpacing: -0.5,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: _countdownProgress(),
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
  }

  Widget _buildLocationDropdown(JadwalViewModel vm) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on_outlined,
              color: Colors.white.withOpacity(0.8), size: 14),
          const SizedBox(width: 4),
          DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              isDense: true,
              icon: Icon(Icons.keyboard_arrow_down_rounded,
                  color: Colors.white.withOpacity(0.7), size: 16),
              value: vm.selectedKotaId,
              dropdownColor: AppColors.emerald,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
              items: vm.daftarKota
                  .map((k) => DropdownMenuItem(
                        value: k.id,
                        child: Text(k.nama,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            )),
                      ))
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  vm.changeKota(
                      v, vm.daftarKota.firstWhere((k) => k.id == v).nama);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  //  JADWAL LIST
  // ─────────────────────────────────────────
  Widget _buildJadwalList(JadwalData jadwal) {
    final times = [
      jadwal.jadwal.imsak,
      jadwal.jadwal.subuh,
      jadwal.jadwal.dzuhur,
      jadwal.jadwal.ashar,
      jadwal.jadwal.maghrib,
      jadwal.jadwal.isya,
    ];

    return Column(
      children: List.generate(_prayerMeta.length, (i) {
        final name = _prayerMeta[i]['key'] as String;
        final icon = _prayerMeta[i]['icon'] as IconData;
        final time = times[i];
        final isNext = name == _nextPrayer;

        return FadeInUp(
          duration: const Duration(milliseconds: 500),
          delay: Duration(milliseconds: i * 100),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _PrayerCard(
              name: name,
              time: time,
              icon: icon,
              isNext: isNext,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(Icons.search_off_rounded,
                size: 48, color: AppColors.textMuted.withOpacity(0.4)),
            const SizedBox(height: 12),
            const Text('Data tidak ditemukan',
                style: TextStyle(color: AppColors.textMuted, fontSize: 14)),
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

  double _countdownProgress() {
    // Estimasi kasar: progress bar tidak kritis, pakai fallback 0.5
    return 0.5;
  }
}

// ─────────────────────────────────────────
//  PRAYER CARD WIDGET
// ─────────────────────────────────────────
class _PrayerCard extends StatelessWidget {
  final String name;
  final String time;
  final IconData icon;
  final bool isNext;

  const _PrayerCard({
    required this.name,
    required this.time,
    required this.icon,
    required this.isNext,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isNext ? AppColors.emerald : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isNext ? AppColors.emerald : Colors.black.withOpacity(0.06),
        ),
      ),
      child: Row(
        children: [
          // Icon container
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isNext
                  ? Colors.white.withOpacity(0.12)
                  : AppColors.emeraldLight.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isNext ? Colors.white : AppColors.emeraldLight,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),

          // Name + label
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isNext ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                if (isNext)
                  Text(
                    'Berikutnya',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white.withOpacity(0.6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),

          // Time
          Text(
            time.isEmpty ? '--:--' : time,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: isNext ? AppColors.goldLight : AppColors.emerald,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }
}
