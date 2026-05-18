import '../../models/ai_fixing_result_model.dart';
import '../../models/message_model.dart';

abstract class ChatbotRemoteDataSource {
  Future<MessageModel> sendMessage(String message);
  Future<AiFixingResultModel> sendImage(
    String imagePath,
  ); // ✅ تغيير الـ return type
}
