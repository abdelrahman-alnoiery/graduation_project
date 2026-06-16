import 'package:flutter/material.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';

import '../../../../../core/utils/color_maanger.dart';

class ChatInput extends StatefulWidget {
  final Function(String) onSendMessage;
  final Function(String) onSendImage;

  const ChatInput({
    super.key,
    required this.onSendMessage,
    required this.onSendImage,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() => _hasText = _controller.text.trim().isNotEmpty);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSendMessage(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppPadding.p16,
        right: AppPadding.p16,
        bottom: MediaQuery.of(context).padding.bottom + AppPadding.p12,
        top: AppPadding.p8,
      ),
      child: Row(
        children: [
          // ── Text Field ────────────────────────
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF0F2F8),
                borderRadius: BorderRadius.circular(AppRadius.r50),
                border: Border.all(
                  color: const Color(0xFF1a237e).withOpacity(0.1),
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: AppSize.s16),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: "Ask CarGo AI...",
                        hintStyle: getRegularStyle(
                          color: ColorManager.grey,
                          fontSize: FontSize.s14,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: AppPadding.p12,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: AppSize.s8),
                ],
              ),
            ),
          ),

          const SizedBox(width: AppSize.s8),

          // ── Send Button ───────────────────────
          GestureDetector(
            onTap: _hasText ? _sendMessage : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: AppSize.s48,
              height: AppSize.s48,
              decoration: BoxDecoration(
                gradient: _hasText
                    ? const LinearGradient(
                        colors: [Color(0xFF1a237e), Color(0xFF3949ab)],
                      )
                    : null,
                color: _hasText ? null : Colors.grey.withOpacity(0.2),
                shape: BoxShape.circle,
                boxShadow: _hasText
                    ? [
                        BoxShadow(
                          color: const Color(0xFF1a237e).withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                Icons.send_rounded,
                color: _hasText ? Colors.white : Colors.grey,
                size: AppSize.s20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
