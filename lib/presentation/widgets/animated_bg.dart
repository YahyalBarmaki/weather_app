// ============================================================
//  widgets/animated_bg.dart  —  Fond animé
//  Orbes flottants + étoiles scintillantes (dark mode)
// ============================================================

import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AnimatedBg extends StatefulWidget {
  final Widget child;
  final bool isDark;
  const AnimatedBg({super.key, required this.child, required this.isDark});

  @override
  State<AnimatedBg> createState() => _AnimatedBgState();
}

class _AnimatedBgState extends State<AnimatedBg>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(seconds: 10))
      ..repeat(reverse: true);
  }

  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) => Stack(children: [
        // Fond dégradé
        Container(decoration: BoxDecoration(
            gradient: AppTheme.bgGradient(widget.isDark))),
        // Orbe 1
        Positioned(top: -120 + _c.value * 80, left: -80 + _c.value * 60,
          child: _Orb(360, widget.isDark
              ? const Color(0xFF3D1D8C).withOpacity(0.45)
              : const Color(0xFF9B59B6).withOpacity(0.25))),
        // Orbe 2
        Positioned(top: 250 - _c.value * 60, right: -100 + _c.value * 40,
          child: _Orb(300, widget.isDark
              ? const Color(0xFF1A0A4A).withOpacity(0.50)
              : const Color(0xFF6C63FF).withOpacity(0.20))),
        // Orbe 3
        Positioned(bottom: 60 + _c.value * 50, left: 40 + _c.value * 30,
          child: _Orb(220, widget.isDark
              ? const Color(0xFF0A1A5A).withOpacity(0.40)
              : const Color(0xFFFF79C6).withOpacity(0.20))),
        // Étoiles (dark seulement)
        if (widget.isDark)
          ...List.generate(30, (i) =>
              _Star(i, _c, size)),
        widget.child,
      ]),
    );
  }
}

class _Orb extends StatelessWidget {
  final double size; final Color color;
  const _Orb(this.size, this.color);
  @override
  Widget build(BuildContext context) => Container(
    width: size, height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: RadialGradient(colors: [color, Colors.transparent])));
}

class _Star extends StatelessWidget {
  final int i; final Animation<double> a; final Size s;
  const _Star(this.i, this.a, this.s);
  @override
  Widget build(BuildContext context) {
    final r  = Random(i * 13 + 7);
    final op = (0.3 + r.nextDouble() * 0.5) *
        (0.5 + 0.5 * sin(a.value * pi * 2 + i));
    final sz = r.nextDouble() * 1.5 + 0.5;
    return Positioned(
      left: r.nextDouble() * s.width,
      top:  r.nextDouble() * s.height * 0.75,
      child: Container(width: sz, height: sz,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(op))),
    );
  }
}