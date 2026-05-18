import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/failuers.dart';
import '../../data/models/ai_fixing_result_model.dart';
import '../entity/message_entity.dart';

abstract class ChatbotRepo {
  Future<Either<Failure, MessageEntity>> sendMessage(String message);
  Future<Either<Failure, AiFixingResultModel>> sendImage(
    String imagePath,
  ); // ✅ تغيير
}
