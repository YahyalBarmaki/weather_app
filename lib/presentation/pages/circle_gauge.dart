import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/presentation/pages/arc_paint.dart';
import 'package:weather_app/presentation/theme/app_theme.dart';
import 'package:weather_app/presentation/widgets/glass_card.dart';

class CircleGauge extends StatelessWidget {
  final double progress; final int pct;
  final bool dark, done; final VoidCallback? onTap;
  const CircleGauge({required this.progress, required this.pct,
    required this.dark, required this.done, this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: SizedBox(width: 200, height: 200,
      child: Stack(alignment: Alignment.center, children: [
        Container(width: 200, height: 200, decoration: BoxDecoration(
          shape: BoxShape.circle, boxShadow: [BoxShadow(
            color: (done ? AppTheme.cGreen : AppTheme.cIndigo).withOpacity(0.35),
            blurRadius: 50, spreadRadius: 12)])),
        CustomPaint(size: const Size(200, 200),
            painter: ArcPainter(progress: progress, done: done)),
        GlassCard(radius: 90, width: 144, height: 144, padding: EdgeInsets.zero,
          child: Center(child: done
            ? Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.check_circle_rounded, color: AppTheme.cGreen, size: 40),
                const SizedBox(height: 4),
                Text('Appuyer', style: GoogleFonts.outfit(
                    color: AppTheme.cGreen, fontSize: 12,
                    fontWeight: FontWeight.w600)),
              ])
            : AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: Text('$pct%', key: ValueKey(pct),
                  style: GoogleFonts.outfit(color: AppTheme.textPrimary(dark),
                      fontSize: 40, fontWeight: FontWeight.w800)),
              ),
          )),
      ]),
    ),
  );
}