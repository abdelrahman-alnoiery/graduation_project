import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/core/cache/shared_pref.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';
import 'package:graduation_project/features/chat_bot/presentation/screens/widgets/chatbot_initial_view.dart';
import 'package:graduation_project/features/chat_bot/presentation/screens/widgets/chatbot_loading_view.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/utils/color_maanger.dart';
import '../bloc/chatbot_bloc.dart';
import '../bloc/chatbot_event.dart';
import '../bloc/chatbot_state.dart';
import 'widgets/ai_fixing_result.dart';
import 'widgets/chat_input.dart';
import 'widgets/message_bubble.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  String get _userName => SharedPref.getString('user_name') ?? 'there';

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

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null && mounted) {
        context.read<ChatbotBloc>().add(SendImageEvent(image.path));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to pick image"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
          // ── Messages List ──────────────────────
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
                // ── Initial ──────────────────────
                if (state is ChatbotInitialState) {
                  return ChatbotInitialView(
                    userName: _userName,
                    onAnalyzeCarDamage: _pickImageFromGallery,
                    onFindParts: () {
                      context.read<ChatbotBloc>().add(
                        const SendMessageEvent(
                          "What car parts do you recommend?",
                        ),
                      );
                    },
                  );
                }

                // ── Loading ──────────────────────
                if (state is ChatbotLoadingState) {
                  return const ChatbotLoadingView();
                }

                // ── AI Fixing Result ──────────────
                if (state is AiFixingSuccessState) {
                  return SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(AppPadding.p16),
                    child: AiFixingResult(result: state.result),
                  );
                }

                // ── Messages ──────────────────────
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

                return const SizedBox();
              },
            ),
          ),

          // ── Chat Input ─────────────────────────
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
