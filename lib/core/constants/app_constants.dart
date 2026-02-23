class AppConstants {
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5/';
  static const String currentWeatherEndpoint = 'weather';
  
  static const List<String> defaultCities = [
    'Paris',
    'London',
    'Tokyo',
    'New York',
    'Sydney'
  ];
  
  static const String units = 'metric';
  static const int timeoutDuration = 30;
  static const int refreshInterval = 30; // seconds
}