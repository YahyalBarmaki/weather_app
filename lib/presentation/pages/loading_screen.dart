// ============================================================
// ============================================================

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../providers/weather_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_bg.dart';
import '../widgets/glass_card.dart';
import 'dashboard_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});
  @override State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _dotsCtrl;

  @override
  void initState() {
    super.initState();
    _dotsCtrl = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 700))..repeat(reverse: true);
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  void _start() {
    final wp = context.read<WeatherProvider>();
    wp.addListener(_onUpdate);
    wp.loadWeather();
  }

  void _onUpdate() {
    final wp = context.read<WeatherProvider>();
    if (wp.state == LoadingState.success || wp.state == LoadingState.error) {
      wp.removeListener(_onUpdate);
      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    try { context.read<WeatherProvider>().removeListener(_onUpdate); } catch (_) {}
    _dotsCtrl.dispose();
    super.dispose();
  }

  void _goToDashboard() => Navigator.of(context).pushReplacement(PageRouteBuilder(
    pageBuilder: (_, a, __) => const DashboardScreen(),
    transitionsBuilder: (_, anim, __, child) =>
        FadeTransition(opacity: anim, child: child),
    transitionDuration: const Duration(milliseconds: 700),
  ));

  void _retry() {
    final wp = context.read<WeatherProvider>();
    wp.addListener(_onUpdate);
    wp.loadWeather();
  }

  @override
  Widget build(BuildContext context) {
    final dark = context.watch<ThemeProvider>().isDark;
    final wp   = context.watch<WeatherProvider>();
    final done = wp.state == LoadingState.success;
    final err  = wp.state == LoadingState.error;
    final pct  = (wp.progress * 100).round();

    return Scaffold(
      body: AnimatedBg(
        isDark: dark,
        child: SafeArea(
          child: Center(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 44),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _CircleGauge(progress: wp.progress, pct: pct, dark: dark,
                    done: done, onTap: done ? _goToDashboard : null)
                    .animate().fadeIn(duration: 600.ms)
                    .scale(begin: const Offset(0.75, 0.75)),

                const SizedBox(height: 52),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: Text(
                    err  ? '❌  ${wp.errorMessage}'
                         : done ? '✅  Données chargées avec succès !'
                                : wp.currentMessage,
                    key: ValueKey(err ? 'e' : done ? 'd' : wp.loadedCount),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      color: err  ? Colors.redAccent
                                  : done ? AppTheme.cGreen
                                         : AppTheme.textPrimary(dark),
                      fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),

                const SizedBox(height: 22),
                if (!done && !err) _BounceDots(ctrl: _dotsCtrl),
                const SizedBox(height: 44),

                _LinearBar(progress: wp.progress, done: done),
                const SizedBox(height: 36),

                if (done)
                  _ResultButton(onTap: _goToDashboard)
                      .animate().fadeIn(duration: 500.ms).slideY(begin: 0.3),
                if (err)
                  _RetryButton(dark: dark, onTap: _retry)
                      .animate().fadeIn().slideY(begin: 0.3),
              ],
            ),
          )),
        ),
      ),
    );
  }
}

// ── Jauge circulaire ─────────────────────────────────────────

class _CircleGauge extends StatelessWidget {
  final double progress; final int pct;
  final bool dark, done; final VoidCallback? onTap;
  const _CircleGauge({required this.progress, required this.pct,
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
            painter: _ArcPainter(progress: progress, done: done)),
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

class _ArcPainter extends CustomPainter {
  final double progress; final bool done;
  const _ArcPainter({required this.progress, required this.done});

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

  @override bool shouldRepaint(_ArcPainter o) =>
      o.progress != progress || o.done != done;
}

// ── Points bounce ────────────────────────────────────────────

class _BounceDots extends StatelessWidget {
  final AnimationController ctrl;
  const _BounceDots({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final colors = [AppTheme.cIndigo, AppTheme.cCyan, AppTheme.cViolet];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) => AnimatedBuilder(
        animation: ctrl,
        builder: (_, __) => Transform.scale(
          scale: 0.6 + 0.8 * sin(((ctrl.value + i * 0.33) % 1.0) * pi),
          child: Container(width: 9, height: 9,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(shape: BoxShape.circle, color: colors[i])),
        ),
      )),
    );
  }
}

// ── Barre linéaire ────────────────────────────────────────────

class _LinearBar extends StatelessWidget {
  final double progress; final bool done;
  const _LinearBar({required this.progress, required this.done});

  @override
  Widget build(BuildContext context) => Stack(children: [
    Container(height: 7, decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      color: Colors.white.withOpacity(0.10))),
    AnimatedFractionallySizedBox(
      duration: const Duration(milliseconds: 450),
      widthFactor: progress,
      child: Container(height: 7, decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        gradient: done ? AppTheme.gradGreen : AppTheme.gradCyan,
        boxShadow: [BoxShadow(
          color: (done ? AppTheme.cGreen : AppTheme.cCyan).withOpacity(0.55),
          blurRadius: 10)]))),
  ]);
}

// ── Bouton Voir les résultats ─────────────────────────────────

class _ResultButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ResultButton({required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity, height: 56,
      decoration: BoxDecoration(
        gradient: AppTheme.gradGreen,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: AppTheme.cGreen.withOpacity(0.45),
            blurRadius: 24, offset: const Offset(0, 10))]),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.dashboard_rounded, color: Colors.white, size: 22),
        const SizedBox(width: 10),
        Text('Voir les résultats  🎉', style: GoogleFonts.outfit(
            color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
      ]),
    ),
  );
}

// ── Bouton Réessayer ──────────────────────────────────────────

class _RetryButton extends StatelessWidget {
  final bool dark; final VoidCallback onTap;
  const _RetryButton({required this.dark, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 15),
      decoration: BoxDecoration(
        gradient: AppTheme.gradPurple,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppTheme.cIndigo.withOpacity(0.45),
            blurRadius: 22, offset: const Offset(0, 8))]),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.refresh_rounded, color: Colors.white, size: 20),
        const SizedBox(width: 10),
        Text('Réessayer', style: GoogleFonts.outfit(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
      ]),
    ),
  );
}
