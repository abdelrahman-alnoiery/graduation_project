import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';
import 'package:graduation_project/features/chat_bot/domain/entity/message_entity.dart';

import '../../../../../core/utils/color_maanger.dart';

class MessageBubble extends StatelessWidget {
  final MessageEntity message;

  const MessageBubble({super.key, required this.message});

  bool get isUser => message.sender == MessageSender.user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppPadding.p12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          // ── Bot Avatar ────────────────────────
          if (!isUser) ...[
            Container(
              width: AppSize.s32,
              height: AppSize.s32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1a237e), Color(0xFF3949ab)],
                ),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.smart_toy_rounded,
                  color: Colors.white,
                  size: AppSize.s18,
                ),
              ),
            ),
            const SizedBox(width: AppSize.s8),
          ],

          // ── Bubble ────────────────────────────
          Flexible(
            child: Column(
              crossAxisAlignment: isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: message.type == MessageType.image
                      ? EdgeInsets.zero
                      : const EdgeInsets.symmetric(
                          horizontal: AppPadding.p16,
                          vertical: AppPadding.p12,
                        ),
                  decoration: BoxDecoration(
                    gradient: isUser
                        ? const LinearGradient(
                            colors: [Color(0xFF1a237e), Color(0xFF3949ab)],
                          )
                        : null,
                    color: isUser ? null : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(AppRadius.r16),
                      topRight: const Radius.circular(AppRadius.r16),
                      bottomLeft: Radius.circular(
                        isUser ? AppRadius.r16 : AppRadius.r4,
                      ),
                      bottomRight: Radius.circular(
                        isUser ? AppRadius.r4 : AppRadius.r16,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isUser
                            ? const Color(0xFF1a237e).withOpacity(0.2)
                            : Colors.grey.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: message.type == MessageType.image
                      ? _buildImageMessage()
                      : _buildTextMessage(),
                ),

                // ── Time ──────────────────────
                const SizedBox(height: AppSize.s4),
                Text(
                  _formatTime(message.createdAt),
                  style: getRegularStyle(
                    color: ColorManager.textSecondary,
                    fontSize: FontSize.s10,
                  ),
                ),
              ],
            ),
          ),

          // ── User Avatar ───────────────────────
          if (isUser) ...[
            const SizedBox(width: AppSize.s8),
            Container(
              width: AppSize.s32,
              height: AppSize.s32,
              decoration: BoxDecoration(
                color: const Color(0xFF1a237e).withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF1a237e).withOpacity(0.3),
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.person_rounded,
                  color: Color(0xFF1a237e),
                  size: AppSize.s18,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── Text Message ──────────────────────────────────
  Widget _buildTextMessage() {
    return MarkdownBody(
      data: message.content,
      selectable: true,
      styleSheet: MarkdownStyleSheet(
        p: TextStyle(
          color: isUser ? Colors.white : ColorManager.textPrimary,
          fontSize: FontSize.s14,
        ),
        strong: TextStyle(
          color: isUser ? Colors.white : ColorManager.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ── Image Message ─────────────────────────────────
  Widget _buildImageMessage() {
    final imageUrl = message.imageUrl ?? '';
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.r16),
      child: imageUrl.startsWith('http')
          ? Image.network(
              imageUrl,
              width: AppSize.s200,
              height: AppSize.s150,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildImageError(),
            )
          : Image.file(
              File(imageUrl),
              width: AppSize.s200,
              height: AppSize.s150,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildImageError(),
            ),
    );
  }

  // ── Image Error ───────────────────────────────────
  Widget _buildImageError() {
    return Container(
      width: AppSize.s200,
      height: AppSize.s150,
      color: ColorManager.lightGrey,
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: ColorManager.grey,
          size: AppSize.s32,
        ),
      ),
    );
  }

  // ── Format Time ───────────────────────────────────
  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
