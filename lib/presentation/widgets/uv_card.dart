import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/weather_city.dart';
import '../theme/app_theme.dart';
import 'glass_card.dart';

class UVCard extends StatelessWidget {
  final WeatherCity city; final bool dark;
  const UVCard({super.key, required this.city, required this.dark});

  @override
  Widget build(BuildContext context) {
    final uv       = DateTime.now().hour % 11;
    final progress = (uv / 11).clamp(0.0, 1.0);
    const labels   = ['Faible', 'Faible', 'Faible', 'Modéré', 'Modéré',
      'Modéré', 'Élevé', 'Élevé', 'Très élevé', 'Très élevé',
      'Très élevé', 'Extrême'];

    return GlassCard(
      radius: 22, padding: const EdgeInsets.all(22),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text('Indice UV', style: GoogleFonts.outfit(
              color: AppTheme.textSecondary(dark),
              fontSize: 13, fontWeight: FontWeight.w600)),
          const Spacer(),
          Text('$uv', style: GoogleFonts.outfit(
              color: AppTheme.textPrimary(dark),
              fontSize: 26, fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(height: 16),
        Stack(children: [
          Container(height: 8, decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: const LinearGradient(colors: [
                Color(0xFF00E676), Color(0xFFFFEB3B),
                Color(0xFFFF9800), Color(0xFFF44336), Color(0xFF9C27B0),
              ]))),
          FractionallySizedBox(
              widthFactor: progress.clamp(0.05, 0.95),
              alignment: Alignment.centerLeft,
              child: Align(alignment: Alignment.centerRight,
                  child: Container(width: 15, height: 15,
                      decoration: BoxDecoration(color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(
                              color: Colors.black.withOpacity(0.3), blurRadius: 4)])))),
        ]),
        const SizedBox(height: 10),
        Text('${labels[uv]} - Protection ${uv < 3 ? "non requise" : "recommandée"}',
            style: GoogleFonts.outfit(
                color: AppTheme.textSecondary(dark), fontSize: 12)),
      ]),
    );
  }
}