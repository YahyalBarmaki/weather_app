import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_bg.dart';
import '../widgets/glass_card.dart';
import 'loading_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tp   = context.watch<ThemeProvider>();
    final dark = tp.isDark;

    return Scaffold(
      body: AnimatedBg(
        isDark: dark,
        child: SafeArea(
          child: Stack(children: [
            // Toggle thème
            Positioned(top: 12, right: 16,
              child: _ThemeToggle(dark: dark, tp: tp)
                  .animate().fadeIn(delay: 800.ms)),

            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _Logo(dark: dark)
                        .animate()
                        .fadeIn(duration: 800.ms)
                        .scale(begin: const Offset(0.6, 0.6)),

                    const SizedBox(height: 36),

                    Text('WeatherLux',
                      style: GoogleFonts.outfit(
                        color: AppTheme.textPrimary(dark),
                        fontSize: 40, fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),

                    const SizedBox(height: 14),

                    _Taglines(dark: dark)
                        .animate().fadeIn(delay: 500.ms),

                    const SizedBox(height: 64),

                    _StartButton(dark: dark)
                        .animate().fadeIn(delay: 700.ms).slideY(begin: 0.3),

                    const SizedBox(height: 36),

                    _AnimatedDots(dark: dark)
                        .animate().fadeIn(delay: 900.ms),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

// ── Toggle Dark/Light ────────────────────────────────────────

class _ThemeToggle extends StatelessWidget {
  final bool dark; final ThemeProvider tp;
  const _ThemeToggle({required this.dark, required this.tp});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: tp.toggle,
    child: GlassCard(
      padding: const EdgeInsets.all(10), radius: 50,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Icon(
          dark ? Icons.wb_sunny_rounded : Icons.dark_mode_rounded,
          key: ValueKey(dark),
          color: dark ? AppTheme.cYellow : AppTheme.cIndigo, size: 22,
        ),
      ),
    ),
  );
}

// ── Logo pulsant ─────────────────────────────────────────────

class _Logo extends StatefulWidget {
  final bool dark;
  const _Logo({required this.dark});
  @override State<_Logo> createState() => _LogoState();
}

class _LogoState extends State<_Logo> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double>   _pulse;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this,
        duration: const Duration(seconds: 2))..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.93, end: 1.07).animate(
        CurvedAnimation(parent: _c, curve: Curves.easeInOut));
  }

  @override void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _pulse,
    builder: (_, child) => Transform.scale(scale: _pulse.value, child: child),
    child: Container(
      width: 120, height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: widget.dark
            ? const RadialGradient(colors: [Color(0xFF3D2A7A), Color(0xFF1A1B4B)])
            : const RadialGradient(colors: [Color(0xFFB899FF), Color(0xFF9B59B6)]),
        boxShadow: [BoxShadow(color: AppTheme.cIndigo.withOpacity(0.55),
            blurRadius: 35, spreadRadius: 8)],
      ),
      child: const Center(child: Icon(Icons.auto_awesome_rounded,
          color: Colors.white, size: 52)),
    ),
  );
}

// ── Taglines rotatifs ─────────────────────────────────────────

class _Taglines extends StatefulWidget {
  final bool dark;
  const _Taglines({required this.dark});
  @override State<_Taglines> createState() => _TaglinesState();
}

class _TaglinesState extends State<_Taglines> {
  static const _lines = [
    'Chaque jour apporte un nouveau temps,\nde nouvelles opportunités',
    'Des prévisions météo pour un meilleur\ndemain',
    'La météo en temps réel,\npour vous préparer au mieux',
  ];
  int _i = 0;

  @override
  void initState() { super.initState(); _next(); }

  void _next() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() => _i = (_i + 1) % _lines.length);
      _next();
    });
  }

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
    duration: const Duration(milliseconds: 500),
    child: Text(_lines[_i], key: ValueKey(_i), textAlign: TextAlign.center,
      style: GoogleFonts.outfit(color: AppTheme.textSecondary(widget.dark),
          fontSize: 15, height: 1.55)),
  );
}

// ── Bouton Commencer ──────────────────────────────────────────

class _StartButton extends StatefulWidget {
  final bool dark;
  const _StartButton({required this.dark});
  @override State<_StartButton> createState() => _StartButtonState();
}

class _StartButtonState extends State<_StartButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTapDown:   (_) => setState(() => _pressed = true),
    onTapCancel: ()  => setState(() => _pressed = false),
    onTapUp: (_) {
      setState(() => _pressed = false);
      Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: (_, a, __) => const LoadingScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 600),
      ));
    },
    child: AnimatedScale(
      scale: _pressed ? 0.96 : 1.0,
      duration: const Duration(milliseconds: 120),
      child: Container(
        width: double.infinity, height: 58,
        decoration: BoxDecoration(
          color: widget.dark
              ? Colors.white.withOpacity(0.10)
              : Colors.white.withOpacity(0.78),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: widget.dark
                ? Colors.white.withOpacity(0.18)
                : Colors.white.withOpacity(0.95)),
          boxShadow: [BoxShadow(color: AppTheme.cIndigo.withOpacity(0.35),
              blurRadius: 24, offset: const Offset(0, 10))],
        ),
        child: Center(child: Text('Commencer l\'expérience',
          style: GoogleFonts.outfit(
            color: widget.dark ? AppTheme.cCyan : AppTheme.cIndigo,
            fontSize: 17, fontWeight: FontWeight.w600))),
      ),
    ),
  );
}

// ── 3 points animés ───────────────────────────────────────────

class _AnimatedDots extends StatefulWidget {
  final bool dark;
  const _AnimatedDots({required this.dark});
  @override State<_AnimatedDots> createState() => _AnimatedDotsState();
}

class _AnimatedDotsState extends State<_AnimatedDots>
    with TickerProviderStateMixin {
  late final AnimationController _pulse;
  late final AnimationController _seq;
  late final Animation<double>   _pulseAnim;
  int _active = 0;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 700))..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.3).animate(
        CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));

    _seq = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 1200))
      ..addStatusListener((s) {
        if (s == AnimationStatus.completed) {
          if (mounted) setState(() => _active = (_active + 1) % 3);
          _seq.forward(from: 0);
        }
      });
    _seq.forward();
  }

  @override
  void dispose() { _pulse.dispose(); _seq.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(3, (i) {
      final isActive = i == _active;
      return AnimatedBuilder(
        animation: _pulse,
        builder: (_, __) => Transform.scale(
          scale: isActive ? _pulseAnim.value : 1.0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOut,
            width: isActive ? 26 : 8, height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: isActive
                  ? (widget.dark ? AppTheme.cIndigo : AppTheme.cViolet)
                  : Colors.white.withOpacity(widget.dark ? 0.28 : 0.45),
              boxShadow: isActive ? [BoxShadow(
                color: (widget.dark ? AppTheme.cIndigo : AppTheme.cViolet)
                    .withOpacity(0.6),
                blurRadius: 8, spreadRadius: 1,
              )] : null,
            ),
          ),
        ),
      );
    }),
  );
}