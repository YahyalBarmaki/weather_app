import 'dart:math';

import 'package:flutter/material.dart';
import 'package:weather_app/presentation/theme/app_theme.dart';

class BounceDots extends StatelessWidget {
  final AnimationController ctrl;
  const BounceDots({required this.ctrl});

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
