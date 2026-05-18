import 'package:dio/dio.dart';

class AppException implements Exception {
  final String message;
  final int? statusCode;

  AppException({required this.message, this.statusCode});

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException({required super.message, super.statusCode});

  factory NetworkException.fromDioError(DioException error) {
    final responseMessage = error.response?.data is Map
        ? error.response?.data['message']?.toString()
        : error.message;

    // ✅ استخدم statusCode كـ int مباشرة
    final statusCode = error.response?.statusCode;

    switch (statusCode) {
      case 400:
        return NetworkException(
          message: responseMessage ?? "Bad Request",
          statusCode: 400,
        );
      case 401:
        return NetworkException(
          message: responseMessage ?? "Unauthorized",
          statusCode: 401,
        );
      case 403:
        return NetworkException(
          message: responseMessage ?? "Forbidden",
          statusCode: 403,
        );
      case 404:
        return NetworkException(
          message: responseMessage ?? "Not Found",
          statusCode: 404,
        );
      case 500:
        return NetworkException(
          message: responseMessage ?? "Server Error",
          statusCode: 500,
        );
      default:
        return NetworkException(
          message: responseMessage ?? error.message ?? "Unexpected error",
          statusCode: statusCode,
        );
    }
  }
}

class CacheException extends AppException {
  CacheException({required super.message});
}
