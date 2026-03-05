// ============================================================
//  pages/detail_screen.dart  —  PAGE 4 : Détail ville
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/weather_city.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_bg.dart';
import '../widgets/detailGrid.dart';
import '../widgets/header.dart';
import '../widgets/hero_card.dart';
import '../widgets/map_card.dart';
import '../widgets/sun_card.dart';
import '../widgets/uv_card.dart';

class DetailScreen extends StatelessWidget {
  final WeatherCity city;
  const DetailScreen({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    final dark = context.watch<ThemeProvider>().isDark;

    return Scaffold(
      body: AnimatedBg(
        isDark: dark,
        child: SafeArea(child: Column(children: [
          Header(city: city, dark: dark),
          Expanded(child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [
              const SizedBox(height: 20),

              HeroCard(city: city, dark: dark)
                  .animate().fadeIn(duration: 600.ms).slideY(begin: 0.1),
              const SizedBox(height: 22),

              _SectionLabel('Détails météo', dark),
              const SizedBox(height: 12),
              DetailsGrid(city: city, dark: dark),
              const SizedBox(height: 22),

              SunCard(city: city, dark: dark)
                  .animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
              const SizedBox(height: 22),

              _SectionLabel('Localisation', dark),
              const SizedBox(height: 12),
              MapCard(city: city, dark: dark)
                  .animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
              const SizedBox(height: 22),

              UVCard(city: city, dark: dark)
                  .animate().fadeIn(delay: 500.ms).slideY(begin: 0.1),
              const SizedBox(height: 36),
            ]),
          )),
        ])),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text; final bool dark;
  const _SectionLabel(this.text, this.dark);
  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: Text(text, style: GoogleFonts.outfit(
        color: AppTheme.textPrimary(dark),
        fontSize: 17, fontWeight: FontWeight.w700)));
}