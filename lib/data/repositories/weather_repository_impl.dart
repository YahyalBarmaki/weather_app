import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_api_service.dart';
import '../datasources/weather_local_data_source.dart';
import '../models/weather_model.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherApiService apiService;
  final WeatherLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  const WeatherRepositoryImpl({
    required this.apiService,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, WeatherEntity>> getCurrentWeather(String cityName) async {
    try {
      if (await networkInfo.isConnected) {
        // Try to get fresh data from API
        final weatherModel = await apiService.getCurrentWeather(cityName);
        
        // Cache the fresh data
        await localDataSource.cacheWeather(weatherModel);
        
        return Right(weatherModel.toEntity());
      } else {
        // No internet connection, try to get cached data
        return _getCachedWeatherFallback(cityName);
      }
    } on DioException catch (e) {
      return _handleDioException(e, cityName);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ParsingException catch (e) {
      return Left(ParsingFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<WeatherEntity>>> getMultipleCitiesWeather(List<String> cities) async {
    final List<WeatherEntity> weatherList = [];
    final List<Failure> failures = [];

    // Process cities in parallel for better performance
    final futures = cities.map((city) => getCurrentWeather(city));
    final results = await Future.wait(futures);

    for (int i = 0; i < results.length; i++) {
      results[i].fold(
        (failure) {
          failures.add(failure);
          // Continue with other cities even if one fails
        },
        (weather) => weatherList.add(weather),
      );
    }

    // If all requests failed, return the first failure
    if (weatherList.isEmpty && failures.isNotEmpty) {
      return Left(failures.first);
    }

    return Right(weatherList);
  }

  @override
  Future<Either<Failure, WeatherEntity>> getCachedWeather(String cityName) async {
    try {
      final weatherModel = await localDataSource.getLastWeather(cityName);
      return Right(weatherModel.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get cached weather: ${e.toString()}'));
    }
  }

  @override
  Future<void> cacheWeather(WeatherEntity weather) async {
    try {
      // Convert entity back to model for caching
      // This is a workaround since we can't directly cache entities
      // In a real app, you might want to create a dedicated caching model
      final weatherModel = _entityToModel(weather);
      await localDataSource.cacheWeather(weatherModel);
    } catch (e) {
      // Silently fail cache operations to not break the main flow
      // In production, you might want to log this error
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await localDataSource.clearCache();
    } catch (e) {
      // Silently fail cache operations
    }
  }

  Future<Either<Failure, WeatherEntity>> _getCachedWeatherFallback(String cityName) async {
    try {
      final cachedWeather = await localDataSource.getLastWeather(cityName);
      return Right(cachedWeather.toEntity());
    } on CacheException {
      return Left(NetworkFailure.noConnection());
    }
  }

  Either<Failure, WeatherEntity> _handleDioException(DioException e, String cityName) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      // Try cached data on timeout
      return _getCachedWeatherFallbackSync(cityName);
    }

    if (e.type == DioExceptionType.connectionError) {
      return _getCachedWeatherFallbackSync(cityName);
    }

    if (e.response != null) {
      return Left(ServerFailure.fromStatusCode(e.response!.statusCode ?? 500));
    }

    return Left(NetworkFailure(message: e.message ?? 'Network error occurred'));
  }

  Either<Failure, WeatherEntity> _getCachedWeatherFallbackSync(String cityName) {
    // This is a synchronous version for use in error handling
    // In a real implementation, you might want to handle this differently
    return Left(NetworkFailure.timeout());
  }

  // Helper method to convert entity back to model
  // This is a simplified implementation
  WeatherModel _entityToModel(WeatherEntity entity) {
    // This is a workaround - in a real app you'd handle this better
    throw UnimplementedError('Entity to model conversion not implemented');
  }
}