import 'package:equatable/equatable.dart';

class WeatherEntity extends Equatable {
  final String cityName;
  final String country;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String description;
  final String icon;
  final DateTime lastUpdated;
  final double? pressure;
  final int? visibility;
  
  const WeatherEntity({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.icon,
    required this.lastUpdated,
    this.pressure,
    this.visibility,
  });
  
  @override
  List<Object?> get props => [
    cityName,
    country,
    temperature,
    feelsLike,
    humidity,
    windSpeed,
    description,
    icon,
    lastUpdated,
    pressure,
    visibility,
  ];
  
  String get iconUrl => 'https://openweathermap.org/img/wn/$icon@2x.png';
  
  String get temperatureString => '${temperature.round()}°C';
  
  String get feelsLikeString => '${feelsLike.round()}°C';
  
  String get humidityString => '$humidity%';
  
  String get windSpeedString => '${windSpeed.toStringAsFixed(1)} km/h';
  
  bool get isDataFresh {
    final now = DateTime.now();
    final difference = now.difference(lastUpdated);
    return difference.inMinutes < 10; // Data is fresh if less than 10 minutes old
  }
}