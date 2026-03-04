import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/weather_city.dart';
import '../theme/app_theme.dart';
import 'glass_card.dart';

class MapCard extends StatelessWidget {
  final WeatherCity city; final bool dark;
  const MapCard({super.key, required this.city, required this.dark});

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