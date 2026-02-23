import 'package:dartz/dartz.dart';
import '../entities/weather_entity.dart';
import '../repositories/weather_repository.dart';
import '../../core/error/failures.dart';

class GetCurrentWeather {
  final WeatherRepository repository;
  
  const GetCurrentWeather(this.repository);
  
  Future<Either<Failure, WeatherEntity>> call(String cityName) async {
    if (cityName.trim().isEmpty) {
      return const Left(
        ServerFailure(message: 'City name cannot be empty'),
      );
    }
    
    return await repository.getCurrentWeather(cityName.trim());
  }
}