import 'package:flutter/material.dart';
import 'package:weather_app/presentation/theme/app_theme.dart';

class LinearBar extends StatelessWidget {
  final double progress;
   final bool done;
  const LinearBar({required this.progress, required this.done});

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
