import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/weather_entity.dart';

abstract class WeatherRepository {
  Future<Either<Failure, WeatherEntity>> getCurrentWeather(String cityName);
  Future<Either<Failure, List<WeatherEntity>>> getMultipleCitiesWeather(List<String> cities);
  Future<Either<Failure, WeatherEntity>> getCachedWeather(String cityName);
  Future<void> cacheWeather(WeatherEntity weather);
  Future<void> clearCache();
}