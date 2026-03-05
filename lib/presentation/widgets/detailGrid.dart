import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/weather_city.dart';
import '../theme/app_theme.dart';
import 'glass_card.dart';

class DetailsGrid extends StatelessWidget {
  final WeatherCity city; final bool dark;
  const DetailsGrid({super.key, required this.city, required this.dark});

  @override
  Widget build(BuildContext context) {
    final items = [
      _DItem(Icons.water_drop_outlined, 'Humidité',
          '${city.humidity}%', AppTheme.cBlue),
      _DItem(Icons.air_rounded, 'Vitesse du vent',
          '${city.windSpeed.toStringAsFixed(0)} km/h', AppTheme.cCyan),
      _DItem(Icons.speed_rounded, 'Pression',
          '${city.pressure} hPa', AppTheme.cViolet),
      _DItem(Icons.visibility_rounded, 'Visibilité',
          '${city.visibility} km', AppTheme.cGreen),
    ];
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12, crossAxisSpacing: 12,
      childAspectRatio: 1.65,
      children: items.asMap().entries.map((e) =>
          GlassCard(radius: 18, padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(e.value.icon, color: e.value.color, size: 22),
                  const SizedBox(height: 2),
                  Text(e.value.label, style: GoogleFonts.outfit(
                      color: AppTheme.textSecondary(dark),
                      fontSize: 11, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 3),
                  Text(e.value.val, style: GoogleFonts.outfit(
                      color: AppTheme.textPrimary(dark),
                      fontSize: 19, fontWeight: FontWeight.w700)),
                ]),
          ).animate().fadeIn(delay: Duration(milliseconds: 200 + e.key * 80))
              .slideY(begin: 0.1),
      ).toList(),
    );
  }
}

class _DItem {
  final IconData icon; final String label, val; final Color color;
  const _DItem(this.icon, this.label, this.val, this.color);
}