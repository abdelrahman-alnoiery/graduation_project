import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:graduation_project/config/routes_manager/routes.dart';
import 'package:graduation_project/core/cache/shared_pref.dart';
import 'package:graduation_project/core/utils/constants_manager.dart';

import '../../../../core/utils/color_maanger.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigate();
    });
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2, milliseconds: 500));
    if (!mounted) return;

    final bool isOnboardingDone =
        SharedPref.getBool(AppConstants.isOnboardingDone) ?? false;
    final bool isLoggedIn =
        SharedPref.getBool(AppConstants.isLoggedIn) ?? false;

    if (!isOnboardingDone) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.onboarding1Route,
        (route) => false,
      );
    } else if (!isLoggedIn) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.signInRoute,
        (route) => false,
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.homePageLayoutRoute,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [ColorManager.primary, ColorManager.white],
          ),
        ),
        child: Center(
          child: Hero(
            tag: "_logo_",
            child: Image.asset("assets/images/png/Splash.png"),
          ),
        ).animate().fadeIn(duration: const Duration(seconds: 3)),
      ),
    );
  }
}
