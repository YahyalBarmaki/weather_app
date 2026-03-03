// ============================================================
//  theme/app_theme.dart  —  Système de design complet
//  Couleurs · Dégradés · ThemeData dark & light
// ============================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // ── Palette ────────────────────────────────────────────────
  static const Color cIndigo = Color(0xFF6C63FF);
  static const Color cPurple = Color(0xFF7B5EA7);
  static const Color cCyan   = Color(0xFF00E5FF);
  static const Color cBlue   = Color(0xFF4FC3F7);
  static const Color cGreen  = Color(0xFF00E676);
  static const Color cOrange = Color(0xFFFF7043);
  static const Color cYellow = Color(0xFFFDD835);
  static const Color cViolet = Color(0xFF9B59B6);
  static const Color cPink   = Color(0xFFE040FB);

  // ── Dégradés ───────────────────────────────────────────────
  static const Gradient gradPurple = LinearGradient(
      colors: [Color(0xFF7B5EA7), Color(0xFF6C63FF)]);
  static const Gradient gradCyan = LinearGradient(
      colors: [Color(0xFF00E5FF), Color(0xFF6C63FF)]);
  static const Gradient gradGreen = LinearGradient(
      colors: [Color(0xFF00E676), Color(0xFF00BFA5)]);

  // ── Fond animé ─────────────────────────────────────────────
  static LinearGradient bgGradient(bool dark) => dark
      ? const LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Color(0xFF0D0E2A), Color(0xFF1A0A3A), Color(0xFF0D0E2A)])
      : const LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Color(0xFFB2C8FF), Color(0xFFCC99FF), Color(0xFFFF9DC0)]);

  // ── Couleurs contextuelles ─────────────────────────────────
  static Color cardBg(bool dark) => dark
      ? const Color(0xFF1A1B4B).withOpacity(0.65)
      : Colors.white.withOpacity(0.65);
  static Color cardBorder(bool dark) => dark
      ? const Color(0xFF3D3F8F).withOpacity(0.45)
      : Colors.white.withOpacity(0.80);
  static Color textPrimary(bool dark) =>
      dark ? Colors.white : const Color(0xFF1A1B4B);
  static Color textSecondary(bool dark) =>
      dark ? Colors.white60 : const Color(0xFF5A5A8A);

  // ── ThemeData ──────────────────────────────────────────────
  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0D0E2A),
    colorScheme: const ColorScheme.dark(primary: cIndigo, secondary: cCyan),
    textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
    useMaterial3: true,
  );

  static ThemeData get light => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFE8E0FF),
    colorScheme: const ColorScheme.light(primary: cIndigo, secondary: cViolet),
    textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme),
    useMaterial3: true,
  );
}
