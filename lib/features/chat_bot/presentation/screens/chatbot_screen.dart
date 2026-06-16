import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/core/cache/shared_pref.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/utils/color_maanger.dart';
import '../bloc/chatbot_bloc.dart';
import '../bloc/chatbot_event.dart';
import '../bloc/chatbot_state.dart';
import 'widgets/ai_fixing_result.dart';
import 'widgets/chat_input.dart';
import 'widgets/chatbot_initial_view.dart';
import 'widgets/chatbot_loading_view.dart';
import 'widgets/message_bubble.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  late AnimationController _headerController;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;

  String get _userName => SharedPref.getString('user_name') ?? 'there';

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _headerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
    );
    _headerSlide = Tween<Offset>(begin: const Offset(0, -0.2), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
        );
    _headerController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _headerController.dispose();
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
          SnackBar(
            content: const Text("Failed to pick image"),
            backgroundColor: ColorManager.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.r12),
            ),
          ),
        );
      }
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (image != null && mounted) {
        context.read<ChatbotBloc>().add(SendImageEvent(image.path));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Failed to open camera"),
            backgroundColor: ColorManager.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.r12),
            ),
          ),
        );
      }
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(AppPadding.p24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppRadius.r24),
            topRight: Radius.circular(AppRadius.r24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Handle ──────────────────────────
            Container(
              width: AppSize.s40,
              height: AppSize.s4,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(AppRadius.r4),
              ),
            ),

            const SizedBox(height: AppSize.s20),

            Text(
              "Select Image Source",
              style: getBoldStyle(
                color: ColorManager.textPrimary,
                fontSize: FontSize.s18,
              ),
            ),

            const SizedBox(height: AppSize.s8),

            Text(
              "Choose how to upload your car image",
              style: getRegularStyle(
                color: ColorManager.textSecondary,
                fontSize: FontSize.s13,
              ),
            ),

            const SizedBox(height: AppSize.s24),

            Row(
              children: [
                // ── Camera ──────────────────────
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(ctx);
                      _pickImageFromCamera();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppPadding.p20,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1a237e), Color(0xFF3949ab)],
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.r16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1a237e).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                            size: AppSize.s32,
                          ),
                          const SizedBox(height: AppSize.s8),
                          Text(
                            "Camera",
                            style: getMediumStyle(
                              color: Colors.white,
                              fontSize: FontSize.s14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: AppSize.s16),

                // ── Gallery ──────────────────────
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(ctx);
                      _pickImageFromGallery();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppPadding.p20,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F2F8),
                        borderRadius: BorderRadius.circular(AppRadius.r16),
                        border: Border.all(
                          color: const Color(0xFF1a237e).withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.photo_library_rounded,
                            color: const Color(0xFF1a237e),
                            size: AppSize.s32,
                          ),
                          const SizedBox(height: AppSize.s8),
                          Text(
                            "Gallery",
                            style: getMediumStyle(
                              color: const Color(0xFF1a237e),
                              fontSize: FontSize.s14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSize.s16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF0F2F8),
      body: Column(
        children: [
          // ── Animated Header ───────────────────
          FadeTransition(
            opacity: _headerFade,
            child: SlideTransition(
              position: _headerSlide,
              child: _buildHeader(context),
            ),
          ),

          // ── Messages ──────────────────────────
          Expanded(
            child: BlocConsumer<ChatbotBloc, ChatbotState>(
              listener: (context, state) {
                if (state is ChatbotSuccessState) {
                  _scrollToBottom();
                }
                if (state is ChatbotErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.white),
                          const SizedBox(width: 8),
                          Expanded(child: Text(state.error)),
                        ],
                      ),
                      backgroundColor: ColorManager.error,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.r12),
                      ),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is ChatbotInitialState) {
                  return ChatbotInitialView(
                    userName: _userName,
                    onAnalyzeCarDamage: _showImageSourceDialog,
                    onFindParts: () {
                      context.read<ChatbotBloc>().add(
                        const SendMessageEvent(
                          "What car parts do you recommend?",
                        ),
                      );
                    },
                  );
                }

                if (state is ChatbotLoadingState) {
                  return const ChatbotLoadingView();
                }

                if (state is AiFixingSuccessState) {
                  return SingleChildScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(AppPadding.p16),
                    child: Column(
                      children: [
                        // ── Back to chat button ──
                        GestureDetector(
                          onTap: () {
                            context.read<ChatbotBloc>().add(
                              const ClearChatEvent(),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: AppPadding.p12,
                              horizontal: AppPadding.p16,
                            ),
                            margin: const EdgeInsets.only(
                              bottom: AppMargin.m16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                AppRadius.r12,
                              ),
                              border: Border.all(
                                color: const Color(0xFF1a237e).withOpacity(0.2),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.arrow_back_rounded,
                                  color: const Color(0xFF1a237e),
                                  size: AppSize.s20,
                                ),
                                const SizedBox(width: AppSize.s8),
                                Text(
                                  "Back to Chat",
                                  style: getMediumStyle(
                                    color: const Color(0xFF1a237e),
                                    fontSize: FontSize.s14,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppPadding.p8,
                                    vertical: AppPadding.p4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF1a237e,
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(
                                      AppRadius.r50,
                                    ),
                                  ),
                                  child: Text(
                                    "AI Result",
                                    style: getMediumStyle(
                                      color: const Color(0xFF1a237e),
                                      fontSize: FontSize.s11,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        AiFixingResult(result: state.result),
                      ],
                    ),
                  );
                }

                if (state is ChatbotSuccessState) {
                  return ListView.builder(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                      AppPadding.p16,
                      AppPadding.p16,
                      AppPadding.p16,
                      AppPadding.p8,
                    ),
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

          // ── Chat Input ────────────────────────
          _buildChatInput(context),
        ],
      ),
    );
  }

  // ── Header ────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1a237e), Color(0xFF3949ab)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.r32),
          bottomRight: Radius.circular(AppRadius.r32),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x441a237e),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // ── Decorative circles ────────────────
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppPadding.p16,
              AppPadding.p48,
              AppPadding.p16,
              AppPadding.p20,
            ),
            child: Row(
              children: [
                // ── Back ──────────────────────
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(AppPadding.p8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(AppRadius.r12),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.white,
                      size: AppSize.s20,
                    ),
                  ),
                ),

                const SizedBox(width: AppSize.s12),

                // ── AI Avatar ─────────────────
                Container(
                  width: AppSize.s44,
                  height: AppSize.s44,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.4),
                      width: 2,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.smart_toy_rounded,
                      color: Colors.white,
                      size: AppSize.s24,
                    ),
                  ),
                ),

                const SizedBox(width: AppSize.s12),

                // ── Title ─────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "CarGo AI",
                        style: getBoldStyle(
                          color: Colors.white,
                          fontSize: FontSize.s18,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: AppSize.s8,
                            height: AppSize.s8,
                            decoration: const BoxDecoration(
                              color: Colors.greenAccent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: AppSize.s4),
                          Text(
                            "Online • Car Damage Expert",
                            style: getRegularStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: FontSize.s12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ── Clear ─────────────────────
                GestureDetector(
                  onTap: () => _showClearDialog(context),
                  child: Container(
                    padding: const EdgeInsets.all(AppPadding.p8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(AppRadius.r12),
                    ),
                    child: const Icon(
                      Icons.refresh_rounded,
                      color: Colors.white,
                      size: AppSize.s20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Chat Input ────────────────────────────────────
  Widget _buildChatInput(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Image Source Buttons ──────────────
          BlocBuilder<ChatbotBloc, ChatbotState>(
            builder: (context, state) {
              if (state is! AiFixingSuccessState) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppPadding.p16,
                    AppPadding.p12,
                    AppPadding.p16,
                    AppPadding.p4,
                  ),
                  child: GestureDetector(
                    onTap: _showImageSourceDialog,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppPadding.p10,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1a237e), Color(0xFF3949ab)],
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.r12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.camera_enhance_rounded,
                            color: Colors.white,
                            size: AppSize.s18,
                          ),
                          const SizedBox(width: AppSize.s8),
                          Text(
                            "Analyze Car Damage",
                            style: getMediumStyle(
                              color: Colors.white,
                              fontSize: FontSize.s13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),

          // ── Text Input ───────────────────────
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

  // ── Clear Dialog ──────────────────────────────────
  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r24),
        ),
        child: Container(
          padding: const EdgeInsets.all(AppPadding.p24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.r24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppPadding.p16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1a237e).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.refresh_rounded,
                  color: Color(0xFF1a237e),
                  size: AppSize.s36,
                ),
              ),

              const SizedBox(height: AppSize.s16),

              Text(
                "Start New Chat",
                style: getBoldStyle(
                  color: ColorManager.textPrimary,
                  fontSize: FontSize.s20,
                ),
              ),

              const SizedBox(height: AppSize.s8),

              Text(
                "This will clear the current\nconversation history",
                style: getRegularStyle(
                  color: ColorManager.textSecondary,
                  fontSize: FontSize.s14,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSize.s24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                        padding: const EdgeInsets.symmetric(
                          vertical: AppPadding.p14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.r12),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: getMediumStyle(
                          color: ColorManager.textSecondary,
                          fontSize: FontSize.s14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSize.s12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        context.read<ChatbotBloc>().add(const ClearChatEvent());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1a237e),
                        padding: const EdgeInsets.symmetric(
                          vertical: AppPadding.p14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.r12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "Clear",
                        style: getBoldStyle(
                          color: Colors.white,
                          fontSize: FontSize.s14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
