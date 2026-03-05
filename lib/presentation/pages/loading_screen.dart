// ============================================================
// ============================================================

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/presentation/pages/boune_dot.dart';
import 'package:weather_app/presentation/pages/circle_gauge.dart';
import 'package:weather_app/presentation/pages/linear_bar.dart';
import 'package:weather_app/presentation/pages/result_button.dart';
import 'package:weather_app/presentation/pages/retry_button.dart';

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
                CircleGauge(progress: wp.progress, pct: pct, dark: dark,
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
                if (!done && !err) BounceDots(ctrl: _dotsCtrl),
                const SizedBox(height: 44),

                LinearBar(progress: wp.progress, done: done),
                const SizedBox(height: 36),

                if (done)
                  ResultButton(onTap: _goToDashboard)
                      .animate().fadeIn(duration: 500.ms).slideY(begin: 0.3),
                if (err)
                  RetryButton(dark: dark, onTap: _retry)
                      .animate().fadeIn().slideY(begin: 0.3),
              ],
            ),
          )),
        ),
      ),
    );
  }
}