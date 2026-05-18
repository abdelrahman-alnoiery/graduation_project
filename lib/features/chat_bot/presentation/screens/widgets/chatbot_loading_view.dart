import 'package:flutter/material.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';

import '../../../../../core/utils/color_maanger.dart';

class ChatbotLoadingView extends StatelessWidget {
  const ChatbotLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: ColorManager.primary),
          const SizedBox(height: AppSize.s16),
          Text(
            "AI is analyzing your image...\nThis may take up to 60 seconds",
            style: getRegularStyle(
              color: ColorManager.textSecondary,
              fontSize: FontSize.s14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
