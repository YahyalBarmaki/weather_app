import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/weather_city.dart';
import '../theme/app_theme.dart';
import 'glass_card.dart';

class SunCard extends StatelessWidget {
  final WeatherCity city; final bool dark;
  const SunCard({required this.city, required this.dark});

  @override
  Widget build(BuildContext context) => GlassCard(
    radius: 22, padding: const EdgeInsets.all(22),
    child: Row(children: [
      Expanded(child: _SunItem('🌅', 'Lever du soleil',
          city.sunrise, AppTheme.cYellow, dark)),
      Container(width: 1, height: 55, color: Colors.white.withOpacity(0.1)),
      Expanded(child: _SunItem('🌇', 'Coucher du soleil',
          city.sunset, AppTheme.cOrange, dark)),
    ]),
  );
}

class _SunItem extends StatelessWidget {
  final String emoji, label, time; final Color color; final bool dark;
  const _SunItem(this.emoji, this.label, this.time, this.color, this.dark);
  @override
  Widget build(BuildContext context) => Column(children: [
    Text(emoji, style: const TextStyle(fontSize: 30)),
    const SizedBox(height: 6),
    Text(label, textAlign: TextAlign.center,
        style: GoogleFonts.outfit(
            color: AppTheme.textSecondary(dark), fontSize: 11)),
    const SizedBox(height: 4),
    Text(time, style: GoogleFonts.outfit(
        color: color, fontSize: 20, fontWeight: FontWeight.w700)),
  ]);
}