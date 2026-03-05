import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/presentation/theme/app_theme.dart';

class ResultButton extends StatelessWidget {
  final VoidCallback onTap;
  const ResultButton({required this.onTap});

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