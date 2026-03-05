
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/weather_city.dart';
import '../providers/theme_provider.dart';
import '../providers/weather_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_bg.dart';
import '../widgets/glass_card.dart';
import 'detail_screen.dart';
import 'home_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tp   = context.watch<ThemeProvider>();
    final wp   = context.watch<WeatherProvider>();
    final dark = tp.isDark;

    final rawDate = DateFormat('EEEE d MMMM yyyy', 'fr_FR').format(DateTime.now());
    final date = rawDate[0].toUpperCase() + rawDate.substring(1);

    final avgTemp = wp.cities.isEmpty ? 0.0
        : wp.cities.map((c) => c.temperature).reduce((a, b) => a + b) / wp.cities.length;
    final avgHum = wp.cities.isEmpty ? 0
        : (wp.cities.map((c) => c.humidity).reduce((a, b) => a + b) / wp.cities.length).round();

    return Scaffold(
      body: AnimatedBg(
        isDark: dark,
        child: SafeArea(child: Column(children: [
          _Header(dark: dark, date: date, tp: tp),
          Expanded(child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _SummaryBanner(dark: dark,
                  nbCities: wp.cities.length,
                  avgTemp: avgTemp,
                  avgHum: avgHum)
                  .animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),

              const SizedBox(height: 28),

              Text('Emplacements de Vos',
                style: GoogleFonts.outfit(color: AppTheme.textPrimary(dark),
                    fontSize: 17, fontWeight: FontWeight.w700),
              ).animate().fadeIn(delay: 200.ms),

              const SizedBox(height: 14),

              ...wp.cities.asMap().entries.map((e) => _CityCard(
                city: e.value, dark: dark,
                delay: Duration(milliseconds: 300 + e.key * 120))),

              const SizedBox(height: 28),

              _RestartBtn(dark: dark).animate().fadeIn(delay: 900.ms),
            ]),
          )),
        ])),
      ),
    );
  }
}

// ── En-tête ──────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final bool dark; final String date; final ThemeProvider tp;
  const _Header({required this.dark, required this.date, required this.tp});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
    decoration: BoxDecoration(border: Border(bottom: BorderSide(
        color: Colors.white.withOpacity(dark ? 0.08 : 0.4)))),
    child: Row(children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tableau de bord météo', style: GoogleFonts.outfit(
              color: AppTheme.textPrimary(dark),
              fontSize: 18, fontWeight: FontWeight.w800)),
          Text(date, style: GoogleFonts.outfit(
              color: AppTheme.textSecondary(dark), fontSize: 12)),
        ])),
      GestureDetector(onTap: tp.toggle,
        child: GlassCard(padding: const EdgeInsets.all(10), radius: 50,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Icon(dark ? Icons.wb_sunny_rounded : Icons.dark_mode_rounded,
              key: ValueKey(dark),
              color: dark ? AppTheme.cYellow : AppTheme.cIndigo, size: 20)))),
    ]),
  );
}

// ── Bannière résumé ───────────────────────────────────────────

class _SummaryBanner extends StatelessWidget {
  final bool dark; final int nbCities, avgHum; final double avgTemp;
  const _SummaryBanner({required this.dark, required this.nbCities,
    required this.avgTemp, required this.avgHum});

  @override
  Widget build(BuildContext context) => GlassCard(
    radius: 22, padding: const EdgeInsets.all(22),
    child: Row(children: [
      _Stat('$nbCities', 'Villes', dark),
      Container(width: 1, height: 38,
          color: Colors.white.withOpacity(0.12), margin: const EdgeInsets.symmetric(horizontal: 4)),
      _Stat('${avgTemp.toStringAsFixed(0)}°', 'Température', dark),
      Container(width: 1, height: 38,
          color: Colors.white.withOpacity(0.12), margin: const EdgeInsets.symmetric(horizontal: 4)),
      _Stat('$avgHum%', 'Humidité', dark),
    ]),
  );
}

class _Stat extends StatelessWidget {
  final String value, label; final bool dark;
  const _Stat(this.value, this.label, this.dark);
  @override
  Widget build(BuildContext context) => Expanded(child: Column(children: [
    Text(value, style: GoogleFonts.outfit(color: AppTheme.textPrimary(dark),
        fontSize: 24, fontWeight: FontWeight.w800)),
    Text(label, style: GoogleFonts.outfit(
        color: AppTheme.textSecondary(dark), fontSize: 11)),
  ]));
}

// ── Carte ville ───────────────────────────────────────────────

class _CityCard extends StatelessWidget {
  final WeatherCity city; final bool dark; final Duration delay;
  const _CityCard({required this.city, required this.dark, required this.delay});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: GlassCard(
      radius: 22,
      onTap: () => Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (_, a, __) => DetailScreen(city: city),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      )),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(city.city, style: GoogleFonts.outfit(
                  color: AppTheme.textPrimary(dark),
                  fontSize: 19, fontWeight: FontWeight.w700)),
              Text(city.country, style: GoogleFonts.outfit(
                  color: AppTheme.textSecondary(dark), fontSize: 12)),
            ])),
          Text(city.emoji, style: const TextStyle(fontSize: 38)),
        ]),
        const SizedBox(height: 14),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${city.temperature.toStringAsFixed(0)}°',
            style: GoogleFonts.outfit(color: AppTheme.textPrimary(dark),
                fontSize: 44, fontWeight: FontWeight.w800, height: 1)),
          Padding(padding: const EdgeInsets.only(top: 6),
            child: Text(' C', style: GoogleFonts.outfit(
                color: AppTheme.textSecondary(dark), fontSize: 20))),
        ]),
        const SizedBox(height: 6),
        Text(city.conditionFr, style: GoogleFonts.outfit(
            color: AppTheme.textSecondary(dark), fontSize: 14)),
        const SizedBox(height: 14),
        Row(children: [
          _MiniStat(Icons.water_drop_outlined, '${city.humidity}%', AppTheme.cBlue),
          const SizedBox(width: 18),
          _MiniStat(Icons.air_rounded, '${city.windSpeed.toStringAsFixed(0)} km/h', AppTheme.cCyan),
        ]),
      ]),
    ),
  ).animate().fadeIn(delay: delay, duration: 500.ms).slideY(begin: 0.15);
}

class _MiniStat extends StatelessWidget {
  final IconData icon; final String val; final Color color;
  const _MiniStat(this.icon, this.val, this.color);
  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Row(children: [
      Icon(icon, color: color, size: 15),
      const SizedBox(width: 5),
      Text(val, style: GoogleFonts.outfit(
          color: AppTheme.textSecondary(dark),
          fontSize: 13, fontWeight: FontWeight.w500)),
    ]);
  }
}

// ── Bouton Recommencer ────────────────────────────────────────

class _RestartBtn extends StatelessWidget {
  final bool dark;
  const _RestartBtn({required this.dark});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () {
      context.read<WeatherProvider>().reset();
      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (_, a, __) => const HomeScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 600),
        ),
        (_) => false,
      );
    },
    child: Container(
      width: double.infinity, height: 56,
      decoration: BoxDecoration(
        gradient: AppTheme.gradPurple,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: AppTheme.cIndigo.withOpacity(0.45),
            blurRadius: 24, offset: const Offset(0, 10))]),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.refresh_rounded, color: Colors.white, size: 22),
        const SizedBox(width: 10),
        Text('Recommencer', style: GoogleFonts.outfit(
            color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
      ]),
    ),
  );
}
