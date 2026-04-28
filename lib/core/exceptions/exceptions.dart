import 'package:dio/dio.dart';

import '../api/status_codes.dart';

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
    switch (error.response?.statusCode) {
      case StatusCodes.badRequest:
        return NetworkException(
          message: "Bad Request",
          statusCode: StatusCodes.badRequest,
        );
      case StatusCodes.unauthorized:
        return NetworkException(
          message: "Unauthorized - Please login again",
          statusCode: StatusCodes.unauthorized,
        );
      case StatusCodes.forbidden:
        return NetworkException(
          message: "Forbidden - You don't have permission",
          statusCode: StatusCodes.forbidden,
        );
      case StatusCodes.notFound:
        return NetworkException(
          message: "Not Found",
          statusCode: StatusCodes.notFound,
        );
      case StatusCodes.serverError:
        return NetworkException(
          message: "Server Error - Please try again later",
          statusCode: StatusCodes.serverError,
        );
      default:
        return NetworkException(
          message: error.message ?? "Unexpected network error",
        );
    }
  }
}

class CacheException extends AppException {
  CacheException({required super.message});
}
