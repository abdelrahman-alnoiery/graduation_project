import 'package:flutter/material.dart';
import 'package:graduation_project/core/utils/values_manager.dart';
import 'package:image_picker/image_picker.dart';

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
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      widget.onSendImage(image.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p12,
        vertical: AppPadding.p8,
      ),
      decoration: BoxDecoration(
        color: ColorManager.white,
        boxShadow: [
          BoxShadow(
            color: ColorManager.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Mic Icon ───────────────────────
          const Icon(Icons.mic_outlined, color: ColorManager.grey),

          const SizedBox(width: AppSize.s8),

          // ── Text Field ─────────────────────
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p12),
              decoration: BoxDecoration(
                color: ColorManager.lightGrey,
                borderRadius: BorderRadius.circular(AppRadius.r50),
              ),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: "Ask Me...",
                  hintStyle: TextStyle(color: ColorManager.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          const SizedBox(width: AppSize.s8),

          // ── Send / Image Button ────────────
          GestureDetector(
            onTap: () {
              if (_controller.text.isNotEmpty) {
                widget.onSendMessage(_controller.text.trim());
                _controller.clear();
              } else {
                _pickImage();
              }
            },
            child: Container(
              padding: const EdgeInsets.all(AppPadding.p8),
              decoration: const BoxDecoration(
                color: ColorManager.primary,
                shape: BoxShape.circle,
              ),
              child: ValueListenableBuilder(
                valueListenable: _controller,
                builder: (context, value, _) {
                  return Icon(
                    value.text.isNotEmpty ? Icons.send : Icons.add,
                    color: ColorManager.white,
                    size: AppSize.s20,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
