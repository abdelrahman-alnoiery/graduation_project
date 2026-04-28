import 'package:dartz/dartz.dart';
import 'package:graduation_project/core/exceptions/exceptions.dart';
import 'package:graduation_project/core/network/check_internet_connection.dart';

import '../../../../core/exceptions/failuers.dart';
import '../../domain/entity/message_entity.dart';
import '../../domain/repository/chatbot_repo.dart';
import '../dataSources/remote/chatbot_remote_data_source.dart';

class ChatbotRepoImpl implements ChatbotRepo {
  final ChatbotRemoteDataSource remoteDataSource;
  final CheckInternetConnection networkInfo;

  ChatbotRepoImpl({required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, MessageEntity>> sendMessage(String message) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: "No internet connection"));
    }
    try {
      final response = await remoteDataSource.sendMessage(message);
      return Right(response);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, MessageEntity>> sendImage(String imagePath) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure(message: "No internet connection"));
    }
    try {
      final response = await remoteDataSource.sendImage(imagePath);
      return Right(response);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
