import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/weather_city.dart';
import '../theme/app_theme.dart';
import 'glass_card.dart';


class HeroCard extends StatelessWidget {
  final WeatherCity city; final bool dark;
  const HeroCard({super.key, required this.city, required this.dark});

  @override
  Widget build(BuildContext context) => GlassCard(
    radius: 26, padding: const EdgeInsets.all(28),
    child: Column(children: [
      Text(city.emoji, style: const TextStyle(fontSize: 72))
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .moveY(begin: -6, end: 6,
          duration: const Duration(milliseconds: 3000),
          curve: Curves.easeInOut),
      const SizedBox(height: 20),
      Row(mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(city.temperature.toStringAsFixed(0), style: GoogleFonts.outfit(
                color: AppTheme.textPrimary(dark),
                fontSize: 80, fontWeight: FontWeight.w800, height: 0.9)),
            Padding(padding: const EdgeInsets.only(top: 10),
                child: Text('° C', style: GoogleFonts.outfit(
                    color: AppTheme.textSecondary(dark), fontSize: 24))),
          ]),
      const SizedBox(height: 10),
      Text(city.conditionFr, style: GoogleFonts.outfit(
          color: AppTheme.textPrimary(dark),
          fontSize: 20, fontWeight: FontWeight.w600)),
      const SizedBox(height: 4),
      Text('Ressenti ${city.feelsLike.toStringAsFixed(0)}°C',
          style: GoogleFonts.outfit(
              color: AppTheme.textSecondary(dark), fontSize: 14)),
    ]),
  );
}