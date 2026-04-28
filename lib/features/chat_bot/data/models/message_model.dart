import '../../domain/entity/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.content,
    required super.type,
    required super.sender,
    required super.createdAt,
    super.imageUrl,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id']?.toString() ?? '',
      content: json['content'] ?? '',
      type: json['type'] == 'image' ? MessageType.image : MessageType.text,
      sender: json['sender'] == 'user' ? MessageSender.user : MessageSender.bot,
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'type': type == MessageType.image ? 'image' : 'text',
      'sender': sender == MessageSender.user ? 'user' : 'bot',
      'created_at': createdAt.toIso8601String(),
      'image_url': imageUrl,
    };
  }

  // ── User Text Message ─────────────────────────────
  factory MessageModel.userText(String content) {
    return MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      type: MessageType.text,
      sender: MessageSender.user,
      createdAt: DateTime.now(),
    );
  }

  // ── User Image Message ────────────────────────────
  factory MessageModel.userImage(String imageUrl) {
    return MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: '',
      type: MessageType.image,
      sender: MessageSender.user,
      createdAt: DateTime.now(),
      imageUrl: imageUrl,
    );
  }

  // ── Bot Message ───────────────────────────────────
  factory MessageModel.bot(String content) {
    return MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      type: MessageType.text,
      sender: MessageSender.bot,
      createdAt: DateTime.now(),
    );
  }
}
