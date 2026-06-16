import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/config/routes_manager/routes.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_event.dart';
import 'package:graduation_project/features/favourite/presentation/bloc/favourite_bloc.dart';
import 'package:graduation_project/features/favourite/presentation/bloc/favourite_event.dart';
import 'package:graduation_project/features/favourite/presentation/bloc/favourite_state.dart';

import '../../../../../core/utils/color_maanger.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _listController;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  late Animation<double> _listFade;

  final List<AnimationController> _itemControllers = [];
  final List<Animation<double>> _itemScales = [];
  final List<Animation<Offset>> _itemSlides = [];

  @override
  void initState() {
    super.initState();

    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _listController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _headerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
    );
    _headerSlide = Tween<Offset>(begin: const Offset(0, -0.2), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
        );
    _listFade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _listController, curve: Curves.easeOut));

    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _listController.forward();
    });
  }

  void _initItemAnimations(int count) {
    if (_itemControllers.length == count) return;
    for (var c in _itemControllers) {
      c.dispose();
    }
    _itemControllers.clear();
    _itemScales.clear();
    _itemSlides.clear();

    for (int i = 0; i < count; i++) {
      final controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      );
      _itemControllers.add(controller);
      _itemScales.add(
        Tween<double>(
          begin: 0.8,
          end: 1.0,
        ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut)),
      );
      _itemSlides.add(
        Tween<Offset>(
          begin: Offset(i.isEven ? -0.2 : 0.2, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut)),
      );
      Future.delayed(Duration(milliseconds: 100 + (i * 80)), () {
        if (mounted) controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _headerController.dispose();
    _listController.dispose();
    for (var c in _itemControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      body: Column(
        children: [
          // ── Animated Header ───────────────────
          FadeTransition(
            opacity: _headerFade,
            child: SlideTransition(
              position: _headerSlide,
              child: _buildHeader(context),
            ),
          ),

          // ── Body ──────────────────────────────
          Expanded(
            child: BlocBuilder<FavouriteBloc, FavouriteState>(
              builder: (context, state) {
                if (state is FavouriteLoadingState) {
                  return _buildLoading();
                }

                if (state is FavouriteEmptyState ||
                    state is FavouriteInitialState) {
                  return _buildEmpty(context);
                }

                if (state is FavouriteSuccessState) {
                  _initItemAnimations(state.favourites.length);
                  return FadeTransition(
                    opacity: _listFade,
                    child: _buildGrid(context, state),
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1a237e), Color(0xFF3949ab)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.r32),
          bottomRight: Radius.circular(AppRadius.r32),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x441a237e),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // ── Decorative circles ────────────────
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            left: -20,
            bottom: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppPadding.p20,
              AppPadding.p52,
              AppPadding.p20,
              AppPadding.p24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // ── Heart Icon ────────────────
                    Container(
                      padding: const EdgeInsets.all(AppPadding.p10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(AppRadius.r12),
                      ),
                      child: const Icon(
                        Icons.favorite_rounded,
                        color: Colors.white,
                        size: AppSize.s24,
                      ),
                    ),

                    const SizedBox(width: AppSize.s12),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "My Favourites",
                          style: getBoldStyle(
                            color: Colors.white,
                            fontSize: FontSize.s22,
                          ),
                        ),
                        Text(
                          "Products you love ❤️",
                          style: getRegularStyle(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: FontSize.s13,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // ── Count Badge ───────────────
                    BlocBuilder<FavouriteBloc, FavouriteState>(
                      builder: (context, state) {
                        final count = state is FavouriteSuccessState
                            ? state.favourites.length
                            : 0;
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppPadding.p14,
                            vertical: AppPadding.p8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(AppRadius.r50),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.favorite_rounded,
                                color: Colors.white,
                                size: AppSize.s14,
                              ),
                              const SizedBox(width: AppSize.s4),
                              Text(
                                "$count",
                                style: getBoldStyle(
                                  color: Colors.white,
                                  fontSize: FontSize.s14,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Grid ──────────────────────────────────────────
  Widget _buildGrid(BuildContext context, FavouriteSuccessState state) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppPadding.p16,
        AppPadding.p20,
        AppPadding.p16,
        AppPadding.p16,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSize.s14,
        crossAxisSpacing: AppSize.s14,
        childAspectRatio: 0.72,
      ),
      itemCount: state.favourites.length,
      itemBuilder: (context, index) {
        final item = state.favourites[index];
        if (index >= _itemControllers.length) {
          return const SizedBox();
        }
        return ScaleTransition(
          scale: _itemScales[index],
          child: SlideTransition(
            position: _itemSlides[index],
            child: _buildFavCard(context, item),
          ),
        );
      },
    );
  }

  // ── Fav Card ──────────────────────────────────────
  Widget _buildFavCard(BuildContext context, item) {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, Routes.productDetails, arguments: item),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.r20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image ─────────────────────────
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  // ── Product Image ────────────
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppRadius.r20),
                      topRight: Radius.circular(AppRadius.r20),
                    ),
                    child: item.image.isNotEmpty
                        ? Image.network(
                            item.image,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (ctx, child, progress) {
                              if (progress == null) return child;
                              return Container(
                                color: const Color(0xFFF0F2F8),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF1a237e),
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (_, __, ___) => _buildImageError(),
                          )
                        : _buildImageError(),
                  ),

                  // ── Remove Button ─────────────
                  Positioned(
                    top: AppSize.s8,
                    right: AppSize.s8,
                    child: GestureDetector(
                      onTap: () {
                        context.read<FavouriteBloc>().add(
                          RemoveFavouriteEvent(item.id),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(AppPadding.p6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.2),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.favorite_rounded,
                          color: Colors.red,
                          size: AppSize.s18,
                        ),
                      ),
                    ),
                  ),

                  // ── Price Badge ───────────────
                  Positioned(
                    bottom: AppSize.s8,
                    left: AppSize.s8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppPadding.p8,
                        vertical: AppPadding.p4,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1a237e), Color(0xFF3949ab)],
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.r8),
                      ),
                      child: Text(
                        "EGP ${item.price.toStringAsFixed(0)}",
                        style: getBoldStyle(
                          color: Colors.white,
                          fontSize: FontSize.s11,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Info ──────────────────────────
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(AppPadding.p10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ── Name ──────────────────
                    Text(
                      item.name,
                      style: getMediumStyle(
                        color: ColorManager.textPrimary,
                        fontSize: FontSize.s12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // ── Add to Cart ────────────
                    GestureDetector(
                      onTap: () {
                        context.read<CartBloc>().add(
                          AddCartItemEvent(
                            productId: item.id,
                            productName: item.name,
                            productImage: item.image,
                            price: item.price,
                            quantity: 1,
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("${item.name} added!"),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppRadius.r12,
                              ),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppPadding.p8,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1a237e), Color(0xFF3949ab)],
                          ),
                          borderRadius: BorderRadius.circular(AppRadius.r10),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF1a237e).withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.shopping_cart_outlined,
                              color: Colors.white,
                              size: AppSize.s14,
                            ),
                            const SizedBox(width: AppSize.s4),
                            Text(
                              "Add to Cart",
                              style: getMediumStyle(
                                color: Colors.white,
                                fontSize: FontSize.s11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Loading Shimmer ───────────────────────────────
  Widget _buildLoading() {
    return GridView.builder(
      padding: const EdgeInsets.all(AppPadding.p16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSize.s14,
        crossAxisSpacing: AppSize.s14,
        childAspectRatio: 0.72,
      ),
      itemCount: 4,
      itemBuilder: (context, index) => _buildShimmerCard(),
    );
  }

  Widget _buildShimmerCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(AppRadius.r20),
      ),
      child: const _ShimmerEffect(),
    );
  }

  // ── Empty State ───────────────────────────────────
  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Animated Heart ────────────────────
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.8, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.elasticOut,
            builder: (context, scale, child) {
              return Transform.scale(scale: scale, child: child);
            },
            child: Container(
              width: AppSize.s130,
              height: AppSize.s130,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF1a237e).withOpacity(0.1),
                    const Color(0xFF3949ab).withOpacity(0.05),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.favorite_border_rounded,
                    color: const Color(0xFF1a237e).withOpacity(0.2),
                    size: AppSize.s80,
                  ),
                  Icon(
                    Icons.favorite_border_rounded,
                    color: const Color(0xFF1a237e).withOpacity(0.6),
                    size: AppSize.s56,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppSize.s24),

          Text(
            "No Favourites Yet!",
            style: getBoldStyle(
              color: ColorManager.textPrimary,
              fontSize: FontSize.s22,
            ),
          ),

          const SizedBox(height: AppSize.s8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p40),
            child: Text(
              "Tap the ❤️ on any product\nto save it here",
              style: getRegularStyle(
                color: ColorManager.textSecondary,
                fontSize: FontSize.s14,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: AppSize.s32),

          // ── Browse Button ─────────────────────
          GestureDetector(
            onTap: () => Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.homePageLayoutRoute,
              (route) => false,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppPadding.p32,
                vertical: AppPadding.p16,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1a237e), Color(0xFF3949ab)],
                ),
                borderRadius: BorderRadius.circular(AppRadius.r50),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1a237e).withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.explore_rounded,
                    color: Colors.white,
                    size: AppSize.s20,
                  ),
                  const SizedBox(width: AppSize.s8),
                  Text(
                    "Browse Products",
                    style: getBoldStyle(
                      color: Colors.white,
                      fontSize: FontSize.s15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Image Error ───────────────────────────────────
  Widget _buildImageError() {
    return Container(
      color: const Color(0xFFF0F2F8),
      child: const Center(
        child: Icon(
          Icons.directions_car_rounded,
          color: Color(0xFF1a237e),
          size: AppSize.s40,
        ),
      ),
    );
  }
}

// ── Shimmer Effect ────────────────────────────────────
class _ShimmerEffect extends StatefulWidget {
  const _ShimmerEffect();

  @override
  State<_ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<_ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _animation = Tween<double>(
      begin: -1,
      end: 2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.r20),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [
                (_animation.value - 0.3).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 0.3).clamp(0.0, 1.0),
              ],
              colors: [
                Colors.grey.shade200,
                Colors.grey.shade100,
                Colors.grey.shade200,
              ],
            ),
          ),
        );
      },
    );
  }
}
