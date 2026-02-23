import 'package:dartz/dartz.dart';

abstract class Failure {
  final String message;
  final int? code;
  
  const Failure({required this.message, this.code});
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure && 
           other.message == message && 
           other.code == code;
  }
  
  @override
  int get hashCode => message.hashCode ^ code.hashCode;
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
  
  factory ServerFailure.fromStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return const ServerFailure(
          message: 'Bad request - Please check your input',
          code: 400,
        );
      case 401:
        return const ServerFailure(
          message: 'Unauthorized - Invalid API key',
          code: 401,
        );
      case 404:
        return const ServerFailure(
          message: 'City not found',
          code: 404,
        );
      case 429:
        return const ServerFailure(
          message: 'Too many requests - Please try again later',
          code: 429,
        );
      case 500:
        return const ServerFailure(
          message: 'Internal server error',
          code: 500,
        );
      default:
        return ServerFailure(
          message: 'Server error occurred (Code: $statusCode)',
          code: statusCode,
        );
    }
  }
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.code});
  
  factory NetworkFailure.noConnection() {
    return const NetworkFailure(
      message: 'No internet connection available',
      code: 0,
    );
  }
  
  factory NetworkFailure.timeout() {
    return const NetworkFailure(
      message: 'Request timeout - Please try again',
      code: 408,
    );
  }
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.code});
  
  factory CacheFailure.notFound() {
    return const CacheFailure(
      message: 'No cached data available',
    );
  }
}

class ParsingFailure extends Failure {
  const ParsingFailure({required super.message, super.code});
  
  factory ParsingFailure.invalidFormat() {
    return const ParsingFailure(
      message: 'Invalid data format received from server',
    );
  }
}

typedef EitherFailure<T> = Either<Failure, T>;