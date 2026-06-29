import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/core/utils/color_maanger.dart';
import 'package:graduation_project/core/utils/values_manager.dart';
import 'package:graduation_project/features/home/presentation/bloc/home_bloc.dart';
import 'package:graduation_project/features/home/presentation/bloc/home_event.dart';
import 'package:graduation_project/features/home/presentation/bloc/home_state.dart';
import 'package:graduation_project/features/home/presentation/widgets/best_price_grid.dart';
import 'package:graduation_project/features/home/presentation/widgets/brands_row.dart';
import 'package:graduation_project/features/home/presentation/widgets/home_error_view.dart';
import 'package:graduation_project/features/home/presentation/widgets/home_header.dart';
import 'package:graduation_project/features/home/presentation/widgets/home_loading_shimmer.dart';
import 'package:graduation_project/features/home/presentation/widgets/home_search_empty.dart';
import 'package:graduation_project/features/home/presentation/widgets/home_search_results.dart';
import 'package:graduation_project/features/home/presentation/widgets/home_section_header.dart';
import 'package:graduation_project/features/home/presentation/widgets/trends_row.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      body: Column(
        children: [
          FadeTransition(
            opacity: _headerFade,
            child: SlideTransition(
              position: _headerSlide,
              child: HomeHeader(searchController: _searchController),
            ),
          ),
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
                  return const HomeLoadingShimmer();
                }

                if (state is SearchEmptyState) {
                  return const HomeSearchEmpty();
                }

                if (state is SearchSuccessState) {
                  return HomeSearchResults(products: state.products);
                }

                if (state is HomeDataSuccessState) {
                  return FadeTransition(
                    opacity: _contentFade,
                    child: _HomeContent(state: state),
                  );
                }

                if (state is HomeDataErrorState) {
                  return HomeErrorView(
                    message: state.failure.message,
                    onRetry: () =>
                        context.read<HomeBloc>().add(const GetHomeDataEvent()),
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
}

class _HomeContent extends StatelessWidget {
  final HomeDataSuccessState state;

  const _HomeContent({required this.state});

  @override
  Widget build(BuildContext context) {
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
            const HomeSectionHeader(
              title: "Global Company",
              icon: Icons.business_rounded,
            ),
            const SizedBox(height: AppSize.s12),
            BrandsRow(brands: state.brands),

            const SizedBox(height: AppSize.s24),

            const HomeSectionHeader(
              title: "Trending Now ",
              icon: Icons.trending_up_rounded,
            ),
            const SizedBox(height: AppSize.s12),
            TrendsRow(trends: state.trends),

            const SizedBox(height: AppSize.s24),

            const HomeSectionHeader(
              title: "Best Price ",
              icon: Icons.local_offer_rounded,
            ),
            const SizedBox(height: AppSize.s12),
            BestPriceGrid(products: state.bestPriceProducts),

            const SizedBox(height: AppSize.s20),
          ],
        ),
      ),
    );
  }
}
