import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/domain/entities/weather_entity.dart';
import 'package:weather_app/presentation/providers/weather_provider.dart';

class DashBoard extends ConsumerStatefulWidget {
  const DashBoard({super.key});

  @override
  ConsumerState<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends ConsumerState<DashBoard> {
  bool _isDark = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(weatherProvider.notifier).loadWeatherForDefaultCities(),
    );
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    const months = [
      'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
    ];
    const days = [
      'Lundi', 'Mardi', 'Mercredi', 'Jeudi',
      'Vendredi', 'Samedi', 'Dimanche'
    ];
    return '${days[now.weekday - 1]} ${now.day} ${months[now.month - 1]} ${now.year}';
  }
  String _getCountryName(String code) {
  const countries = {
    'FR': 'France',
    'US': 'États-Unis',
    'GB': 'Royaume-Uni',
    'JP': 'Japon',
    'AU': 'Australie',
    'DE': 'Allemagne',
    'IT': 'Italie',
    'ES': 'Espagne',
    'CN': 'Chine',
    'BR': 'Brésil',
    'CA': 'Canada',
    'IN': 'Inde',
    'RU': 'Russie',
    'MX': 'Mexique',
    'SN': 'Sénégal',
  };
  return countries[code.toUpperCase()] ?? code;
}

  // Dark theme gradients
  static const _darkBgStart = Color(0xFF1B1F3B);
  static const _darkBgEnd = Color(0xFF2C2F6E);

  // Light theme gradients  
  static const _lightBgStart = Color(0xFF9B8FE8);
  static const _lightBgEnd = Color(0xFFE87BC8);

  Color get _textColor => _isDark ? Colors.white : Colors.white;
  Color get _subColor => _isDark
      ? Colors.white.withValues(alpha: 0.6)
      : Colors.white.withValues(alpha: 0.75);
  Color get _cardColor => _isDark
      ? Colors.white.withValues(alpha: 0.08)
      : Colors.white.withValues(alpha: 0.25);
  Color get _borderColor => Colors.white.withValues(alpha: 0.2);

  @override
  Widget build(BuildContext context) {
    final weatherList = ref.watch(weatherListProvider);
    final isLoading = ref.watch(weatherLoadingProvider);
    final errorMessage = ref.watch(weatherErrorProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isDark
                ? [_darkBgStart, _darkBgEnd]
                : [_lightBgStart, _lightBgEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: _buildHeader(),
                  ),
                  const SizedBox(height: 20),
                  if (weatherList != null && weatherList.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildStatsRow(weatherList),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Vos emplacements',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _textColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Expanded(
                    child: _buildBody(isLoading, weatherList, errorMessage),
                  ),
                ],
              ),
              Positioned(
                bottom: 24,
                right: 24,
                child: GestureDetector(
                  onTap: () =>
                      ref.read(weatherProvider.notifier).refreshWeather(),
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF7B6FE8),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7B6FE8).withValues(alpha: 0.6),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.refresh,
                        color: Colors.white, size: 24),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tableau de bord météo',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
            ),
            Text(
              _getFormattedDate(),
              style: GoogleFonts.poppins(fontSize: 13, color: _subColor),
            ),
          ],
        ),
        GestureDetector(
          onTap: () => setState(() => _isDark = !_isDark),
          child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.2),
                  border: Border.all(color: _borderColor),
                ),
                child: Icon(
                  _isDark ? Icons.wb_sunny_outlined : Icons.nightlight_round,
                  color: _isDark ? Colors.yellow : Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(List<WeatherEntity> weatherList) {
    final avgTemp =
        weatherList.map((w) => w.temperature).reduce((a, b) => a + b) /
            weatherList.length;
    final avgHumidity =
        weatherList.map((w) => w.humidity).reduce((a, b) => a + b) /
            weatherList.length;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: _cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _borderColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem('${weatherList.length}', 'Villes'),
              Container(width: 1, height: 40, color: _borderColor),
              _buildStatItem('${avgTemp.round()}°', 'Temp moy.'),
              Container(width: 1, height: 40, color: _borderColor),
              _buildStatItem('${avgHumidity.round()}%', 'Humidité'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: _textColor,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12, color: _subColor),
        ),
      ],
    );
  }

  Widget _buildBody(
    bool isLoading,
    List<WeatherEntity>? weatherList,
    String? errorMessage,
  ) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (errorMessage != null && (weatherList == null || weatherList.isEmpty)) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, color: Colors.white54, size: 64),
            const SizedBox(height: 16),
            Text(
              errorMessage,
              style: GoogleFonts.poppins(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (weatherList == null || weatherList.isEmpty) {
      return Center(
        child: Text(
          'Aucune donnée disponible',
          style: GoogleFonts.poppins(color: Colors.white60, fontSize: 15),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 90),
      itemCount: weatherList.length,
      itemBuilder: (context, index) =>
          _buildGlassCard(weatherList[index]),
    );
  }

  Widget _buildGlassCard(WeatherEntity weather) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _borderColor, width: 1.2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                         _getCountryName(weather.cityName),
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: _isDark?Colors.white:Colors.black,
                          ),
                        ),
                        Text(
                          weather.country,
                          style: GoogleFonts.poppins(
                              fontSize: 13, color: _isDark?Colors.white:Colors.black),
                        ),
                      ],
                    ),
                    // Weather icon from OpenWeatherMap
                    Image.network(
                      weather.iconUrl,
                      width: 52,
                      height: 52,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.wb_cloudy_outlined,
                        color: Colors.yellow,
                        size: 40,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Temperature
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${weather.temperature.round()}°',
                      style: GoogleFonts.poppins(
                        fontSize: 52,
                        fontWeight: FontWeight.w600,
                        color: _isDark?Colors.white:Colors.black,
                        height: 1.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        ' C',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: _isDark?Colors.white:Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // Weather description
                Text(
                  weather.description.isNotEmpty
                      ? weather.description[0].toUpperCase() +
                          weather.description.substring(1)
                      : '',
                  style: GoogleFonts.poppins(
                      fontSize: 14, color: _isDark?Colors.white:Colors.black),
                ),

                const SizedBox(height: 12),

                
                Row(
                  children: [
                    const Icon(Icons.water_drop_outlined,
                        size: 15, color:Colors.blueAccent),
                    const SizedBox(width: 4),
                    Text(weather.humidityString,
                        style: GoogleFonts.poppins(
                            fontSize: 13, color: _isDark?Colors.white:Colors.black)),
                    const SizedBox(width: 16),
                    const Icon(Icons.air, size: 15, color: Colors.blueAccent),
                    const SizedBox(width: 4),
                    Text(weather.windSpeedString,
                        style: GoogleFonts.poppins(
                            fontSize: 13, color: _isDark?Colors.white:Colors.black)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
