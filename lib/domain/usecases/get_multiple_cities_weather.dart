import 'package:dartz/dartz.dart';
import '../entities/weather_entity.dart';
import '../repositories/weather_repository.dart';
import '../../core/error/failures.dart';

class GetMultipleCitiesWeather {
  final WeatherRepository repository;
  
  const GetMultipleCitiesWeather(this.repository);
  
  Future<Either<Failure, List<WeatherEntity>>> call(List<String> cities) async {
    if (cities.isEmpty) {
      return const Left(
        ServerFailure(message: 'Cities list cannot be empty'),
      );
    }
    
    // Filter out empty city names
    final validCities = cities
        .where((city) => city.trim().isNotEmpty)
        .map((city) => city.trim())
        .toList();
    
    if (validCities.isEmpty) {
      return const Left(
        ServerFailure(message: 'No valid city names provided'),
      );
    }
    
    return await repository.getMultipleCitiesWeather(validCities);
  }
}