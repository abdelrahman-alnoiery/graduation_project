import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/message_model.dart';
import '../../domain/entity/message_entity.dart';
import '../../domain/usecases/send_image_usecase.dart';
import '../../domain/usecases/send_message_usecase.dart';
import 'chatbot_event.dart';
import 'chatbot_state.dart';

class ChatbotBloc extends Bloc<ChatbotEvent, ChatbotState> {
  final SendMessageUseCase sendMessageUseCase;
  final SendImageUseCase sendImageUseCase;

  final List<MessageEntity> _messages = [];

  ChatbotBloc({
    required this.sendMessageUseCase,
    required this.sendImageUseCase,
  }) : super(const ChatbotInitialState()) {
    on<SendMessageEvent>(_onSendMessage);
    on<SendImageEvent>(_onSendImage);
    on<ClearChatEvent>(_onClearChat);
  }

  // ── Send Message ──────────────────────────────────
  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatbotState> emit,
  ) async {
    // Add user message
    _messages.add(MessageModel.userText(event.message));
    emit(ChatbotSuccessState(List.from(_messages)));

    // Send to API
    emit(const ChatbotLoadingState());
    final result = await sendMessageUseCase(event.message);
    result.fold(
      (failure) {
        emit(ChatbotErrorState(failure.message));
        emit(ChatbotSuccessState(List.from(_messages)));
      },
      (botMessage) {
        _messages.add(botMessage);
        emit(ChatbotSuccessState(List.from(_messages)));
      },
    );
  }

  // ── Send Image ────────────────────────────────────
  Future<void> _onSendImage(
    SendImageEvent event,
    Emitter<ChatbotState> emit,
  ) async {
    // Add user image message
    _messages.add(MessageModel.userImage(event.imagePath));
    emit(ChatbotSuccessState(List.from(_messages)));

    // Send to API
    emit(const ChatbotLoadingState());
    final result = await sendImageUseCase(event.imagePath);
    result.fold(
      (failure) {
        emit(ChatbotErrorState(failure.message));
        emit(ChatbotSuccessState(List.from(_messages)));
      },
      (botMessage) {
        _messages.add(botMessage);
        emit(ChatbotSuccessState(List.from(_messages)));
      },
    );
  }

  // ── Clear Chat ────────────────────────────────────
  void _onClearChat(ClearChatEvent event, Emitter<ChatbotState> emit) {
    _messages.clear();
    emit(const ChatbotInitialState());
  }
}
