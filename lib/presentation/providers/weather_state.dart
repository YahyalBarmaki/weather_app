import 'package:equatable/equatable.dart';
import '../../domain/entities/weather_entity.dart';
import '../../core/error/failures.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();
  
  @override
  List<Object?> get props => [];
}

class WeatherInitial extends WeatherState {
  const WeatherInitial();
}

class WeatherLoading extends WeatherState {
  const WeatherLoading();
}

class WeatherLoaded extends WeatherState {
  final List<WeatherEntity> weatherList;
  final DateTime lastUpdated;
  
  const WeatherLoaded({
    required this.weatherList,
    required this.lastUpdated,
  });
  
  @override
  List<Object?> get props => [weatherList, lastUpdated];
  
  bool get isDataFresh {
    final now = DateTime.now();
    final difference = now.difference(lastUpdated);
    return difference.inMinutes < 5; // Data is fresh if less than 5 minutes old
  }
  
  WeatherLoaded copyWith({
    List<WeatherEntity>? weatherList,
    DateTime? lastUpdated,
  }) {
    return WeatherLoaded(
      weatherList: weatherList ?? this.weatherList,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

class WeatherError extends WeatherState {
  final Failure failure;
  final List<WeatherEntity>? cachedWeatherList;
  
  const WeatherError({
    required this.failure,
    this.cachedWeatherList,
  });
  
  @override
  List<Object?> get props => [failure, cachedWeatherList];
  
  bool get hasCachedData => cachedWeatherList != null && cachedWeatherList!.isNotEmpty;
}