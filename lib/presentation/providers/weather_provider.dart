import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/injection_container.dart';
import '../../domain/usecases/get_current_weather.dart';
import '../../domain/usecases/get_multiple_cities_weather.dart';
import 'weather_notifier.dart';
import 'weather_state.dart';

// Use cases providers
final getCurrentWeatherProvider = Provider<GetCurrentWeather>((ref) {
  return sl<GetCurrentWeather>();
});

final getMultipleCitiesWeatherProvider = Provider<GetMultipleCitiesWeather>((ref) {
  return sl<GetMultipleCitiesWeather>();
});

// Weather state provider
final weatherProvider = StateNotifierProvider<WeatherNotifier, WeatherState>((ref) {
  final getCurrentWeather = ref.read(getCurrentWeatherProvider);
  final getMultipleCitiesWeather = ref.read(getMultipleCitiesWeatherProvider);
  
  return WeatherNotifier(
    getCurrentWeather: getCurrentWeather,
    getMultipleCitiesWeather: getMultipleCitiesWeather,
  );
});

// Convenience providers for specific state conditions
final weatherLoadingProvider = Provider<bool>((ref) {
  final weatherState = ref.watch(weatherProvider);
  return weatherState is WeatherLoading;
});

final weatherListProvider = Provider<List<WeatherEntity>?>((ref) {
  final weatherState = ref.watch(weatherProvider);
  if (weatherState is WeatherLoaded) {
    return weatherState.weatherList;
  } else if (weatherState is WeatherError && weatherState.hasCachedData) {
    return weatherState.cachedWeatherList;
  }
  return null;
});

final weatherErrorProvider = Provider<String?>((ref) {
  final weatherState = ref.watch(weatherProvider);
  if (weatherState is WeatherError) {
    return weatherState.failure.message;
  }
  return null;
});

final isDataFreshProvider = Provider<bool>((ref) {
  final weatherState = ref.watch(weatherProvider);
  if (weatherState is WeatherLoaded) {
    return weatherState.isDataFresh;
  }
  return false;
});

// Import the entity for the provider
import '../../domain/entities/weather_entity.dart';