import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Kompas mini yang ditampilkan di Qiblah card pada home screen.
/// Ukuran optimal: 80×80. Bisa dikustomisasi lewat [qiblahAngle] dan [headingAngle].
class HomeCompassPainter extends CustomPainter {
  /// Arah kiblat dalam derajat (dari data sensor).
  final double qiblahAngle;

  /// Arah perangkat saat ini dalam derajat (heading).
  final double headingAngle;

  const HomeCompassPainter({
    this.qiblahAngle = 293.0,
    this.headingAngle = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // ── Background circle ──────────────────────────
    canvas.drawCircle(
      center,
      radius,
      Paint()..color = const Color(0xFFEAF5EE),
    );

    // ── Outer border ───────────────────────────────
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = const Color(0xFF3F51B5).withOpacity(0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // ── Inner ring (subtle) ────────────────────────
    canvas.drawCircle(
      center,
      radius - 8,
      Paint()
        ..color = const Color(0xFF3F51B5).withOpacity(0.08)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    // ── Cardinal direction ticks ───────────────────
    final tickPaint = Paint()
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 4; i++) {
      final angle = i * math.pi / 2;
      final isNorth = i == 0;

      tickPaint.color = isNorth
          ? const Color(0xFFB39DDB)
          : const Color(0xFF3F51B5).withOpacity(0.25);

      final outerR = radius - 2;
      final innerR = isNorth ? radius - 10 : radius - 7;

      final outerPoint = Offset(
        center.dx + outerR * math.sin(angle),
        center.dy - outerR * math.cos(angle),
      );
      final innerPoint = Offset(
        center.dx + innerR * math.sin(angle),
        center.dy - innerR * math.cos(angle),
      );
      canvas.drawLine(innerPoint, outerPoint, tickPaint);
    }

    // ── Small ticks between cardinals ─────────────
    final smallTickPaint = Paint()
      ..color = const Color(0xFF3F51B5).withOpacity(0.12)
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 8; i++) {
      if (i % 2 == 0) continue; // skip cardinal positions
      final angle = i * math.pi / 4;
      final outerPoint = Offset(
        center.dx + (radius - 2) * math.sin(angle),
        center.dy - (radius - 2) * math.cos(angle),
      );
      final innerPoint = Offset(
        center.dx + (radius - 6) * math.sin(angle),
        center.dy - (radius - 6) * math.cos(angle),
      );
      canvas.drawLine(innerPoint, outerPoint, smallTickPaint);
    }

    // ── Qiblah needle ──────────────────────────────
    // Relative angle: qiblah direction minus current heading
    final relativeAngleRad = (qiblahAngle - headingAngle) * math.pi / 180;

    final needleLen = radius * 0.60;
    final tailLen = radius * 0.25;

    final tip = Offset(
      center.dx + needleLen * math.sin(relativeAngleRad),
      center.dy - needleLen * math.cos(relativeAngleRad),
    );
    final tail = Offset(
      center.dx - tailLen * math.sin(relativeAngleRad),
      center.dy + tailLen * math.cos(relativeAngleRad),
    );

    // Needle shadow (faint, for depth)
    canvas.drawLine(
      center,
      tip,
      Paint()
        ..color = const Color(0xFF3F51B5).withOpacity(0.12)
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round,
    );

    // Green needle (toward Qiblah)
    canvas.drawLine(
      center,
      tip,
      Paint()
        ..color = const Color(0xFF3F51B5)
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round,
    );

    // Faded tail
    canvas.drawLine(
      center,
      tail,
      Paint()
        ..color = const Color(0xFF3F51B5).withOpacity(0.2)
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round,
    );

    // ── Center dot ─────────────────────────────────
    canvas.drawCircle(
      center,
      radius * 0.11,
      Paint()..color = const Color(0xFF3F51B5),
    );
    canvas.drawCircle(
      center,
      radius * 0.055,
      Paint()..color = Colors.white,
    );

    // ── "U" (Utara / North) label ──────────────────
    final tp = TextPainter(
      text: const TextSpan(
        text: 'U',
        style: TextStyle(
          color: Color(0xFFB39DDB),
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 0,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(center.dx - tp.width / 2, 4));
  }

  @override
  bool shouldRepaint(covariant HomeCompassPainter old) =>
      old.qiblahAngle != qiblahAngle || old.headingAngle != headingAngle;
}
