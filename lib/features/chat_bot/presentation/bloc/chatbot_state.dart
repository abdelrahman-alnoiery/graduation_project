import '../../data/models/ai_fixing_result_model.dart';
import '../../domain/entity/message_entity.dart';

abstract class ChatbotState {
  const ChatbotState();
}

class ChatbotInitialState extends ChatbotState {
  const ChatbotInitialState();
}

class ChatbotLoadingState extends ChatbotState {
  const ChatbotLoadingState();
}

class ChatbotSuccessState extends ChatbotState {
  final List<MessageEntity> messages;
  const ChatbotSuccessState(this.messages);
}

class AiFixingSuccessState extends ChatbotState {
  final AiFixingResultModel result; // ✅ state جديد للـ AI
  const AiFixingSuccessState(this.result);
}

class ChatbotErrorState extends ChatbotState {
  final String error;
  const ChatbotErrorState(this.error);
}
