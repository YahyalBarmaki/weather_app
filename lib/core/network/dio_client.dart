import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../constants/app_constants.dart';
import 'interceptors/api_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

class DioClient {
  static Dio? _dio;
  
  static Dio get instance {
    _dio ??= _createDio();
    return _dio!;
  }
  
  static Dio _createDio() {
    final dio = Dio();
    
    // Base configuration
    dio.options = BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: AppConstants.timeoutDuration),
      receiveTimeout: const Duration(seconds: AppConstants.timeoutDuration),
      sendTimeout: const Duration(seconds: AppConstants.timeoutDuration),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      queryParameters: {
        'appid': dotenv.env['OPEN_WEATHER_API_KEY'] ?? '',
        'units': AppConstants.units,
        'lang':'fr',
      },
    );
    
    // Add interceptors
    dio.interceptors.addAll([
      ApiInterceptor(),
      ErrorInterceptor(),
      LoggingInterceptor(),
    ]);
    
    return dio;
  }
  
  static void updateApiKey(String apiKey) {
    _dio?.options.queryParameters['appid'] = apiKey;
  }
  
  static void dispose() {
    _dio?.close();
    _dio = null;
  }
}