import 'package:flutter/material.dart';
import 'package:graduation_project/config/routes_manager/routes.dart';
import 'package:graduation_project/core/cache/shared_pref.dart';
import 'package:graduation_project/core/utils/constants_manager.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';

import '../../core/utils/color_maanger.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<String> _images = [
    "assets/images/png/Onboarding1.png",
    "assets/images/png/Onboarding2.png",
    "assets/images/png/Onboarding3.png",
  ];

  final List<String> _titles = [
    "Welcome to CarGo!",
    "Choose Customize Order",
    "Upgrade Your\nCar Experience",
  ];

  final List<String> _subTitles = [
    "Your car needs love! Mechanics & technicians from around our Governorate will provide hobby & expertise.",
    "Explore thousands of car accessories and customize our selection with ease.",
    "Discover premium car accessories, wheels, and parts for your vehicle.",
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextTap() {
    if (_currentIndex < 2) {
      setState(() => _currentIndex++);
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: AppDuration.d300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToSignIn();
    }
  }

  void _navigateToSignIn() async {
    await SharedPref.saveBool(key: AppConstants.isOnboardingDone, value: true);
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.signInRoute,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/png/OnboardingBg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Spacer(),

            // ── PageView ─────────────────────────────
            SizedBox(
              height: AppSize.s600,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _images.length,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      // Image
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppPadding.p28),
                        child: Image.asset(
                          _images[index],
                          height: AppSize.s250,
                        ),
                      ),

                      // Title
                      Text(
                        _titles[index],
                        style: getBoldStyle(
                          color: ColorManager.white,
                          fontSize: FontSize.s32,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: AppSize.s20),

                      // SubTitle
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppPadding.p24,
                        ),
                        child: Text(
                          _subTitles[index],
                          style: getRegularStyle(
                            color: ColorManager.white,
                            fontSize: FontSize.s16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // ── Bottom Navigation ─────────────────────
            Padding(
              padding: const EdgeInsets.only(bottom: AppPadding.p28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Skip Button
                  TextButton(
                    onPressed: _navigateToSignIn,
                    child: Text(
                      'Skip',
                      style: getMediumStyle(
                        color: ColorManager.white,
                        fontSize: FontSize.s18,
                      ),
                    ),
                  ),

                  // Dots Indicator
                  Row(
                    children: List.generate(
                      _images.length,
                      (index) => buildDot(isActive: _currentIndex >= index),
                    ),
                  ),

                  // Next Button
                  Padding(
                    padding: const EdgeInsets.all(AppPadding.p8),
                    child: Container(
                      height: AppSize.s60,
                      width: AppSize.s60,
                      decoration: const BoxDecoration(
                        color: ColorManager.white,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: _onNextTap,
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          size: AppSize.s24,
                          color: ColorManager.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Dot Indicator ─────────────────────────────────
  Widget buildDot({required bool isActive}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: isActive ? 60 : 40,
      height: 5,
      decoration: BoxDecoration(
        color: isActive ? Color(0xff162B5C) : Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
