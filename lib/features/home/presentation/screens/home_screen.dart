// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:graduation_project/config/routes_manager/routes.dart';
// import 'package:graduation_project/core/utils/font_manager.dart';
// import 'package:graduation_project/core/utils/styles_manager.dart';
// import 'package:graduation_project/core/utils/values_manager.dart';
// import 'package:graduation_project/features/cart/presentation/bloc/cart_bloc.dart';
// import 'package:graduation_project/features/cart/presentation/bloc/cart_event.dart';
// import 'package:graduation_project/features/home/presentation/bloc/home_bloc.dart';
// import 'package:graduation_project/features/home/presentation/bloc/home_event.dart';
// import 'package:graduation_project/features/home/presentation/bloc/home_state.dart';
//
// import '../../../../core/utils/color_maanger.dart';
// import '../../../../core/utils/components/product_card.dart';
// import 'widgets/best_price_section.dart';
// import 'widgets/brands_section.dart';
// import 'widgets/home_app_bar.dart';
// import 'widgets/trends_section.dart';
//
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
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorManager.white,
//       appBar: HomeAppBar(
//         searchController: _searchController,
//         onSearch: (query) {
//           context.read<HomeBloc>().add(SearchProductsEvent(query));
//         },
//       ),
//       body: BlocConsumer<HomeBloc, HomeState>(
//         listener: (context, state) {
//           if (state is HomeDataErrorState) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.failure.message),
//                 backgroundColor: ColorManager.error,
//               ),
//             );
//           }
//         },
//         builder: (context, state) {
//           // ── Loading ────────────────────────────
//           if (state is HomeLoadingState || state is SearchLoadingState) {
//             return const Center(
//               child: CircularProgressIndicator(color: ColorManager.primary),
//             );
//           }
//
//           // ── Search Results ─────────────────────
//           if (state is SearchSuccessState) {
//             return GridView.builder(
//               padding: const EdgeInsets.all(AppPadding.p16),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: AppSize.s12,
//                 mainAxisSpacing: AppSize.s12,
//                 childAspectRatio: 0.75,
//               ),
//               itemCount: state.products.length,
//               itemBuilder: (context, index) {
//                 final product = state.products[index];
//                 return ProductCard(
//                   productName: product.name,
//                   productImage: product.image,
//                   price: product.price,
//                   isFavorite: product.isFavorite,
//                   onFavoriteTap: () {},
//                   onCardTap: () {
//                     Navigator.pushNamed(
//                       context,
//                       Routes.productDetails,
//                       arguments: product,
//                     );
//                   },
//                   onAddToCartTap: () {
//                     context.read<CartBloc>().add(
//                       AddCartItemEvent(
//                         productId: product.id,
//                         productName: product.name,
//                         productImage: product.image,
//                         price: product.price,
//                         quantity: 1,
//                       ),
//                     );
//                   },
//                 );
//               },
//             );
//           }
//
//           // ── Search Empty ───────────────────────
//           if (state is SearchEmptyState) {
//             return Center(
//               child: Text(
//                 "No products found",
//                 style: getMediumStyle(
//                   color: ColorManager.textSecondary,
//                   fontSize: FontSize.s16,
//                 ),
//               ),
//             );
//           }
//
//           // ── Home Data ──────────────────────────
//           if (state is HomeDataSuccessState) {
//             return RefreshIndicator(
//               color: ColorManager.primary,
//               onRefresh: () async {
//                 context.read<HomeBloc>().add(const GetHomeDataEvent());
//               },
//               child: SingleChildScrollView(
//                 physics: const AlwaysScrollableScrollPhysics(),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // ── Brands Section ───────────
//                     BrandsSection(brands: state.brands),
//
//                     // ── Trends Section ───────────
//                     TrendsSection(trends: state.trends),
//
//                     // ── Best Price Section ────────
//                     BestPriceSection(products: state.bestPriceProducts),
//
//                     const SizedBox(height: AppSize.s20),
//                   ],
//                 ),
//               ),
//             );
//           }
//
//           return const SizedBox();
//         },
//       ),
//     );
//   }
// }
