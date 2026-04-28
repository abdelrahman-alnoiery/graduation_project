import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/failuers.dart';
import '../entity/message_entity.dart';
import '../repository/chatbot_repo.dart';

class SendImageUseCase {
  final ChatbotRepo chatbotRepo;
  SendImageUseCase(this.chatbotRepo);

  Future<Either<Failure, MessageEntity>> call(String imagePath) async {
    return await chatbotRepo.sendImage(imagePath);
  }
}
