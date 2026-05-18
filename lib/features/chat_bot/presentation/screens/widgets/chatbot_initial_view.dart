import 'package:flutter/material.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';

import '../../../../../core/utils/color_maanger.dart';
import 'quick_action_card.dart';

class ChatbotInitialView extends StatelessWidget {
  final String userName;
  final VoidCallback onAnalyzeCarDamage;
  final VoidCallback onFindParts;

  const ChatbotInitialView({
    super.key,
    required this.userName,
    required this.onAnalyzeCarDamage,
    required this.onFindParts,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: IntrinsicHeight(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Bot Icon ─────────────────────
              Container(
                padding: const EdgeInsets.all(AppPadding.p20),
                decoration: BoxDecoration(
                  color: ColorManager.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.smart_toy_outlined,
                  color: ColorManager.primary,
                  size: AppSize.s60,
                ),
              ),

              const SizedBox(height: AppSize.s16),

              // ── Greeting ──────────────────────
              Text(
                "Hi, $userName 👋",
                style: getBoldStyle(
                  color: ColorManager.textPrimary,
                  fontSize: FontSize.s24,
                ),
              ),

              const SizedBox(height: AppSize.s8),

              Text(
                "Send a message or image\nto get started",
                style: getRegularStyle(
                  color: ColorManager.textSecondary,
                  fontSize: FontSize.s14,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSize.s24),

              // ── Quick Actions ─────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppPadding.p32),
                child: Column(
                  children: [
                    QuickActionCard(
                      icon: Icons.car_repair,
                      title: "Analyze Car Damage",
                      subtitle: "Upload a photo of your car",
                      onTap: onAnalyzeCarDamage,
                    ),
                    const SizedBox(height: AppSize.s12),
                    QuickActionCard(
                      icon: Icons.search,
                      title: "Find Parts",
                      subtitle: "Ask about car accessories",
                      onTap: onFindParts,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSize.s16),
            ],
          ),
        ),
      ),
    );
  }
}
