import '../../models/message_model.dart';

abstract class ChatbotRemoteDataSource {
  Future<MessageModel> sendMessage(String message);
  Future<MessageModel> sendImage(String imagePath);
}
