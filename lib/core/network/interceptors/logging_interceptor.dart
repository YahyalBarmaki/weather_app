import 'dart:developer';
import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('🚀 REQUEST[${options.method}] => PATH: ${options.path}');
    log('🚀 Headers: ${options.headers}');
    log('🚀 Query Parameters: ${options.queryParameters}');
    
    if (options.data != null) {
      log('🚀 Body: ${options.data}');
    }
    
    super.onRequest(options, handler);
  }
  
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final duration = response.extra['response_time'];
    log('✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    
    if (duration != null) {
      log('⏱️ Duration: ${duration}ms');
    }
    
    // Only log response data in debug mode and limit size
    final data = response.data.toString();
    if (data.length > 1000) {
      log('📦 Response Data: ${data.substring(0, 1000)}...[TRUNCATED]');
    } else {
      log('📦 Response Data: $data');
    }
    
    super.onResponse(response, handler);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log('❌ ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    log('❌ Error Type: ${err.type}');
    log('❌ Error Message: ${err.message}');
    
    if (err.response != null) {
      log('❌ Error Response: ${err.response?.data}');
    }
    
    super.onError(err, handler);
  }
}