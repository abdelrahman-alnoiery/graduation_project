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
  DateTime? _lastImageRequest;
  bool _isProcessingImage = false; // ✅ منع الطلبات المتزامنة

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
    _messages.add(MessageModel.userText(event.message));
    emit(ChatbotSuccessState(List.from(_messages)));

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

  // ── Send Image (AI Fixing) ────────────────────────
  Future<void> _onSendImage(
    SendImageEvent event,
    Emitter<ChatbotState> emit,
  ) async {
    // ── منع الطلبات المتزامنة ──────────────────────
    if (_isProcessingImage) {
      emit(
        const ChatbotErrorState(
          "Please wait for the current analysis to finish",
        ),
      );
      emit(ChatbotSuccessState(List.from(_messages)));
      return;
    }

    // ── Cooldown بين الطلبات ───────────────────────
    final now = DateTime.now();
    if (_lastImageRequest != null) {
      final diff = now.difference(_lastImageRequest!).inSeconds;
      if (diff < 15) {
        final remaining = 15 - diff;
        emit(
          ChatbotErrorState(
            "Please wait $remaining seconds before sending another image",
          ),
        );
        emit(ChatbotSuccessState(List.from(_messages)));
        return;
      }
    }

    _isProcessingImage = true;
    _lastImageRequest = now;

    // ── Add user image message ─────────────────────
    _messages.add(MessageModel.userImage(event.imagePath));
    emit(ChatbotSuccessState(List.from(_messages)));
    emit(const ChatbotLoadingState());

    // ── Send to AI API ─────────────────────────────
    final result = await sendImageUseCase(event.imagePath);
    _isProcessingImage = false;

    result.fold((failure) {
      // ── إضافة رسالة خطأ من الـ Bot ────────────
      _messages.add(
        MessageModel.bot(
          "Sorry, I couldn't analyze your image. Please try again. 🔄",
        ),
      );
      emit(ChatbotSuccessState(List.from(_messages)));
    }, (aiResult) => emit(AiFixingSuccessState(aiResult)));
  }

  // ── Clear Chat ────────────────────────────────────
  void _onClearChat(ClearChatEvent event, Emitter<ChatbotState> emit) {
    _messages.clear();
    _isProcessingImage = false;
    // ✅ مش بنمسح الـ _lastImageRequest عشان الـ cooldown يفضل شغال
    emit(const ChatbotInitialState());
  }
}
