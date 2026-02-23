import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/weather_model.dart';

part 'weather_api_service.g.dart';

@RestApi()
abstract class WeatherApiService {
  factory WeatherApiService(Dio dio) = _WeatherApiService;
  
  @GET('/weather')
  Future<WeatherModel> getCurrentWeather(
    @Query('q') String cityName,
  );
  
  @GET('/weather')
  Future<WeatherModel> getCurrentWeatherByCoordinates(
    @Query('lat') double latitude,
    @Query('lon') double longitude,
  );
}