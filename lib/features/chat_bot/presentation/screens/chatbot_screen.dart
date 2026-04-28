import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';

import '../../../../core/utils/color_maanger.dart';
import '../bloc/chatbot_bloc.dart';
import '../bloc/chatbot_event.dart';
import '../bloc/chatbot_state.dart';
import 'widgets/chat_input.dart';
import 'widgets/message_bubble.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        backgroundColor: ColorManager.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: ColorManager.textPrimary,
          ),
        ),
        title: Text(
          "Chatbot",
          style: getBoldStyle(
            color: ColorManager.textPrimary,
            fontSize: FontSize.s18,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<ChatbotBloc>().add(const ClearChatEvent());
            },
            icon: const Icon(Icons.delete_outline, color: ColorManager.grey),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Messages List ────────────────────
          Expanded(
            child: BlocConsumer<ChatbotBloc, ChatbotState>(
              listener: (context, state) {
                if (state is ChatbotSuccessState) {
                  _scrollToBottom();
                }
                if (state is ChatbotErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error),
                      backgroundColor: ColorManager.error,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is ChatbotInitialState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.smart_toy_outlined,
                          color: ColorManager.primary,
                          size: AppSize.s60,
                        ),
                        const SizedBox(height: AppSize.s16),
                        Text(
                          "Hi, Abdelrahman",
                          style: getBoldStyle(
                            color: ColorManager.textPrimary,
                            fontSize: FontSize.s20,
                          ),
                        ),
                        const SizedBox(height: AppSize.s8),
                        Text(
                          "How can I help you today?",
                          style: getRegularStyle(
                            color: ColorManager.textSecondary,
                            fontSize: FontSize.s14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (state is ChatbotSuccessState) {
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(AppPadding.p16),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      return MessageBubble(message: state.messages[index]);
                    },
                  );
                }

                if (state is ChatbotLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: ColorManager.primary,
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
          ),

          // ── Chat Input ───────────────────────
          ChatInput(
            onSendMessage: (message) {
              context.read<ChatbotBloc>().add(SendMessageEvent(message));
            },
            onSendImage: (imagePath) {
              context.read<ChatbotBloc>().add(SendImageEvent(imagePath));
            },
          ),
        ],
      ),
    );
  }
}
