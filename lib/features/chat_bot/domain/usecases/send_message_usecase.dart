import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/failuers.dart';
import '../entity/message_entity.dart';
import '../repository/chatbot_repo.dart';

class SendMessageUseCase {
  final ChatbotRepo chatbotRepo;
  SendMessageUseCase(this.chatbotRepo);

  Future<Either<Failure, MessageEntity>> call(String message) async {
    return await chatbotRepo.sendMessage(message);
  }
}
