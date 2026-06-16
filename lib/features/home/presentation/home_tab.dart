import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/config/routes_manager/routes.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_event.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_state.dart';
import 'package:graduation_project/features/favourite/presentation/bloc/favourite_bloc.dart';
import 'package:graduation_project/features/favourite/presentation/bloc/favourite_event.dart';
import 'package:graduation_project/features/favourite/presentation/bloc/favourite_state.dart';
import 'package:graduation_project/features/home/presentation/bloc/home_bloc.dart';
import 'package:graduation_project/features/home/presentation/bloc/home_event.dart';
import 'package:graduation_project/features/home/presentation/bloc/home_state.dart';

import '../../../core/utils/color_maanger.dart';
import '../../../core/utils/components/product_card.dart';
import '../../favourite/domain/entity/favourite_entity.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();

  late AnimationController _headerController;
  late AnimationController _contentController;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  late Animation<double> _contentFade;

  @override
  void initState() {
    super.initState();

    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _headerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
    );
    _headerSlide = Tween<Offset>(begin: const Offset(0, -0.2), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
        );
    _contentFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOut),
    );

    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _contentController.forward();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _headerController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  String _getBrandLogo(String brandName) {
    const logos = {
      'Toyota': 'assets/images/png/toyota.png',
      'BMW': 'assets/images/png/bmw.png',
      'Mercedes': 'assets/images/png/Mercedes.png',
      'Hyundai': 'assets/images/png/hyundai.png',
      'KIA': 'assets/images/png/kia.png',
      'Nissan': 'assets/images/png/Nissan.jpeg',
      'Audi': 'assets/images/png/Audi.jpeg',
      'Skoda': 'assets/images/png/skoda.png',
      'Ford': 'assets/images/png/ford.png',
      'Honda': 'assets/images/png/honda.png',
    };
    return logos[brandName] ?? '';
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
            child: BlocConsumer<HomeBloc, HomeState>(
              listener: (context, state) {
                if (state is HomeDataErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.failure.message),
                      backgroundColor: ColorManager.error,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.r12),
                      ),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is HomeLoadingState || state is SearchLoadingState) {
                  return _buildLoading();
                }

                if (state is SearchEmptyState) {
                  return _buildSearchEmpty();
                }

                if (state is SearchSuccessState) {
                  return _buildSearchResults(context, state);
                }

                if (state is HomeDataSuccessState) {
                  return FadeTransition(
                    opacity: _contentFade,
                    child: _buildHomeContent(context, state),
                  );
                }

                if (state is HomeDataErrorState) {
                  return _buildError(context, state);
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
          colors: [Color(0xFF0d1b4b), Color(0xFF1a237e), Color(0xFF283593)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.r32),
          bottomRight: Radius.circular(AppRadius.r32),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x551a237e),
            blurRadius: 24,
            offset: Offset(0, 10),
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
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),
          Positioned(
            left: -20,
            top: 20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppPadding.p20,
              AppPadding.p52,
              AppPadding.p20,
              AppPadding.p20,
            ),
            child: Column(
              children: [
                // ── Top Row ───────────────────────
                Row(
                  children: [
                    // ── Logo ──────────────────────
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Colors.white, Color(0xFFB0BEC5)],
                            ).createShader(bounds),
                            child: Text(
                              "CarGo",
                              style: GoogleFonts.mali(
                                fontSize: 40,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          Text(
                            "Find the best car parts 🚗",
                            style: getRegularStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: FontSize.s13,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Cart ──────────────────────
                    BlocBuilder<CartBloc, CartState>(
                      builder: (context, state) {
                        int count = 0;
                        if (state is GetCartItemsSuccessState) {
                          count = state.cartItems.length;
                        }
                        return GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, Routes.cartRoute),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: AppSize.s48,
                                height: AppSize.s48,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.r12,
                                  ),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.shopping_cart_outlined,
                                  color: Colors.white,
                                  size: AppSize.s24,
                                ),
                              ),
                              if (count > 0)
                                Positioned(
                                  top: -AppSize.s6,
                                  right: -AppSize.s6,
                                  child: Container(
                                    width: AppSize.s20,
                                    height: AppSize.s20,
                                    decoration: const BoxDecoration(
                                      color: ColorManager.error,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        count > 9 ? "9+" : "$count",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: AppSize.s16),

                // ── Search Bar ────────────────────
                Container(
                  height: AppSize.s50,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(AppRadius.r16),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.p16,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search_rounded,
                        color: Colors.white.withOpacity(0.7),
                        size: AppSize.s22,
                      ),
                      const SizedBox(width: AppSize.s10),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          style: getRegularStyle(
                            color: Colors.white,
                            fontSize: FontSize.s14,
                          ),
                          onChanged: (query) => context.read<HomeBloc>().add(
                            SearchProductsEvent(query),
                          ),
                          decoration: InputDecoration(
                            hintText: "Search car parts...",
                            hintStyle: getRegularStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: FontSize.s14,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      if (_searchController.text.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            context.read<HomeBloc>().add(
                              const GetHomeDataEvent(),
                            );
                          },
                          child: Icon(
                            Icons.close_rounded,
                            color: Colors.white.withOpacity(0.7),
                            size: AppSize.s20,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Home Content ──────────────────────────────────
  Widget _buildHomeContent(BuildContext context, HomeDataSuccessState state) {
    return RefreshIndicator(
      color: const Color(0xFF1a237e),
      onRefresh: () async {
        context.read<HomeBloc>().add(const GetHomeDataEvent());
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppPadding.p16,
          AppPadding.p20,
          AppPadding.p16,
          AppPadding.p16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Brands Section ────────────────────
            _buildSectionHeader("Global Company", Icons.business_rounded),
            const SizedBox(height: AppSize.s12),
            _buildBrandsRow(state),

            const SizedBox(height: AppSize.s24),

            // ── Trends Section ────────────────────
            _buildSectionHeader("Trending Now 🔥", Icons.trending_up_rounded),
            const SizedBox(height: AppSize.s12),
            _buildTrendsRow(context, state),

            const SizedBox(height: AppSize.s24),

            // ── Best Price Section ────────────────
            _buildSectionHeader("Best Price 💰", Icons.local_offer_rounded),
            const SizedBox(height: AppSize.s12),
            _buildBestPriceGrid(context, state),

            const SizedBox(height: AppSize.s20),
          ],
        ),
      ),
    );
  }

  // ── Section Header ────────────────────────────────
  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppPadding.p6),
          decoration: BoxDecoration(
            color: const Color(0xFF1a237e).withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppRadius.r8),
          ),
          child: Icon(icon, color: const Color(0xFF1a237e), size: AppSize.s18),
        ),
        const SizedBox(width: AppSize.s10),
        Text(
          title,
          style: getBoldStyle(
            color: ColorManager.textPrimary,
            fontSize: FontSize.s18,
          ),
        ),
      ],
    );
  }

  // ── Brands Row ────────────────────────────────────
  Widget _buildBrandsRow(HomeDataSuccessState state) {
    return SizedBox(
      height: AppSize.s90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: state.brands.length,
        itemBuilder: (context, index) {
          final brand = state.brands[index];
          return Padding(
            padding: const EdgeInsets.only(right: AppPadding.p14),
            child: Column(
              children: [
                Container(
                  width: AppSize.s56,
                  height: AppSize.s56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1a237e).withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: const Color(0xFF1a237e).withOpacity(0.1),
                    ),
                  ),
                  child: ClipOval(
                    child: Padding(
                      padding: const EdgeInsets.all(AppPadding.p8),
                      child: Image.asset(
                        _getBrandLogo(brand.name),
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Center(
                          child: Text(
                            brand.name[0],
                            style: getBoldStyle(
                              color: const Color(0xFF1a237e),
                              fontSize: FontSize.s20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSize.s6),
                Text(
                  brand.name,
                  style: getMediumStyle(
                    color: ColorManager.textPrimary,
                    fontSize: FontSize.s11,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── Trends Row ────────────────────────────────────
  Widget _buildTrendsRow(BuildContext context, HomeDataSuccessState state) {
    if (state.trends.isEmpty) {
      return Container(
        height: AppSize.s180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.r16),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.directions_car_rounded,
                color: const Color(0xFF1a237e).withOpacity(0.3),
                size: AppSize.s48,
              ),
              const SizedBox(height: AppSize.s8),
              Text(
                "Loading trends...",
                style: getRegularStyle(
                  color: ColorManager.textSecondary,
                  fontSize: FontSize.s13,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: AppSize.s200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: state.trends.length,
        itemBuilder: (context, index) {
          final trend = state.trends[index];
          return GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              Routes.productDetails,
              arguments: trend,
            ),
            child: Container(
              width: AppSize.s240,
              margin: const EdgeInsets.only(right: AppPadding.p12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.r20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.r20),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // ── Image ────────────────────
                    trend.image.isNotEmpty
                        ? Image.network(
                            trend.image,
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
                            errorBuilder: (_, __, ___) =>
                                _buildTrendPlaceholder(trend.name),
                          )
                        : _buildTrendPlaceholder(trend.name),

                    // ── Gradient ─────────────────
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.75),
                            ],
                            stops: const [0.4, 1.0],
                          ),
                        ),
                      ),
                    ),

                    // ── Info ─────────────────────
                    Positioned(
                      bottom: AppSize.s12,
                      left: AppSize.s12,
                      right: AppSize.s12,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trend.name,
                            style: getMediumStyle(
                              color: Colors.white,
                              fontSize: FontSize.s13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppSize.s4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "EGP ${trend.price.toStringAsFixed(0)}",
                                style: getBoldStyle(
                                  color: Colors.white,
                                  fontSize: FontSize.s16,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppPadding.p8,
                                  vertical: AppPadding.p4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.r50,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.trending_up_rounded,
                                      color: Colors.white,
                                      size: AppSize.s12,
                                    ),
                                    const SizedBox(width: AppSize.s4),
                                    Text(
                                      "Trending",
                                      style: getMediumStyle(
                                        color: Colors.white,
                                        fontSize: FontSize.s10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Best Price Grid ───────────────────────────────
  Widget _buildBestPriceGrid(BuildContext context, HomeDataSuccessState state) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.bestPriceProducts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSize.s12,
        crossAxisSpacing: AppSize.s12,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        final product = state.bestPriceProducts[index];
        return BlocBuilder<FavouriteBloc, FavouriteState>(
          builder: (context, favState) {
            final isFav =
                favState is FavouriteSuccessState &&
                favState.favourites.any((f) => f.id == product.id);
            return ProductCard(
              productName: product.name,
              productImage: product.image,
              price: product.price,
              isFavorite: isFav,
              onFavoriteTap: () {
                if (isFav) {
                  context.read<FavouriteBloc>().add(
                    RemoveFavouriteEvent(product.id),
                  );
                } else {
                  context.read<FavouriteBloc>().add(
                    AddFavouriteEvent(
                      FavouriteEntity(
                        id: product.id,
                        name: product.name,
                        image: product.image,
                        price: product.price,
                      ),
                    ),
                  );
                }
              },
              onCardTap: () => Navigator.pushNamed(
                context,
                Routes.productDetails,
                arguments: product,
              ),
              onAddToCartTap: () {
                context.read<CartBloc>().add(
                  AddCartItemEvent(
                    productId: product.id,
                    productName: product.name,
                    productImage: product.image,
                    price: product.price,
                    quantity: 1,
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("${product.name} added!"),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.r12),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  // ── Search Results ────────────────────────────────
  Widget _buildSearchResults(BuildContext context, SearchSuccessState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppPadding.p16,
            AppPadding.p16,
            AppPadding.p16,
            AppPadding.p8,
          ),
          child: Row(
            children: [
              Icon(
                Icons.search_rounded,
                color: const Color(0xFF1a237e),
                size: AppSize.s18,
              ),
              const SizedBox(width: AppSize.s8),
              Text(
                "${state.products.length} results found",
                style: getMediumStyle(
                  color: ColorManager.textSecondary,
                  fontSize: FontSize.s14,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSize.s12,
              crossAxisSpacing: AppSize.s12,
              childAspectRatio: 0.75,
            ),
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              final product = state.products[index];
              return BlocBuilder<FavouriteBloc, FavouriteState>(
                builder: (context, favState) {
                  final isFav =
                      favState is FavouriteSuccessState &&
                      favState.favourites.any((f) => f.id == product.id);
                  return ProductCard(
                    productName: product.name,
                    productImage: product.image,
                    price: product.price,
                    isFavorite: isFav,
                    onFavoriteTap: () {
                      if (isFav) {
                        context.read<FavouriteBloc>().add(
                          RemoveFavouriteEvent(product.id),
                        );
                      } else {
                        context.read<FavouriteBloc>().add(
                          AddFavouriteEvent(
                            FavouriteEntity(
                              id: product.id,
                              name: product.name,
                              image: product.image,
                              price: product.price,
                            ),
                          ),
                        );
                      }
                    },
                    onCardTap: () => Navigator.pushNamed(
                      context,
                      Routes.productDetails,
                      arguments: product,
                    ),
                    onAddToCartTap: () {
                      context.read<CartBloc>().add(
                        AddCartItemEvent(
                          productId: product.id,
                          productName: product.name,
                          productImage: product.image,
                          price: product.price,
                          quantity: 1,
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // ── Search Empty ──────────────────────────────────
  Widget _buildSearchEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppPadding.p24),
            decoration: BoxDecoration(
              color: const Color(0xFF1a237e).withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: AppSize.s60,
              color: const Color(0xFF1a237e).withOpacity(0.4),
            ),
          ),
          const SizedBox(height: AppSize.s20),
          Text(
            "No products found",
            style: getBoldStyle(
              color: ColorManager.textPrimary,
              fontSize: FontSize.s20,
            ),
          ),
          const SizedBox(height: AppSize.s8),
          Text(
            "Try a different search term",
            style: getRegularStyle(
              color: ColorManager.textSecondary,
              fontSize: FontSize.s14,
            ),
          ),
        ],
      ),
    );
  }

  // ── Loading ───────────────────────────────────────
  Widget _buildLoading() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppPadding.p16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSize.s20),
          // ── Brands shimmer ────────────────────
          _buildShimmerRow(),
          const SizedBox(height: AppSize.s24),
          // ── Trends shimmer ────────────────────
          _buildShimmerWide(),
          const SizedBox(height: AppSize.s24),
          // ── Grid shimmer ──────────────────────
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSize.s12,
              crossAxisSpacing: AppSize.s12,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (_, __) => _buildShimmerCard(),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerRow() {
    return Row(
      children: List.generate(
        5,
        (i) => Container(
          width: AppSize.s56,
          height: AppSize.s56,
          margin: const EdgeInsets.only(right: AppPadding.p14),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          child: const _ShimmerEffect(),
        ),
      ),
    );
  }

  Widget _buildShimmerWide() {
    return Container(
      height: AppSize.s200,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(AppRadius.r20),
      ),
      child: const _ShimmerEffect(),
    );
  }

  Widget _buildShimmerCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(AppRadius.r16),
      ),
      child: const _ShimmerEffect(),
    );
  }

  // ── Error ─────────────────────────────────────────
  Widget _buildError(BuildContext context, HomeDataErrorState state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppPadding.p24),
            decoration: BoxDecoration(
              color: ColorManager.error.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.wifi_off_rounded,
              color: ColorManager.error,
              size: AppSize.s48,
            ),
          ),
          const SizedBox(height: AppSize.s16),
          Text(
            "Oops! Something went wrong",
            style: getBoldStyle(
              color: ColorManager.textPrimary,
              fontSize: FontSize.s18,
            ),
          ),
          const SizedBox(height: AppSize.s8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p32),
            child: Text(
              state.failure.message,
              style: getRegularStyle(
                color: ColorManager.textSecondary,
                fontSize: FontSize.s13,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSize.s24),
          GestureDetector(
            onTap: () => context.read<HomeBloc>().add(const GetHomeDataEvent()),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppPadding.p32,
                vertical: AppPadding.p14,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1a237e), Color(0xFF3949ab)],
                ),
                borderRadius: BorderRadius.circular(AppRadius.r50),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1a237e).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.refresh_rounded,
                    color: Colors.white,
                    size: AppSize.s20,
                  ),
                  const SizedBox(width: AppSize.s8),
                  Text(
                    "Try Again",
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

  // ── Trend Placeholder ─────────────────────────────
  Widget _buildTrendPlaceholder(String name) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1a237e).withOpacity(0.8),
            const Color(0xFF3949ab).withOpacity(0.6),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.directions_car_rounded,
            color: Colors.white,
            size: AppSize.s48,
          ),
          const SizedBox(height: AppSize.s8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
            child: Text(
              name,
              style: getMediumStyle(
                color: Colors.white,
                fontSize: FontSize.s14,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
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

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:graduation_project/config/routes_manager/routes.dart';
// import 'package:graduation_project/core/utils/font_manager.dart';
// import 'package:graduation_project/core/utils/styles_manager.dart';
// import 'package:graduation_project/core/utils/values_manager.dart';
// import 'package:graduation_project/features/cart/presentation/bloc/cart_bloc.dart';
// import 'package:graduation_project/features/cart/presentation/bloc/cart_event.dart';
// import 'package:graduation_project/features/cart/presentation/bloc/cart_state.dart';
// import 'package:graduation_project/features/favourite/presentation/bloc/favourite_bloc.dart';
// import 'package:graduation_project/features/favourite/presentation/bloc/favourite_event.dart';
// import 'package:graduation_project/features/favourite/presentation/bloc/favourite_state.dart';
// import 'package:graduation_project/features/home/presentation/bloc/home_bloc.dart';
// import 'package:graduation_project/features/home/presentation/bloc/home_event.dart';
// import 'package:graduation_project/features/home/presentation/bloc/home_state.dart';
//
// import '../../../core/utils/color_maanger.dart';
// import '../../../core/utils/components/product_card.dart';
// import '../../favourite/domain/entity/favourite_entity.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final TextEditingController _searchController = TextEditingController();
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   // ── Brand Logo URLs ───────────────────────────────
//   String _getBrandLogo(String brandName) {
//     const logos = {
//       'Toyota': 'assets/images/png/toyota.png',
//       'BMW': 'assets/images/png/bmw.png',
//       'Mercedes': 'assets/images/png/Mercedes.png',
//       'Hyundai': 'assets/images/png/hyundai.png',
//       'KIA': 'assets/images/png/kia.png',
//       'Nissan': 'assets/images/png/Nissan.jpeg',
//       'Audi': 'assets/images/png/Audi.jpeg',
//       'Skoda': 'assets/images/png/skoda.png',
//       'Ford': 'assets/images/png/ford.png',
//       'Honda': 'assets/images/png/honda.png',
//     };
//     return logos[brandName] ?? '';
//   }
//
//   // ── Trend Placeholder ─────────────────────────────
//   Widget _buildTrendPlaceholder(String name) {
//     return Container(
//       color: ColorManager.primary.withOpacity(0.1),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(
//             Icons.directions_car,
//             color: ColorManager.primary,
//             size: AppSize.s48,
//           ),
//           const SizedBox(height: AppSize.s8),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
//             child: Text(
//               name,
//               style: getMediumStyle(
//                 color: ColorManager.primary,
//                 fontSize: FontSize.s14,
//               ),
//               textAlign: TextAlign.center,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       body: Column(
//         children: [
//           // ── Header ────────────────────────────────
//           _buildHeader(context),
//
//           // ── Body ──────────────────────────────────
//           Expanded(
//             child: BlocConsumer<HomeBloc, HomeState>(
//               listener: (context, state) {
//                 if (state is HomeDataErrorState) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text(state.failure.message),
//                       backgroundColor: ColorManager.error,
//                     ),
//                   );
//                 }
//               },
//               builder: (context, state) {
//                 // ── Loading ────────────────────────
//                 if (state is HomeLoadingState || state is SearchLoadingState) {
//                   return const Center(
//                     child: CircularProgressIndicator(
//                       color: ColorManager.primary,
//                     ),
//                   );
//                 }
//
//                 // ── Search Empty ───────────────────
//                 if (state is SearchEmptyState) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Icon(
//                           Icons.search_off,
//                           size: 64,
//                           color: ColorManager.grey,
//                         ),
//                         const SizedBox(height: AppSize.s12),
//                         Text(
//                           "No products found",
//                           style: getMediumStyle(
//                             color: ColorManager.textSecondary,
//                             fontSize: FontSize.s16,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }
//
//                 // ── Search Results ─────────────────
//                 if (state is SearchSuccessState) {
//                   return GridView.builder(
//                     padding: const EdgeInsets.all(AppPadding.p16),
//                     gridDelegate:
//                     const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       mainAxisSpacing: AppSize.s12,
//                       crossAxisSpacing: AppSize.s12,
//                       childAspectRatio: 0.75,
//                     ),
//                     itemCount: state.products.length,
//                     itemBuilder: (context, index) {
//                       final product = state.products[index];
//                       return ProductCard(
//                         productName: product.name,
//                         productImage: product.image,
//                         price: product.price,
//                         isFavorite: product.isFavorite,
//                         onFavoriteTap: () {},
//                         onCardTap: () => Navigator.pushNamed(
//                           context,
//                           Routes.productDetails,
//                           arguments: product,
//                         ),
//                         onAddToCartTap: () {
//                           context.read<CartBloc>().add(
//                             AddCartItemEvent(
//                               productId: product.id,
//                               productName: product.name,
//                               productImage: product.image,
//                               price: product.price,
//                               quantity: 1,
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   );
//                 }
//
//                 // ── Home Data ──────────────────────
//                 if (state is HomeDataSuccessState) {
//                   return RefreshIndicator(
//                     color: ColorManager.primary,
//                     onRefresh: () async {
//                       context.read<HomeBloc>().add(const GetHomeDataEvent());
//                     },
//                     child: SingleChildScrollView(
//                       physics: const AlwaysScrollableScrollPhysics(),
//                       padding: const EdgeInsets.all(AppPadding.p16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // ── Global Company ────────────────────────────────
//                           Text(
//                             "Global Company",
//                             style: getBoldStyle(
//                               color: ColorManager.textPrimary,
//                               fontSize: FontSize.s18,
//                             ),
//                           ),
//                           const SizedBox(height: AppSize.s12),
//
//                           // ── Brands Row ────────────────────────────────────
//                           SizedBox(
//                             height: AppSize.s90,
//                             child: ListView.builder(
//                               scrollDirection: Axis.horizontal,
//                               itemCount: state.brands.length,
//                               itemBuilder: (context, index) {
//                                 final brand = state.brands[index];
//                                 return Padding(
//                                   padding: const EdgeInsets.only(
//                                     right: AppPadding.p16,
//                                   ),
//                                   child: Column(
//                                     children: [
//                                       Container(
//                                         width: AppSize.s64,
//                                         height: AppSize.s64,
//                                         decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           shape: BoxShape.circle,
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color: ColorManager.grey
//                                                   .withOpacity(0.15),
//                                               blurRadius: 8,
//                                               offset: const Offset(0, 2),
//                                             ),
//                                           ],
//                                         ),
//                                         child: ClipOval(
//                                           child: Padding(
//                                             padding: const EdgeInsets.all(
//                                               AppPadding.p8,
//                                             ),
//                                             child: Image.asset(
//                                               _getBrandLogo(brand.name),
//                                               fit: BoxFit.contain,
//                                               errorBuilder: (_, __, ___) =>
//                                                   Center(
//                                                     child: Text(
//                                                       brand.name[0],
//                                                       style: getBoldStyle(
//                                                         color: ColorManager
//                                                             .primary,
//                                                         fontSize: FontSize.s20,
//                                                       ),
//                                                     ),
//                                                   ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       const SizedBox(height: AppSize.s6),
//                                       Text(
//                                         brand.name,
//                                         style: getRegularStyle(
//                                           color: ColorManager.textPrimary,
//                                           fontSize: FontSize.s12,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//
//                           const SizedBox(height: AppSize.s20),
//
//                           // ── Trends ────────────────────────────────────────
//                           Text(
//                             "Trends",
//                             style: getBoldStyle(
//                               color: ColorManager.textPrimary,
//                               fontSize: FontSize.s18,
//                             ),
//                           ),
//                           const SizedBox(height: AppSize.s12),
//
//                           SizedBox(
//                             height: AppSize.s180,
//                             child: state.trends.isEmpty
//                                 ? Container(
//                               width: double.infinity,
//                               decoration: BoxDecoration(
//                                 color: ColorManager.lightGrey,
//                                 borderRadius: BorderRadius.circular(
//                                   AppRadius.r16,
//                                 ),
//                               ),
//                               child: const Center(
//                                 child: Icon(
//                                   Icons.directions_car,
//                                   color: ColorManager.primary,
//                                   size: AppSize.s48,
//                                 ),
//                               ),
//                             )
//                                 : ListView.builder(
//                               scrollDirection: Axis.horizontal,
//                               itemCount: state.trends.length,
//                               itemBuilder: (context, index) {
//                                 final trend = state.trends[index];
//                                 return GestureDetector(
//                                   onTap: () => Navigator.pushNamed(
//                                     context,
//                                     Routes.productDetails,
//                                     arguments: trend,
//                                   ),
//                                   child: Container(
//                                     width: AppSize.s260,
//                                     margin: const EdgeInsets.only(
//                                       right: AppPadding.p12,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(
//                                         AppRadius.r16,
//                                       ),
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: ColorManager.grey
//                                               .withOpacity(0.15),
//                                           blurRadius: 8,
//                                           offset: const Offset(0, 2),
//                                         ),
//                                       ],
//                                     ),
//                                     child: ClipRRect(
//                                       borderRadius: BorderRadius.circular(
//                                         AppRadius.r16,
//                                       ),
//                                       child: Stack(
//                                         fit: StackFit.expand,
//                                         children: [
//                                           // ── Image ──────────────────
//                                           trend.image.isNotEmpty
//                                               ? Image.network(
//                                             trend.image,
//                                             fit: BoxFit.cover,
//                                             loadingBuilder: (ctx, child, progress) {
//                                               if (progress == null)
//                                                 return child;
//                                               return Container(
//                                                 color: ColorManager
//                                                     .lightGrey,
//                                                 child: const Center(
//                                                   child: CircularProgressIndicator(
//                                                     color:
//                                                     ColorManager
//                                                         .primary,
//                                                     strokeWidth: 2,
//                                                   ),
//                                                 ),
//                                               );
//                                             },
//                                             errorBuilder:
//                                                 (_, __, ___) =>
//                                                 _buildTrendPlaceholder(
//                                                   trend.name,
//                                                 ),
//                                           )
//                                               : _buildTrendPlaceholder(
//                                             trend.name,
//                                           ),
//
//                                           // ── Gradient Overlay ───────
//                                           Positioned.fill(
//                                             child: DecoratedBox(
//                                               decoration: BoxDecoration(
//                                                 gradient: LinearGradient(
//                                                   begin:
//                                                   Alignment.topCenter,
//                                                   end: Alignment
//                                                       .bottomCenter,
//                                                   colors: [
//                                                     Colors.transparent,
//                                                     Colors.black
//                                                         .withOpacity(0.7),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//
//                                           // ── Product Info ───────────
//                                           Positioned(
//                                             bottom: AppSize.s12,
//                                             left: AppSize.s12,
//                                             right: AppSize.s12,
//                                             child: Column(
//                                               crossAxisAlignment:
//                                               CrossAxisAlignment
//                                                   .start,
//                                               children: [
//                                                 Text(
//                                                   trend.name,
//                                                   style: getMediumStyle(
//                                                     color: ColorManager
//                                                         .white,
//                                                     fontSize:
//                                                     FontSize.s14,
//                                                   ),
//                                                   maxLines: 1,
//                                                   overflow: TextOverflow
//                                                       .ellipsis,
//                                                 ),
//                                                 const SizedBox(
//                                                   height: AppSize.s4,
//                                                 ),
//                                                 Text(
//                                                   "EGP ${trend.price.toStringAsFixed(0)}",
//                                                   style: getBoldStyle(
//                                                     color: ColorManager
//                                                         .white,
//                                                     fontSize:
//                                                     FontSize.s16,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                           const SizedBox(height: AppSize.s20),
//
//                           // ── Best Price ────────────
//                           Text(
//                             "Best Price",
//                             style: getBoldStyle(
//                               color: ColorManager.textPrimary,
//                               fontSize: FontSize.s18,
//                             ),
//                           ),
//                           const SizedBox(height: AppSize.s12),
//
//                           GridView.builder(
//                             shrinkWrap: true,
//                             physics: const NeverScrollableScrollPhysics(),
//                             itemCount: state.bestPriceProducts.length,
//                             gridDelegate:
//                             const SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 2,
//                               mainAxisSpacing: AppSize.s12,
//                               crossAxisSpacing: AppSize.s12,
//                               childAspectRatio: 0.75,
//                             ),
//                             // ── Best Price Grid ───────────────────────────────
//                             itemBuilder: (context, index) {
//                               final product = state.bestPriceProducts[index];
//
//                               // ✅ اتحقق من الـ FavouriteBloc
//                               return BlocBuilder<FavouriteBloc, FavouriteState>(
//                                 builder: (context, favState) {
//                                   final isFav =
//                                       favState is FavouriteSuccessState &&
//                                           favState.favourites.any(
//                                                 (f) => f.id == product.id,
//                                           );
//
//                                   return ProductCard(
//                                     productName: product.name,
//                                     productImage: product.image,
//                                     price: product.price,
//                                     isFavorite: isFav,
//                                     onFavoriteTap: () {
//                                       if (isFav) {
//                                         context.read<FavouriteBloc>().add(
//                                           RemoveFavouriteEvent(product.id),
//                                         );
//                                       } else {
//                                         context.read<FavouriteBloc>().add(
//                                           AddFavouriteEvent(
//                                             FavouriteEntity(
//                                               id: product.id,
//                                               name: product.name,
//                                               image: product.image,
//                                               price: product.price,
//                                             ),
//                                           ),
//                                         );
//                                       }
//                                     },
//                                     onCardTap: () => Navigator.pushNamed(
//                                       context,
//                                       Routes.productDetails,
//                                       arguments: product,
//                                     ),
//                                     onAddToCartTap: () {
//                                       context.read<CartBloc>().add(
//                                         AddCartItemEvent(
//                                           productId: product.id,
//                                           productName: product.name,
//                                           productImage: product.image,
//                                           price: product.price,
//                                           quantity: 1,
//                                         ),
//                                       );
//                                     },
//                                   );
//                                 },
//                               );
//                             },
//                           ),
//
//                           const SizedBox(height: AppSize.s20),
//                         ],
//                       ),
//                     ),
//                   );
//                 }
//
//                 // ── Error ──────────────────────────
//                 if (state is HomeDataErrorState) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Icon(
//                           Icons.error_outline,
//                           color: ColorManager.error,
//                           size: AppSize.s60,
//                         ),
//                         const SizedBox(height: AppSize.s12),
//                         Text(
//                           state.failure.message,
//                           style: getRegularStyle(
//                             color: ColorManager.error,
//                             fontSize: FontSize.s14,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: AppSize.s16),
//                         ElevatedButton(
//                           onPressed: () => context.read<HomeBloc>().add(
//                             const GetHomeDataEvent(),
//                           ),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: ColorManager.primary,
//                           ),
//                           child: const Text(
//                             "Retry",
//                             style: TextStyle(color: ColorManager.white),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }
//
//                 return const SizedBox();
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── Header ───────────────────────────────────────
//   Widget _buildHeader(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(
//         AppPadding.p16,
//         AppPadding.p48,
//         AppPadding.p16,
//         AppPadding.p16,
//       ),
//       decoration: const BoxDecoration(
//         color: ColorManager.primary,
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(AppRadius.r24),
//           bottomRight: Radius.circular(AppRadius.r24),
//         ),
//       ),
//       child: Column(
//         children: [
//           // ── Logo ──────────────────────────────────
//           Text(
//             "CarGo",
//             style: GoogleFonts.mali(
//               fontSize: 44,
//               fontWeight: FontWeight.w600,
//               color: Colors.white,
//               fontStyle: FontStyle.italic,
//             ),
//           ),
//
//           const SizedBox(height: AppSize.s12),
//
//           // ── Search + Cart ─────────────────────────
//           Row(
//             children: [
//               Expanded(
//                 child: Container(
//                   height: AppSize.s48,
//                   decoration: BoxDecoration(
//                     color: ColorManager.white,
//                     borderRadius: BorderRadius.circular(AppRadius.r50),
//                   ),
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: AppPadding.p12,
//                   ),
//                   child: Row(
//                     children: [
//                       const Icon(Icons.search, color: ColorManager.grey),
//                       const SizedBox(width: AppSize.s8),
//                       Expanded(
//                         child: TextField(
//                           controller: _searchController,
//                           onChanged: (query) => context.read<HomeBloc>().add(
//                             SearchProductsEvent(query),
//                           ),
//                           decoration: const InputDecoration(
//                             hintText: "Search...",
//                             hintStyle: TextStyle(color: ColorManager.grey),
//                             border: InputBorder.none,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               const SizedBox(width: AppSize.s12),
//
//               // ── Cart Icon ────────────────────────
//               BlocBuilder<CartBloc, CartState>(
//                 builder: (context, state) {
//                   int itemCount = 0;
//                   if (state is GetCartItemsSuccessState) {
//                     itemCount = state.cartItems.length;
//                   }
//                   return Stack(
//                     clipBehavior: Clip.none,
//                     children: [
//                       GestureDetector(
//                         onTap: () =>
//                             Navigator.pushNamed(context, Routes.cartRoute),
//                         child: Container(
//                           height: AppSize.s48,
//                           width: AppSize.s48,
//                           decoration: const BoxDecoration(
//                             color: ColorManager.white,
//                             shape: BoxShape.circle,
//                           ),
//                           child: const Icon(
//                             Icons.shopping_cart_outlined,
//                             color: ColorManager.primary,
//                           ),
//                         ),
//                       ),
//                       if (itemCount > 0)
//                         Positioned(
//                           top: -AppSize.s4,
//                           right: -AppSize.s4,
//                           child: Container(
//                             width: AppSize.s16,
//                             height: AppSize.s16,
//                             decoration: const BoxDecoration(
//                               color: ColorManager.error,
//                               shape: BoxShape.circle,
//                             ),
//                             child: Center(
//                               child: Text(
//                                 itemCount > 9 ? "9+" : "$itemCount",
//                                 style: const TextStyle(
//                                   color: ColorManager.white,
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                     ],
//                   );
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ── Image Error ──────────────────────────────────
//   Widget _buildImageError() {
//     return Container(
//       width: AppSize.s200,
//       height: AppSize.s150,
//       color: ColorManager.lightGrey,
//       child: const Icon(
//         Icons.image_not_supported_outlined,
//         color: ColorManager.grey,
//       ),
//     );
//   }
// }
