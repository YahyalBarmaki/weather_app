import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Ensure API key is present
    if (!options.queryParameters.containsKey('appid') || 
        options.queryParameters['appid']?.toString().isEmpty == true) {
      options.queryParameters['appid'] = dotenv.env['OPEN_WEATHER_API_KEY'] ?? '';
    }
    
    // Add request timestamp for debugging
    options.extra['request_time'] = DateTime.now().millisecondsSinceEpoch;
    
    super.onRequest(options, handler);
  }
  
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Add response processing time
    final requestTime = response.requestOptions.extra['request_time'] as int?;
    if (requestTime != null) {
      final responseTime = DateTime.now().millisecondsSinceEpoch;
      final duration = responseTime - requestTime;
      response.extra['response_time'] = duration;
    }
    
    super.onResponse(response, handler);
  }
}