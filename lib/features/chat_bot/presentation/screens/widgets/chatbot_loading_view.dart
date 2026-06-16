import 'package:flutter/material.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';

import '../../../../../core/utils/color_maanger.dart';
import 'typing_dot.dart';

class ChatbotLoadingView extends StatelessWidget {
  const ChatbotLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── AI Avatar ─────────────────────────
          Container(
            width: AppSize.s80,
            height: AppSize.s80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1a237e), Color(0xFF3949ab)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1a237e).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.smart_toy_rounded,
                color: Colors.white,
                size: AppSize.s40,
              ),
            ),
          ),

          const SizedBox(height: AppSize.s20),

          // ── Typing Indicator ──────────────────
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppPadding.p20,
              vertical: AppPadding.p16,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.r16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "CarGo AI is analyzing",
                  style: getMediumStyle(
                    color: ColorManager.textSecondary,
                    fontSize: FontSize.s13,
                  ),
                ),
                const SizedBox(width: AppSize.s8),
                const TypingDot(delay: 0),
                const SizedBox(width: AppSize.s4),
                const TypingDot(delay: 200),
                const SizedBox(width: AppSize.s4),
                const TypingDot(delay: 400),
              ],
            ),
          ),

          const SizedBox(height: AppSize.s16),

          Text(
            "Please wait...",
            style: getRegularStyle(
              color: ColorManager.textSecondary,
              fontSize: FontSize.s13,
            ),
          ),
        ],
      ),
    );
  }
}
