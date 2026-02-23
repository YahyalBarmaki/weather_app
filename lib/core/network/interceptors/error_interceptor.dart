import 'package:dio/dio.dart';
import '../../error/exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Exception exception;
    
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        exception = const NetworkException(
          message: 'Connection timeout. Please check your internet connection.',
        );
        break;
        
      case DioExceptionType.connectionError:
        exception = const NetworkException(
          message: 'Network connection failed. Please check your internet connection.',
        );
        break;
        
      case DioExceptionType.badResponse:
        exception = _handleResponseError(err);
        break;
        
      case DioExceptionType.cancel:
        exception = const NetworkException(
          message: 'Request was cancelled.',
        );
        break;
        
      case DioExceptionType.unknown:
        if (err.error.toString().contains('SocketException')) {
          exception = const NetworkException(
            message: 'No internet connection available.',
          );
        } else {
          exception = NetworkException(
            message: err.error?.toString() ?? 'An unexpected error occurred.',
          );
        }
        break;
        
      default:
        exception = NetworkException(
          message: err.message ?? 'An unexpected error occurred.',
        );
        break;
    }
    
    // Create a new DioException with our custom exception
    final customError = DioException(
      requestOptions: err.requestOptions,
      error: exception,
      type: err.type,
      response: err.response,
    );
    
    super.onError(customError, handler);
  }
  
  Exception _handleResponseError(DioException err) {
    final statusCode = err.response?.statusCode ?? 0;
    final responseData = err.response?.data;
    
    String message = 'Server error occurred';
    
    // Try to extract error message from response
    if (responseData is Map<String, dynamic>) {
      message = responseData['message']?.toString() ?? 
                responseData['error']?.toString() ?? 
                message;
    }
    
    return ServerException(
      message: message,
      statusCode: statusCode,
    );
  }
}