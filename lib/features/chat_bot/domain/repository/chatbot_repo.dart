import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/failuers.dart';
import '../entity/message_entity.dart';

abstract class ChatbotRepo {
  Future<Either<Failure, MessageEntity>> sendMessage(String message);
  Future<Either<Failure, MessageEntity>> sendImage(String imagePath);
}
