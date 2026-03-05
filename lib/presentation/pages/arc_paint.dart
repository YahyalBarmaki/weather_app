import 'package:flutter/material.dart';
import 'dart:math';
class ArcPainter extends CustomPainter {
  final double progress; final bool done;
  const ArcPainter({required this.progress, required this.done});

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 10;
    canvas.drawCircle(c, r, Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..strokeWidth = 9 ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round);
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: r), -pi / 2, 2 * pi * progress, false,
      Paint()
        ..shader = SweepGradient(
          startAngle: -pi / 2, endAngle: 3 * pi / 2,
          colors: done
              ? [const Color(0xFF00E676), const Color(0xFF69F0AE)]
              : [const Color(0xFF6C63FF), const Color(0xFF00E5FF), const Color(0xFF7B5EA7)],
        ).createShader(Rect.fromCircle(center: c, radius: r))
        ..strokeWidth = 9 ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
    if (progress > 0.02) {
      final angle = -pi / 2 + 2 * pi * progress;
      final dx = c.dx + r * cos(angle);
      final dy = c.dy + r * sin(angle);
      final dot = done ? const Color(0xFF00E676) : const Color(0xFF00E5FF);
      canvas.drawCircle(Offset(dx, dy), 7,
          Paint()..color = dot ..style = PaintingStyle.fill);
      canvas.drawCircle(Offset(dx, dy), 14,
          Paint()..color = dot.withOpacity(0.35) ..style = PaintingStyle.fill);
    }
  }

  @override bool shouldRepaint(ArcPainter o) =>
      o.progress != progress || o.done != done;
}

// ── Points bounce ────────────────────────────────────────────



