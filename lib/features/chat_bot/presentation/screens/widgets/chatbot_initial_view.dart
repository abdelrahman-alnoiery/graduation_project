import 'package:flutter/material.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';

import '../../../../../core/utils/color_maanger.dart';

class ChatbotInitialView extends StatefulWidget {
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
  State<ChatbotInitialView> createState() => _ChatbotInitialViewState();
}

class _ChatbotInitialViewState extends State<ChatbotInitialView>
    with TickerProviderStateMixin {
  late AnimationController _avatarController;
  late AnimationController _cardsController;
  late Animation<double> _avatarScale;
  late Animation<double> _cardsFade;
  late Animation<Offset> _cardsSlide;

  @override
  void initState() {
    super.initState();

    _avatarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _cardsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _avatarScale = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _avatarController, curve: Curves.elasticOut),
    );
    _cardsFade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _cardsController, curve: Curves.easeOut));
    _cardsSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _cardsController, curve: Curves.easeOut));

    _avatarController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _cardsController.forward();
    });
  }

  @override
  void dispose() {
    _avatarController.dispose();
    _cardsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(AppPadding.p20),
      child: Column(
        children: [
          const SizedBox(height: AppSize.s20),

          // ── Animated Avatar ───────────────────
          ScaleTransition(scale: _avatarScale, child: _buildAiAvatar()),

          const SizedBox(height: AppSize.s24),

          // ── Welcome Text ──────────────────────
          FadeTransition(
            opacity: _cardsFade,
            child: SlideTransition(
              position: _cardsSlide,
              child: Column(
                children: [
                  Text(
                    "Hello, ${widget.userName}! 👋",
                    style: getBoldStyle(
                      color: ColorManager.textPrimary,
                      fontSize: FontSize.s24,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: AppSize.s8),

                  Text(
                    "I'm your AI car assistant.\nHow can I help you today?",
                    style: getRegularStyle(
                      color: ColorManager.textSecondary,
                      fontSize: FontSize.s15,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: AppSize.s32),

                  // ── Quick Actions ──────────────
                  Text(
                    "Quick Actions",
                    style: getMediumStyle(
                      color: ColorManager.textSecondary,
                      fontSize: FontSize.s13,
                    ),
                  ),

                  const SizedBox(height: AppSize.s12),

                  // ── Analyze Car ────────────────
                  _buildMainAction(
                    icon: Icons.car_crash_rounded,
                    title: "Analyze Car Damage",
                    subtitle:
                        "Upload a photo to detect damage\nand get repair cost estimate",
                    gradient: const [Color(0xFF1a237e), Color(0xFF3949ab)],
                    onTap: widget.onAnalyzeCarDamage,
                  ),

                  const SizedBox(height: AppSize.s12),

                  // ── Find Parts ─────────────────
                  _buildMainAction(
                    icon: Icons.settings_outlined,
                    title: "Find Car Parts",
                    subtitle:
                        "Get recommendations for\nthe best car accessories",
                    gradient: const [Color(0xFF006064), Color(0xFF00838f)],
                    onTap: widget.onFindParts,
                  ),

                  const SizedBox(height: AppSize.s24),

                  // ── Suggestions ────────────────
                  Text(
                    "Suggested Questions",
                    style: getMediumStyle(
                      color: ColorManager.textSecondary,
                      fontSize: FontSize.s13,
                    ),
                  ),

                  const SizedBox(height: AppSize.s12),

                  Wrap(
                    spacing: AppSize.s8,
                    runSpacing: AppSize.s8,
                    children: [
                      _buildSuggestion("🔧 Best engine oils?"),
                      _buildSuggestion("🚗 Tire maintenance tips"),
                      _buildSuggestion("💡 Car battery check"),
                      _buildSuggestion("🛑 Brake pad lifespan"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiAvatar() {
    return Column(
      children: [
        Container(
          width: AppSize.s100,
          height: AppSize.s100,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
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
          child: Stack(
            alignment: Alignment.center,
            children: [
              // ── Pulse ──────────────────────
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              const Icon(
                Icons.smart_toy_rounded,
                color: Colors.white,
                size: AppSize.s48,
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSize.s12),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.p12,
            vertical: AppPadding.p6,
          ),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppRadius.r50),
            border: Border.all(color: Colors.green.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: AppSize.s8,
                height: AppSize.s8,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSize.s6),
              Text(
                "CarGo AI • Ready to help",
                style: getMediumStyle(
                  color: Colors.green.shade700,
                  fontSize: FontSize.s12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMainAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppPadding.p16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(AppRadius.r16),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppPadding.p12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppRadius.r12),
              ),
              child: Icon(icon, color: Colors.white, size: AppSize.s28),
            ),

            const SizedBox(width: AppSize.s16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: getBoldStyle(
                      color: Colors.white,
                      fontSize: FontSize.s15,
                    ),
                  ),
                  const SizedBox(height: AppSize.s4),
                  Text(
                    subtitle,
                    style: getRegularStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: FontSize.s12,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.all(AppPadding.p8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: AppSize.s18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestion(String text) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p14,
          vertical: AppPadding.p8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.r50),
          border: Border.all(color: const Color(0xFF1a237e).withOpacity(0.15)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          text,
          style: getMediumStyle(
            color: ColorManager.textPrimary,
            fontSize: FontSize.s13,
          ),
        ),
      ),
    );
  }
}
