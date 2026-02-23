import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/usecases/get_current_weather.dart';
import '../../domain/usecases/get_multiple_cities_weather.dart';
import '../../domain/entities/weather_entity.dart';
import 'weather_state.dart';

class WeatherNotifier extends StateNotifier<WeatherState> {
  final GetCurrentWeather getCurrentWeather;
  final GetMultipleCitiesWeather getMultipleCitiesWeather;
  
  Timer? _refreshTimer;
  List<String> _currentCities = AppConstants.defaultCities;
  
  WeatherNotifier({
    required this.getCurrentWeather,
    required this.getMultipleCitiesWeather,
  }) : super(const WeatherInitial());
  
  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }
  
  Future<void> loadWeatherForDefaultCities() async {
    await loadWeatherForCities(AppConstants.defaultCities);
  }
  
  Future<void> loadWeatherForCities(List<String> cities) async {
    if (cities.isEmpty) return;
    
    _currentCities = cities;
    state = const WeatherLoading();
    
    final result = await getMultipleCitiesWeather(cities);
    
    result.fold(
      (failure) {
        state = WeatherError(failure: failure);
      },
      (weatherList) {
        state = WeatherLoaded(
          weatherList: weatherList,
          lastUpdated: DateTime.now(),
        );
        _startAutoRefresh();
      },
    );
  }
  
  Future<void> loadWeatherForSingleCity(String cityName) async {
    if (cityName.trim().isEmpty) return;
    
    state = const WeatherLoading();
    
    final result = await getCurrentWeather(cityName);
    
    result.fold(
      (failure) {
        state = WeatherError(failure: failure);
      },
      (weather) {
        state = WeatherLoaded(
          weatherList: [weather],
          lastUpdated: DateTime.now(),
        );
      },
    );
  }
  
  Future<void> addCityWeather(String cityName) async {
    if (cityName.trim().isEmpty) return;
    
    final currentState = state;
    if (currentState is! WeatherLoaded) {
      await loadWeatherForSingleCity(cityName);
      return;
    }
    
    // Check if city is already in the list
    final cityExists = currentState.weatherList
        .any((weather) => weather.cityName.toLowerCase() == cityName.toLowerCase());
    
    if (cityExists) return;
    
    // Set loading state but keep existing data
    state = const WeatherLoading();
    
    final result = await getCurrentWeather(cityName);
    
    result.fold(
      (failure) {
        // Restore previous state on error
        state = currentState;
        // You might want to show a snackbar or toast here
      },
      (newWeather) {
        final updatedList = [...currentState.weatherList, newWeather];
        state = WeatherLoaded(
          weatherList: updatedList,
          lastUpdated: DateTime.now(),
        );
      },
    );
  }
  
  void removeCityWeather(String cityName) {
    final currentState = state;
    if (currentState is! WeatherLoaded) return;
    
    final updatedList = currentState.weatherList
        .where((weather) => weather.cityName.toLowerCase() != cityName.toLowerCase())
        .toList();
    
    if (updatedList.length != currentState.weatherList.length) {
      state = WeatherLoaded(
        weatherList: updatedList,
        lastUpdated: currentState.lastUpdated,
      );
    }
  }
  
  Future<void> refreshWeather() async {
    final currentState = state;
    
    if (currentState is WeatherLoaded) {
      final cities = currentState.weatherList.map((w) => w.cityName).toList();
      await loadWeatherForCities(cities);
    } else {
      await loadWeatherForCities(_currentCities);
    }
  }
  
  void _startAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(
      const Duration(seconds: AppConstants.refreshInterval),
      (_) => _autoRefresh(),
    );
  }
  
  Future<void> _autoRefresh() async {
    final currentState = state;
    if (currentState is! WeatherLoaded) return;
    
    // Only auto-refresh if data is not fresh
    if (currentState.isDataFresh) return;
    
    // Silently refresh without showing loading state
    final cities = currentState.weatherList.map((w) => w.cityName).toList();
    final result = await getMultipleCitiesWeather(cities);
    
    result.fold(
      (failure) {
        // Keep current data but mark as error with cached data
        state = WeatherError(
          failure: failure,
          cachedWeatherList: currentState.weatherList,
        );
      },
      (weatherList) {
        state = WeatherLoaded(
          weatherList: weatherList,
          lastUpdated: DateTime.now(),
        );
      },
    );
  }
  
  void stopAutoRefresh() {
    _refreshTimer?.cancel();
  }
  
  void startAutoRefresh() {
    _startAutoRefresh();
  }
}