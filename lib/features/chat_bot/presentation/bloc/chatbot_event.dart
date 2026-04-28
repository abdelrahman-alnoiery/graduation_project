abstract class ChatbotEvent {
  const ChatbotEvent();
}

class SendMessageEvent extends ChatbotEvent {
  final String message;
  const SendMessageEvent(this.message);
}

class SendImageEvent extends ChatbotEvent {
  final String imagePath;
  const SendImageEvent(this.imagePath);
}

class ClearChatEvent extends ChatbotEvent {
  const ClearChatEvent();
}
