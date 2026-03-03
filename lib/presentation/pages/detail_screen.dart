// ============================================================
//  pages/detail_screen.dart  —  PAGE 4 : Détail ville
// ============================================================

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/weather_city.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_bg.dart';
import '../widgets/glass_card.dart';

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
          _Header(city: city, dark: dark),
          Expanded(child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [
              const SizedBox(height: 20),

              _HeroCard(city: city, dark: dark)
                  .animate().fadeIn(duration: 600.ms).slideY(begin: 0.1),
              const SizedBox(height: 22),

              _SectionLabel('Détails météo', dark),
              const SizedBox(height: 12),
              _DetailsGrid(city: city, dark: dark),
              const SizedBox(height: 22),

              _SunCard(city: city, dark: dark)
                  .animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
              const SizedBox(height: 22),

              _SectionLabel('Localisation', dark),
              const SizedBox(height: 12),
              _MapCard(city: city, dark: dark)
                  .animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
              const SizedBox(height: 22),

              _UVCard(city: city, dark: dark)
                  .animate().fadeIn(delay: 500.ms).slideY(begin: 0.1),
              const SizedBox(height: 36),
            ]),
          )),
        ])),
      ),
    );
  }
}

// ── En-tête ──────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final WeatherCity city; final bool dark;
  const _Header({required this.city, required this.dark});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(8, 12, 20, 12),
    decoration: BoxDecoration(border: Border(bottom: BorderSide(
        color: Colors.white.withOpacity(dark ? 0.08 : 0.4)))),
    child: Row(children: [
      IconButton(
        icon: Icon(Icons.arrow_back_ios_rounded,
            color: AppTheme.textPrimary(dark), size: 20),
        onPressed: () => Navigator.of(context).pop()),
      Expanded(child: Column(children: [
        Text(city.city, textAlign: TextAlign.center,
          style: GoogleFonts.outfit(color: AppTheme.textPrimary(dark),
              fontSize: 18, fontWeight: FontWeight.w800)),
        Text(city.country, textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
              color: AppTheme.textSecondary(dark), fontSize: 12)),
      ])),
      const SizedBox(width: 40),
    ]),
  );
}

// ── Carte héro ────────────────────────────────────────────────

class _HeroCard extends StatelessWidget {
  final WeatherCity city; final bool dark;
  const _HeroCard({required this.city, required this.dark});

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

// ── Grille 4 détails ─────────────────────────────────────────

class _DetailsGrid extends StatelessWidget {
  final WeatherCity city; final bool dark;
  const _DetailsGrid({required this.city, required this.dark});

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

// ── Lever / coucher du soleil ─────────────────────────────────

class _SunCard extends StatelessWidget {
  final WeatherCity city; final bool dark;
  const _SunCard({required this.city, required this.dark});

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

// ── Carte localisation ────────────────────────────────────────

class _MapCard extends StatelessWidget {
  final WeatherCity city; final bool dark;
  const _MapCard({required this.city, required this.dark});

  Future<void> _openMaps() async {
    final url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${city.lat},${city.lon}');
    if (await canLaunchUrl(url)) await launchUrl(url);
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: _openMaps,
    child: GlassCard(radius: 22, padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Column(children: [
          Container(height: 150,
            decoration: BoxDecoration(gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: dark
                  ? [const Color(0xFF1A1B4B), const Color(0xFF0D0E2A)]
                  : [const Color(0xFFD6C8FF), const Color(0xFFB899FF)])),
            child: Stack(children: [
              CustomPaint(size: const Size(double.infinity, 150),
                  painter: _GridPainter(dark: dark)),
              Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: AppTheme.cIndigo.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: AppTheme.cIndigo.withOpacity(0.55),
                        blurRadius: 22, spreadRadius: 6)]),
                  child: const Icon(Icons.location_on_rounded,
                      color: Colors.white, size: 24)),
                _PulseRing(),
              ])),
              Positioned(bottom: 8, right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.cIndigo.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(8)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.open_in_new, color: Colors.white, size: 12),
                    const SizedBox(width: 4),
                    Text('Google Maps', style: GoogleFonts.outfit(
                        color: Colors.white, fontSize: 10,
                        fontWeight: FontWeight.w600)),
                  ]))),
            ])),
          Padding(padding: const EdgeInsets.all(16),
            child: Column(children: [
              Text('Coordonnées', style: GoogleFonts.outfit(
                  color: AppTheme.textSecondary(dark), fontSize: 12)),
              const SizedBox(height: 4),
              Text('${city.lat.toStringAsFixed(4)}°,  ${city.lon.toStringAsFixed(4)}°',
                style: GoogleFonts.outfit(color: AppTheme.textPrimary(dark),
                    fontSize: 16, fontWeight: FontWeight.w700)),
            ])),
        ]),
      )),
  );
}

class _GridPainter extends CustomPainter {
  final bool dark;
  const _GridPainter({required this.dark});
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = (dark ? Colors.white : Colors.purple).withOpacity(0.07)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 24)
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    for (double y = 0; y < size.height; y += 24)
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
  }
  @override bool shouldRepaint(_) => false;
}

class _PulseRing extends StatefulWidget {
  @override State<_PulseRing> createState() => _PulseRingState();
}

class _PulseRingState extends State<_PulseRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this,
        duration: const Duration(seconds: 2))..repeat();
  }
  @override void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _c,
    builder: (_, __) => Transform.scale(
      scale: 1.0 + _c.value * 1.5,
      child: Opacity(
        opacity: (1.0 - _c.value).clamp(0.0, 0.5),
        child: Container(width: 32, height: 32,
          decoration: BoxDecoration(shape: BoxShape.circle,
            border: Border.all(color: AppTheme.cIndigo, width: 1.5))),
      )),
  );
}

// ── Indice UV ─────────────────────────────────────────────────

class _UVCard extends StatelessWidget {
  final WeatherCity city; final bool dark;
  const _UVCard({required this.city, required this.dark});

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

// ── Label de section ──────────────────────────────────────────

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
