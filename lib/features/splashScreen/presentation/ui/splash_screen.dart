import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduation_project/config/routes_manager/routes.dart';
import 'package:graduation_project/core/cache/shared_pref.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ── Animation Controllers ─────────────────────────
  late AnimationController _bgController;
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _dotsController;
  late AnimationController _carController;

  // ── Animations ────────────────────────────────────
  late Animation<double> _bgScale;
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<Offset> _logoSlide;
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;
  late Animation<double> _dotsFade;
  late Animation<Offset> _carSlide;
  late Animation<double> _carFade;
  late Animation<double> _shimmer;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    _initAnimations();
    _startAnimations();
    _navigate();
  }

  void _initAnimations() {
    // ── Background ────────────────────────────────
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _bgScale = Tween<double>(
      begin: 1.3,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _bgController, curve: Curves.easeOut));

    // ── Logo ──────────────────────────────────────
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _logoSlide = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeOut));

    // ── Text ──────────────────────────────────────
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _textFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    // ── Dots ──────────────────────────────────────
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _dotsFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _dotsController, curve: Curves.easeOut));

    // ── Car ───────────────────────────────────────
    _carController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _carSlide = Tween<Offset>(
      begin: const Offset(-1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _carController, curve: Curves.easeOut));
    _carFade = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _carController, curve: Curves.easeOut));

    // ── Shimmer ───────────────────────────────────
    _shimmer = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  void _startAnimations() async {
    _bgController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    _carController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _textController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _dotsController.forward();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    if (!mounted) return;

    final isLoggedIn = SharedPref.getBool('is_logged_in') ?? false;
    Navigator.pushReplacementNamed(
      context,
      isLoggedIn ? Routes.homePageLayoutRoute : Routes.onboarding1Route,
    );
  }

  @override
  void dispose() {
    _bgController.dispose();
    _logoController.dispose();
    _textController.dispose();
    _dotsController.dispose();
    _carController.dispose();
    (_shimmer as AnimationController).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _bgController,
          _logoController,
          _textController,
          _dotsController,
          _carController,
          _shimmer,
        ]),
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0d1b4b),
                  Color(0xFF1a237e),
                  Color(0xFF283593),
                ],
              ),
            ),
            child: Stack(
              children: [
                // ── Animated BG Circles ──────────
                ..._buildBgCircles(size),

                // ── Road Line ────────────────────
                _buildRoadLine(size),

                // ── Car ──────────────────────────
                _buildCar(size),

                // ── Center Content ───────────────
                _buildCenterContent(size),

                // ── Bottom Loading ────────────────
                _buildBottomLoading(size),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── Background Circles ────────────────────────────
  List<Widget> _buildBgCircles(Size size) {
    return [
      Positioned(
        top: -80,
        right: -60,
        child: ScaleTransition(
          scale: _bgScale,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.04),
            ),
          ),
        ),
      ),
      Positioned(
        bottom: -100,
        left: -80,
        child: ScaleTransition(
          scale: _bgScale,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.03),
            ),
          ),
        ),
      ),
      Positioned(
        top: size.height * 0.3,
        left: -40,
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.03),
          ),
        ),
      ),
      // ── Shimmer Line ──────────────────────────
      Positioned(
        top: 0,
        left: -size.width + (_shimmer.value * size.width * 2),
        child: Container(
          width: size.width * 0.4,
          height: size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.white.withOpacity(0.03),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    ];
  }

  // ── Road Line ─────────────────────────────────────
  Widget _buildRoadLine(Size size) {
    return Positioned(
      bottom: size.height * 0.18,
      left: 0,
      right: 0,
      child: FadeTransition(
        opacity: _carFade,
        child: Container(
          height: 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.white.withOpacity(0.2),
                Colors.white.withOpacity(0.3),
                Colors.white.withOpacity(0.2),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Car ───────────────────────────────────────────
  Widget _buildCar(Size size) {
    return Positioned(
      bottom: size.height * 0.19,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: _carSlide,
        child: FadeTransition(
          opacity: _carFade,
          child: Center(
            child: Column(
              children: [
                // ── Car Icon ──────────────────
                Icon(
                  Icons.directions_car_rounded,
                  color: Colors.white.withOpacity(0.9),
                  size: 80,
                ),
                // ── Car Shadow ────────────────
                Container(
                  width: 80,
                  height: 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    gradient: RadialGradient(
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Center Content ────────────────────────────────
  Widget _buildCenterContent(Size size) {
    return Positioned(
      top: size.height * 0.28,
      left: 0,
      right: 0,
      child: Column(
        children: [
          // ── Logo Circle ───────────────────────
          ScaleTransition(
            scale: _logoScale,
            child: FadeTransition(
              opacity: _logoFade,
              child: SlideTransition(
                position: _logoSlide,
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF3949ab), Color(0xFF1a237e)],
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1a237e).withOpacity(0.6),
                        blurRadius: 30,
                        spreadRadius: 5,
                        offset: const Offset(0, 10),
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: -5,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // ── Inner glow ──────────
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                      const Icon(
                        Icons.directions_car_rounded,
                        color: Colors.white,
                        size: 52,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: AppSize.s24),

          // ── App Name ──────────────────────────
          FadeTransition(
            opacity: _textFade,
            child: SlideTransition(
              position: _textSlide,
              child: Column(
                children: [
                  // ── CarGo Text ────────────────
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.white, Color(0xFFB0BEC5), Colors.white],
                    ).createShader(bounds),
                    child: Text(
                      "CarGo",
                      style: getBoldStyle(color: Colors.white, fontSize: 52)
                          .copyWith(
                            fontStyle: FontStyle.italic,
                            letterSpacing: 2,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                    ),
                  ),

                  const SizedBox(height: AppSize.s8),

                  // ── Tagline ───────────────────
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.p16,
                      vertical: AppPadding.p6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppRadius.r50),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Text(
                      "Your Smart Car Companion",
                      style: getMediumStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: FontSize.s13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: AppSize.s20),

                  // ── Feature Tags ──────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTag(Icons.search_rounded, "Find Parts"),
                      const SizedBox(width: AppSize.s8),
                      _buildTag(Icons.car_crash_rounded, "AI Damage"),
                      const SizedBox(width: AppSize.s8),
                      _buildTag(Icons.shopping_cart_rounded, "Easy Shop"),
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

  // ── Tag Widget ────────────────────────────────────
  Widget _buildTag(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p10,
        vertical: AppPadding.p6,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.r50),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: AppSize.s12),
          const SizedBox(width: AppSize.s4),
          Text(
            label,
            style: getRegularStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: FontSize.s10,
            ),
          ),
        ],
      ),
    );
  }

  // ── Bottom Loading ────────────────────────────────
  Widget _buildBottomLoading(Size size) {
    return Positioned(
      bottom: AppSize.s48,
      left: 0,
      right: 0,
      child: FadeTransition(
        opacity: _dotsFade,
        child: Column(
          children: [
            // ── Loading Bar ───────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppPadding.p60),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.r50),
                child: AnimatedBuilder(
                  animation: _shimmer,
                  builder: (context, child) {
                    return LinearProgressIndicator(
                      value: null,
                      backgroundColor: Colors.white.withOpacity(0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withOpacity(0.6),
                      ),
                      minHeight: AppSize.s3,
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: AppSize.s12),

            // ── Loading Text ──────────────────
            Text(
              "Loading your experience...",
              style: getRegularStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: FontSize.s12,
              ),
            ),

            const SizedBox(height: AppSize.s8),

            // ── Dots ─────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) => _buildLoadingDot(index)),
            ),
          ],
        ),
      ),
    );
  }

  // ── Loading Dot ───────────────────────────────────
  Widget _buildLoadingDot(int index) {
    return AnimatedBuilder(
      animation: _shimmer,
      builder: (context, child) {
        final delay = index * 0.33;
        final value = ((_shimmer.value + delay) % 1.0);
        final opacity = value < 0.5 ? value * 2 : (1.0 - value) * 2;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: AppPadding.p3),
          width: AppSize.s8,
          height: AppSize.s8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.3 + opacity * 0.7),
          ),
        );
      },
    );
  }
}
