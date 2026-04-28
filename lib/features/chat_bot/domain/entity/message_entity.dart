enum MessageType { text, image }

enum MessageSender { user, bot }

class MessageEntity {
  final String id;
  final String content;
  final MessageType type;
  final MessageSender sender;
  final DateTime createdAt;
  final String? imageUrl;

  const MessageEntity({
    required this.id,
    required this.content,
    required this.type,
    required this.sender,
    required this.createdAt,
    this.imageUrl,
  });
}
