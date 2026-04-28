import 'exceptions.dart';

abstract class Failure {
  final String message;
  final int? statusCode;

  Failure({required this.message, this.statusCode});
}

class NetworkFailure extends Failure {
  NetworkFailure({required super.message, super.statusCode});

  factory NetworkFailure.fromException(NetworkException exception) {
    return NetworkFailure(
      message: exception.message,
      statusCode: exception.statusCode,
    );
  }
}

class CacheFailure extends Failure {
  CacheFailure({required super.message});

  factory CacheFailure.fromException(CacheException exception) {
    return CacheFailure(message: exception.message);
  }
}

class ServerFailure extends Failure {
  ServerFailure({required super.message, super.statusCode});
}

class UnknownFailure extends Failure {
  UnknownFailure() : super(message: "An unknown error occurred");
}
