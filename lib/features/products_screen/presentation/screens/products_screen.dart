import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';
import 'package:graduation_project/features/products_screen/presentation/bloc/products_bloc.dart';
import 'package:graduation_project/features/products_screen/presentation/bloc/products_event.dart';
import 'package:graduation_project/features/products_screen/presentation/bloc/products_state.dart';

import '../../../../core/utils/color_maanger.dart';
import '../../../categories/domain/entity/category_entity.dart';
import 'widgets/product_item.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void initState() {
    super.initState();
    final category =
        ModalRoute.of(context)?.settings.arguments as CategoryEntity?;
    if (category != null) {
      context.read<ProductsBloc>().add(GetProductsByCategoryEvent(category.id));
    } else {
      context.read<ProductsBloc>().add(const GetAllProductsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final category =
        ModalRoute.of(context)?.settings.arguments as CategoryEntity?;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: ColorManager.primary,
        title: Text(
          category?.name ?? "All Products",
          style: getBoldStyle(
            color: ColorManager.white,
            fontSize: FontSize.s18,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: ColorManager.white),
        ),
      ),
      body: BlocConsumer<ProductsBloc, ProductsState>(
        listener: (context, state) {
          if (state is ProductsErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failure.message),
                backgroundColor: ColorManager.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProductsLoadingState) {
            return const Center(
              child: CircularProgressIndicator(color: ColorManager.primary),
            );
          }

          if (state is ProductsEmptyState) {
            return Center(
              child: Text(
                "No products found",
                style: getMediumStyle(
                  color: ColorManager.textSecondary,
                  fontSize: FontSize.s16,
                ),
              ),
            );
          }

          if (state is ProductsSuccessState) {
            return GridView.builder(
              padding: const EdgeInsets.all(AppPadding.p16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSize.s12,
                mainAxisSpacing: AppSize.s12,
                childAspectRatio: 0.7,
              ),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                return ProductItem(product: state.products[index]);
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
