import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/failuers.dart';
import '../../data/models/ai_fixing_result_model.dart';
import '../repository/chatbot_repo.dart';

class SendImageUseCase {
  final ChatbotRepo chatbotRepo;
  SendImageUseCase(this.chatbotRepo);

  Future<Either<Failure, AiFixingResultModel>> call(String imagePath) async {
    return await chatbotRepo.sendImage(imagePath);
  }
}
