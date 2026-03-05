import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/weather_city.dart';
import '../theme/app_theme.dart';

class Header extends StatelessWidget {
  final WeatherCity city; final bool dark;
  const Header({required this.city, required this.dark});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(8, 12, 20, 12),
    decoration: BoxDecoration(border: Border(bottom: BorderSide(
        color: Colors.white.withOpacity(dark ? 0.08 : 0.4)))),
    child: Row(children: [
      IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded,
              color: AppTheme.textPrimary(dark), size: 20),
          onPressed: () => Navigator.of(context).pop()),
      Expanded(child: Column(children: [
        Text(city.city, textAlign: TextAlign.center,
            style: GoogleFonts.outfit(color: AppTheme.textPrimary(dark),
                fontSize: 18, fontWeight: FontWeight.w800)),
        Text(city.country, textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
                color: AppTheme.textSecondary(dark), fontSize: 12)),
      ])),
      const SizedBox(width: 40),
    ]),
  );
}