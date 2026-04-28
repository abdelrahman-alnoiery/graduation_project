import 'package:flutter/material.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';

import '../../../../../core/utils/color_maanger.dart';
import '../../../domain/entity/message_entity.dart';

class MessageBubble extends StatelessWidget {
  final MessageEntity message;

  const MessageBubble({super.key, required this.message});

  bool get isUser => message.sender == MessageSender.user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppPadding.p4),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) _buildAvatar(),
          const SizedBox(width: AppSize.s8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppPadding.p12,
                vertical: AppPadding.p8,
              ),
              decoration: BoxDecoration(
                color: isUser ? ColorManager.primary : ColorManager.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(AppRadius.r16),
                  topRight: const Radius.circular(AppRadius.r16),
                  bottomLeft: isUser
                      ? const Radius.circular(AppRadius.r16)
                      : Radius.zero,
                  bottomRight: isUser
                      ? Radius.zero
                      : const Radius.circular(AppRadius.r16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: ColorManager.grey.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: message.type == MessageType.image
                  ? _buildImageMessage()
                  : _buildTextMessage(),
            ),
          ),
          const SizedBox(width: AppSize.s8),
          if (isUser) _buildAvatar(),
        ],
      ),
    );
  }

  Widget _buildTextMessage() {
    return Text(
      message.content,
      style: getRegularStyle(
        color: isUser ? ColorManager.white : ColorManager.textPrimary,
        fontSize: FontSize.s14,
      ),
    );
  }

  Widget _buildImageMessage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.r8),
      child: Image.network(
        message.imageUrl ?? '',
        width: AppSize.s200,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(
          Icons.image_not_supported_outlined,
          color: ColorManager.grey,
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: AppSize.s16,
      backgroundColor: isUser ? ColorManager.primary : ColorManager.lightGrey,
      child: Icon(
        isUser ? Icons.person : Icons.smart_toy_outlined,
        color: isUser ? ColorManager.white : ColorManager.primary,
        size: AppSize.s16,
      ),
    );
  }
}
