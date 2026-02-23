import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';
import '../../core/error/exceptions.dart';

abstract class WeatherLocalDataSource {
  Future<WeatherModel> getLastWeather(String cityName);
  Future<void> cacheWeather(WeatherModel weather);
  Future<void> clearCache();
  Future<List<WeatherModel>> getAllCachedWeather();
}

class WeatherLocalDataSourceImpl implements WeatherLocalDataSource {
  final SharedPreferences sharedPreferences;
  
  WeatherLocalDataSourceImpl({required this.sharedPreferences});
  
  static const String cachedWeatherPrefix = 'CACHED_WEATHER_';
  static const String cacheTimestampPrefix = 'CACHE_TIMESTAMP_';
  static const int cacheValidityHours = 1;
  
  @override
  Future<WeatherModel> getLastWeather(String cityName) async {
    final key = '$cachedWeatherPrefix${cityName.toLowerCase()}';
    final timestampKey = '$cacheTimestampPrefix${cityName.toLowerCase()}';
    
    final jsonString = sharedPreferences.getString(key);
    final timestamp = sharedPreferences.getInt(timestampKey);
    
    if (jsonString == null || timestamp == null) {
      throw const CacheException(message: 'No cached data found');
    }
    
    // Check if cache is still valid
    final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final difference = now.difference(cacheTime);
    
    if (difference.inHours > cacheValidityHours) {
      throw const CacheException(message: 'Cached data expired');
    }
    
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return WeatherModel.fromJson(json);
    } catch (e) {
      throw const CacheException(message: 'Failed to parse cached data');
    }
  }
  
  @override
  Future<void> cacheWeather(WeatherModel weather) async {
    final key = '$cachedWeatherPrefix${weather.cityName.toLowerCase()}';
    final timestampKey = '$cacheTimestampPrefix${weather.cityName.toLowerCase()}';
    
    final jsonString = jsonEncode(weather.toJson());
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    
    await Future.wait([
      sharedPreferences.setString(key, jsonString),
      sharedPreferences.setInt(timestampKey, timestamp),
    ]);
  }
  
  @override
  Future<void> clearCache() async {
    final keys = sharedPreferences.getKeys();
    final weatherKeys = keys.where((key) => 
        key.startsWith(cachedWeatherPrefix) || 
        key.startsWith(cacheTimestampPrefix));
    
    for (final key in weatherKeys) {
      await sharedPreferences.remove(key);
    }
  }
  
  @override
  Future<List<WeatherModel>> getAllCachedWeather() async {
    final keys = sharedPreferences.getKeys();
    final weatherKeys = keys.where((key) => key.startsWith(cachedWeatherPrefix));
    
    final List<WeatherModel> cachedWeatherList = [];
    
    for (final key in weatherKeys) {
      try {
        final cityName = key.replaceFirst(cachedWeatherPrefix, '');
        final weather = await getLastWeather(cityName);
        cachedWeatherList.add(weather);
      } catch (e) {
        // Skip invalid cached entries
        continue;
      }
    }
    
    return cachedWeatherList;
  }
}