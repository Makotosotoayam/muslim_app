import 'package:flutter/material.dart';
import 'dart:math' as math;

class CompassPainter extends CustomPainter {
  final double heading;
  final double qiblah;
  final double size;

  const CompassPainter({
    required this.heading,
    required this.qiblah,
    required this.size,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Hitung sudut relatif antara HP dan Ka'bah
    final double relRad = (qiblah - heading) * (math.pi / 180);

    // 1. Background & Border
    canvas.drawCircle(center, radius, Paint()..color = const Color(0xFFEAF5EE));
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = const Color(0xFF3F51B5).withOpacity(0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // 2. Dial Kompas (Tick Marks)
    final double headingRad = -heading * (math.pi / 180);
    for (int i = 0; i < 72; i++) {
      final angle = (i * math.pi / 36) + headingRad;
      final isCardinal = i % 18 == 0;
      final tickLength = isCardinal ? 12.0 : 5.0;

      final outerPoint = Offset(
        center.dx + (radius - 2) * math.sin(angle),
        center.dy - (radius - 2) * math.cos(angle),
      );
      final innerPoint = Offset(
        center.dx + (radius - 2 - tickLength) * math.sin(angle),
        center.dy - (radius - 2 - tickLength) * math.cos(angle),
      );

      canvas.drawLine(
        innerPoint,
        outerPoint,
        Paint()
          ..color = isCardinal
              ? const Color(0xFFB39DDB)
              : const Color(0xFF3F51B5).withOpacity(0.1)
          ..strokeWidth = isCardinal ? 2.0 : 1.0,
      );
    }

    // 3. Jarum Penunjuk (Needle)
    final needleLen = radius * 0.65;
    final tip = Offset(
      center.dx + needleLen * math.sin(relRad),
      center.dy - needleLen * math.cos(relRad),
    );

    // Glow Jarum
    canvas.drawLine(
        center,
        tip,
        Paint()
          ..color = const Color(0xFF3F51B5).withOpacity(0.1)
          ..strokeWidth = 8
          ..strokeCap = StrokeCap.round);

    // Body Jarum
    canvas.drawLine(
        center,
        tip,
        Paint()
          ..color = const Color(0xFF2E7D52)
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round);

    // Kepala Panah
    final arrowPath = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(tip.dx + 10 * math.sin(relRad - 2.6),
          tip.dy - 10 * math.cos(relRad - 2.6))
      ..lineTo(tip.dx + 10 * math.sin(relRad + 2.6),
          tip.dy - 10 * math.cos(relRad + 2.6))
      ..close();
    canvas.drawPath(arrowPath, Paint()..color = const Color(0xFF2E7D52));

    // 4. Icon Kaabah (Fixing the Void Error)
    final labelOffset = Offset(
      center.dx + (needleLen + 25) * math.sin(relRad),
      center.dy - (needleLen + 25) * math.cos(relRad),
    );

    final textPainter = TextPainter(
      text: const TextSpan(text: '🕌', style: TextStyle(fontSize: 20)),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(); // Panggil layout dulu
    textPainter.paint(
        // Baru panggil paint secara terpisah
        canvas,
        Offset(labelOffset.dx - textPainter.width / 2,
            labelOffset.dy - textPainter.height / 2));

    // Titik Tengah
    canvas.drawCircle(center, 5, Paint()..color = const Color(0xFF2E7D52));
    canvas.drawCircle(center, 2, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CompassPainter oldDelegate) => true;
}
