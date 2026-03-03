class WeatherCity {
  final String city;
  final String country;
  final String condition;     // code EN  ex: 'Clear'
  final String conditionFr;   // traduit  ex: 'Ensoleillé'
  final String icon;
  final double temperature;
  final double feelsLike;
  final double high;
  final double low;
  final double windSpeed;     // km/h
  final double lat;
  final double lon;
  final int    humidity;      // %
  final int    visibility;    // km
  final int    pressure;      // hPa
  final String sunrise;       // HH:MM
  final String sunset;        // HH:MM

  const WeatherCity({
    required this.city,       required this.country,
    required this.condition,  required this.conditionFr,
    required this.icon,       required this.temperature,
    required this.feelsLike,  required this.high,
    required this.low,        required this.windSpeed,
    required this.lat,        required this.lon,
    required this.humidity,   required this.visibility,
    required this.pressure,   required this.sunrise,
    required this.sunset,
  });

  // Emoji météo
  String get emoji {
    switch (condition) {
      case 'Clear':        return '☀️';
      case 'Clouds':       return icon.contains('02') ? '⛅' : '☁️';
      case 'Rain':         return '🌧';
      case 'Drizzle':      return '🌦';
      case 'Thunderstorm': return '⛈';
      case 'Snow':         return '❄️';
      case 'Mist':
      case 'Fog':
      case 'Haze':         return '🌫';
      default:             return '🌤';
    }
  }

  // Traduction EN → FR
  static String translate(String c) => const {
    'Clear': 'Ensoleillé',   'Clouds': 'Nuageux',
    'Rain':  'Pluvieux',     'Drizzle': 'Bruine',
    'Thunderstorm': 'Orageux', 'Snow': 'Neigeux',
    'Mist':  'Brumeux',      'Fog': 'Brouillard',
    'Haze':  'Voilé',
  }[c] ?? c;

  // Timestamp Unix → HH:MM
  static String formatTime(int? ts) {
    if (ts == null) return '--:--';
    final d = DateTime.fromMillisecondsSinceEpoch(ts * 1000);
    return '${d.hour.toString().padLeft(2,'0')}:${d.minute.toString().padLeft(2,'0')}';
  }
}
