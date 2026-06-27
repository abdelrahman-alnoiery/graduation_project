import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graduation_project/config/routes_manager/routes.dart';
import 'package:graduation_project/core/utils/color_maanger.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_state.dart';
import 'package:graduation_project/features/home/presentation/bloc/home_bloc.dart';
import 'package:graduation_project/features/home/presentation/bloc/home_event.dart';

class HomeHeader extends StatelessWidget {
  final TextEditingController searchController;

  const HomeHeader({super.key, required this.searchController});

  @override
  Widget build(BuildContext context) {
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
                Row(
                  children: [
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
                    const _CartButton(),
                  ],
                ),
                const SizedBox(height: AppSize.s16),
                _SearchBar(searchController: searchController),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CartButton extends StatelessWidget {
  const _CartButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        int count = 0;
        if (state is GetCartItemsSuccessState) {
          count = state.cartItems.length;
        }
        return GestureDetector(
          onTap: () => Navigator.pushNamed(context, Routes.cartRoute),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: AppSize.s48,
                height: AppSize.s48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(AppRadius.r12),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
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
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController searchController;

  const _SearchBar({required this.searchController});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSize.s50,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppRadius.r16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
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
              controller: searchController,
              style: getRegularStyle(
                color: Colors.white,
                fontSize: FontSize.s14,
              ),
              onChanged: (query) =>
                  context.read<HomeBloc>().add(SearchProductsEvent(query)),
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
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: searchController,
            builder: (_, value, __) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return GestureDetector(
                onTap: () {
                  searchController.clear();
                  context.read<HomeBloc>().add(const GetHomeDataEvent());
                },
                child: Icon(
                  Icons.close_rounded,
                  color: Colors.white.withOpacity(0.7),
                  size: AppSize.s20,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
