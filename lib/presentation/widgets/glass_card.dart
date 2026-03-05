// ============================================================
//  widgets/glass_card.dart  —  Carte glassmorphism
// ============================================================

import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double   radius;
  final double?  width, height;
  final Color?   color, border;
  final Gradient? gradient;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.radius  = 20,
    this.width,   this.height,
    this.color,   this.border,
    this.gradient,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    Widget card = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: width, height: height,
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient:     gradient,
            color:        color  ?? AppTheme.cardBg(dark),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: border ?? AppTheme.cardBorder(dark), width: 1),
            boxShadow: [BoxShadow(
              color: Colors.black.withOpacity(dark ? 0.28 : 0.08),
              blurRadius: 20, offset: const Offset(0, 8),
            )],
          ),
          child: child,
        ),
      ),
    );
    return onTap != null
        ? GestureDetector(onTap: onTap, child: card)
        : card;
  }
}