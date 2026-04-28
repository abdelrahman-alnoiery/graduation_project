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

class ChatbotErrorState extends ChatbotState {
  final String error;
  const ChatbotErrorState(this.error);
}
