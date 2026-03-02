import 'package:dio/dio.dart';

class DioClient {
  static late Dio _dio;
  static DioClient? _instance;

  DioClient._internal() {
    _dio = Dio();
    _dio.options = BaseOptions(
      baseUrl: 'https://api.openweathermap.org/data/2.5/',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
      },
    );
  }

  static DioClient get instance {
    _instance ??= DioClient._internal();
    return _instance!;
  }

  Dio get dio => _dio;
}