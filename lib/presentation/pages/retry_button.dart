import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/presentation/theme/app_theme.dart';

class RetryButton extends StatelessWidget {
  final bool dark;
   final VoidCallback onTap;
  const RetryButton({required this.dark, required this.onTap});

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