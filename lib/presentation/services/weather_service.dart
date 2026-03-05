// ============================================================
//  services/weather_service.dart  —  Service météo
//
//  MODE ACTUEL   → données mockées (test sans internet)
//  POUR L'API    → décommenter _fetchApi() et dio: dans pubspec
// ============================================================

import '../models/weather_city.dart';

class WeatherService {
  WeatherService._();
  static final WeatherService instance = WeatherService._();

  // ── Villes cibles ──────────────────────────────────────────
  static const _cities = [
    _City('San Francisco', 'États-Unis',  37.7749, -122.4194),
    _City('New York',      'États-Unis',  40.7128,  -74.0060),
    _City('Londres',       'Royaume-Uni', 51.5074,   -0.1278),
    _City('Tokyo',         'Japon',       35.6762,  139.6503),
    _City('Paris',         'France',      48.8566,    2.3522),
  ];

  // ── Données mockées ────────────────────────────────────────
  static final _mock = [
    const WeatherCity(
      city: 'San Francisco', country: 'États-Unis',
      condition: 'Clouds',   conditionFr: 'Partiellement nuageux',
      icon: '02d',           temperature: 18, feelsLike: 16,
      high: 21, low: 14,     windSpeed: 12,   humidity: 72,
      visibility: 10,        pressure: 1013,
      lat: 37.7749,          lon: -122.4194,
      sunrise: '06:42',      sunset: '19:18',
    ),
    const WeatherCity(
      city: 'New York',   country: 'États-Unis',
      condition: 'Clear', conditionFr: 'Ensoleillé',
      icon: '01d',        temperature: 22, feelsLike: 21,
      high: 25, low: 18,  windSpeed: 8,    humidity: 65,
      visibility: 16,     pressure: 1018,
      lat: 40.7128,       lon: -74.0060,
      sunrise: '06:28',   sunset: '19:45',
    ),
    const WeatherCity(
      city: 'Londres',  country: 'Royaume-Uni',
      condition: 'Rain', conditionFr: 'Pluvieux',
      icon: '10d',       temperature: 14, feelsLike: 12,
      high: 16, low: 10, windSpeed: 15,   humidity: 85,
      visibility: 8,     pressure: 1005,
      lat: 51.5074,      lon: -0.1278,
      sunrise: '06:10',  sunset: '20:02',
    ),
    const WeatherCity(
      city: 'Tokyo',    country: 'Japon',
      condition: 'Clear', conditionFr: 'Dégagé',
      icon: '01d',        temperature: 26, feelsLike: 28,
      high: 29, low: 22,  windSpeed: 10,   humidity: 60,
      visibility: 20,     pressure: 1020,
      lat: 35.6762,       lon: 139.6503,
      sunrise: '05:30',   sunset: '18:50',
    ),
    const WeatherCity(
      city: 'Paris',     country: 'France',
      condition: 'Clouds', conditionFr: 'Nuageux',
      icon: '03d',         temperature: 20, feelsLike: 19,
      high: 23, low: 16,   windSpeed: 20,   humidity: 70,
      visibility: 12,      pressure: 1010,
      lat: 48.8566,        lon: 2.3522,
      sunrise: '06:50',    sunset: '20:30',
    ),
  ];

  // ── Point d'entrée ─────────────────────────────────────────
  Future<List<WeatherCity>> fetchAllCities({
    void Function(int loaded, int total)? onProgress,
  }) async {
    return _fetchMock(onProgress: onProgress);
    // ↓ Décommenter pour l'API réelle :
    // return _fetchApi(onProgress: onProgress);
  }

  // ── Mock : simule 1.5s par ville ──────────────────────────
  Future<List<WeatherCity>> _fetchMock({
    void Function(int, int)? onProgress,
  }) async {
    final out = <WeatherCity>[];
    for (int i = 0; i < _mock.length; i++) {
      await Future.delayed(const Duration(milliseconds: 1500));
      out.add(_mock[i]);
      onProgress?.call(i + 1, _mock.length);
    }
    return out;
  }

  // ── API réelle (Dio) — décommenter si besoin ──────────────
  // static const _apiKey = 'VOTRE_CLE_ICI';
  // Future<List<WeatherCity>> _fetchApi({...}) async { ... }
}

class _City {
  final String name, country;
  final double lat, lon;
  const _City(this.name, this.country, this.lat, this.lon);
}