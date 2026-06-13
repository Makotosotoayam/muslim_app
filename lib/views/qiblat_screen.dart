import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:muslim_app/painters/compas_painter.dart';
import 'package:provider/provider.dart';
import '../viewmodels/qiblat_view_model.dart';
import '../painters/compas_painter.dart';
import 'package:animate_do/animate_do.dart';

class QiblatScreen extends StatefulWidget {
  const QiblatScreen({super.key});

  @override
  State<QiblatScreen> createState() => _QiblatScreenState();
}

class _QiblatScreenState extends State<QiblatScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<QiblatViewModel>().initialize());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3FF), // Light Blue
      body: Consumer<QiblatViewModel>(
        builder: (context, vm, child) {
          if (vm.error != null) return _buildErrorState(vm.error);
          if (vm.currentDirection == null) return _buildLoadingState();

          final direction = vm.currentDirection!;
          // Toleransi 2 derajat dianggap pas ke arah Mekkah
          final isAligned = direction.offset.abs() < 2.0;

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                  child: FadeInDown(
                      duration: const Duration(milliseconds: 600),
                      child: _buildHeader(context))),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      FadeInUp(
                          duration: const Duration(milliseconds: 500),
                          child: _buildStatusBadge(isAligned)),
                      const SizedBox(height: 30),

                      // AREA KOMPAS REALTIME
                      FadeInUp(
                        duration: const Duration(milliseconds: 600),
                        delay: const Duration(milliseconds: 100),
                        child: _buildCompassWidget(
                            direction.direction, direction.qiblah),
                      ),

                      const SizedBox(height: 30),
                      FadeInUp(
                          duration: const Duration(milliseconds: 700),
                          delay: const Duration(milliseconds: 200),
                          child: _buildInfoRow(direction)),
                      const SizedBox(height: 20),
                      FadeInUp(
                          duration: const Duration(milliseconds: 800),
                          delay: const Duration(milliseconds: 300),
                          child: _buildOffsetCard(direction.offset, isAligned)),
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

  Widget _buildCompassWidget(double heading, double qiblah) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: SizedBox(
        width: 280,
        height: 280,
        child: CustomPaint(
          painter: CompassPainter(
            heading: heading,
            qiblah: qiblah,
            size: 280,
          ),
        ),
      ),
    );
  }

  // --- Widget pendukung lainnya (Header, Badge, dll) ---

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      decoration: const BoxDecoration(
        color: Color(0xFF3F51B5), // Blue
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          const Text(
            'Arah Kiblat',
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(bool isAligned) {
    if (isAligned)
      HapticFeedback.selectionClick(); // Getar halus pas nemu kiblat
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isAligned ? const Color(0xFFEAF5EE) : Colors.grey[200],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        isAligned ? '✨ KIBLAT TERKUNCI' : 'PUTAR PERLAHAN',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isAligned ? const Color(0xFF3F51B5) : Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildInfoRow(dynamic dir) {
    return Row(
      children: [
        _infoBox("Heading", "${dir.direction.toStringAsFixed(0)}°"),
        const SizedBox(width: 15),
        _infoBox("Kiblat", "${dir.qiblah.toStringAsFixed(0)}°"),
      ],
    );
  }

  Widget _infoBox(String label, String val) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Text(val,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(label,
                style: TextStyle(fontSize: 12, color: Colors.grey[500])),
          ],
        ),
      ),
    );
  }

  Widget _buildOffsetCard(double offset, bool isAligned) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isAligned ? const Color(0xFF3F51B5) : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isAligned
            ? "Anda sudah menghadap Ka'bah"
            : "Selisih ${offset.abs().toStringAsFixed(0)}° lagi",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isAligned ? Colors.white : Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLoadingState() =>
      const Center(child: CircularProgressIndicator());
  Widget _buildErrorState(String? err) => Center(child: Text("Error: $err"));
}
