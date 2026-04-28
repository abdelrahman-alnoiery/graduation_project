import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_event.dart';
import 'package:graduation_project/features/product_details/presentation/bloc/product_details_bloc.dart';
import 'package:graduation_project/features/product_details/presentation/bloc/product_details_event.dart';
import 'package:graduation_project/features/product_details/presentation/bloc/product_details_state.dart';

import '../../../../core/utils/color_maanger.dart';
import '../../../../core/utils/components/main_button.dart';
import '../../../home/domain/entity/product_entity.dart';
import 'widgets/color_selector.dart';
import 'widgets/product_images_slider.dart';
import 'widgets/size_selector.dart';

class ProductsDetails extends StatefulWidget {
  const ProductsDetails({super.key});

  @override
  State<ProductsDetails> createState() => _ProductsDetailsState();
}

class _ProductsDetailsState extends State<ProductsDetails> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    final product =
        ModalRoute.of(context)?.settings.arguments as ProductEntity?;
    if (product != null) {
      context.read<ProductDetailsBloc>().add(
        GetProductDetailsEvent(product.id),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        backgroundColor: ColorManager.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: ColorManager.textPrimary,
          ),
        ),
        title: Text(
          "Product Details",
          style: getBoldStyle(
            color: ColorManager.textPrimary,
            fontSize: FontSize.s18,
          ),
        ),
        actions: [
          // ── Favourite Button ───────────────
          BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
            builder: (context, state) {
              if (state is ProductDetailsSuccessState) {
                return IconButton(
                  onPressed: () {
                    context.read<ProductDetailsBloc>().add(
                      ToggleFavouriteEvent(state.product.id),
                    );
                  },
                  icon: Icon(
                    state.product.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: state.product.isFavorite
                        ? ColorManager.error
                        : ColorManager.grey,
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      body: BlocConsumer<ProductDetailsBloc, ProductDetailsState>(
        listener: (context, state) {
          if (state is ProductDetailsErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failure.message),
                backgroundColor: ColorManager.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProductDetailsLoadingState) {
            return const Center(
              child: CircularProgressIndicator(color: ColorManager.primary),
            );
          }

          if (state is ProductDetailsSuccessState) {
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: AppSize.s80),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Images Slider ──────────
                      Padding(
                        padding: const EdgeInsets.all(AppPadding.p16),
                        child: ProductImagesSlider(
                          images: state.product.images,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppPadding.p16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Name & Price ───────
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.product.name,
                                        style: getBoldStyle(
                                          color: ColorManager.textPrimary,
                                          fontSize: FontSize.s16,
                                        ),
                                      ),
                                      Text(
                                        "Review (${state.product.reviewCount})",
                                        style: getRegularStyle(
                                          color: ColorManager.grey,
                                          fontSize: FontSize.s12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "EGP ${state.product.price.toStringAsFixed(0)}",
                                      style: getBoldStyle(
                                        color: ColorManager.primary,
                                        fontSize: FontSize.s16,
                                      ),
                                    ),
                                    Text(
                                      "EGP ${state.product.oldPrice.toStringAsFixed(0)}",
                                      style:
                                          getRegularStyle(
                                            color: ColorManager.grey,
                                            fontSize: FontSize.s12,
                                          ).copyWith(
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: AppSize.s16),

                            // ── Description ────────
                            Text(
                              "Description",
                              style: getBoldStyle(
                                color: ColorManager.textPrimary,
                                fontSize: FontSize.s14,
                              ),
                            ),
                            const SizedBox(height: AppSize.s4),
                            Text(
                              _isExpanded
                                  ? state.product.description
                                  : state.product.description.length > 100
                                  ? '${state.product.description.substring(0, 100)}...'
                                  : state.product.description,
                              style: getRegularStyle(
                                color: ColorManager.textSecondary,
                                fontSize: FontSize.s12,
                              ),
                            ),
                            if (state.product.description.length > 100)
                              GestureDetector(
                                onTap: () =>
                                    setState(() => _isExpanded = !_isExpanded),
                                child: Text(
                                  _isExpanded ? "Read Less" : "Read More",
                                  style: getMediumStyle(
                                    color: ColorManager.primary,
                                    fontSize: FontSize.s12,
                                  ),
                                ),
                              ),

                            const SizedBox(height: AppSize.s16),

                            // ── Color ──────────────
                            if (state.product.colors.isNotEmpty) ...[
                              Text(
                                "Color",
                                style: getBoldStyle(
                                  color: ColorManager.textPrimary,
                                  fontSize: FontSize.s14,
                                ),
                              ),
                              const SizedBox(height: AppSize.s8),
                              ColorSelector(
                                colors: state.product.colors,
                                selectedColor: state.selectedColor,
                                onColorSelected: (color) {
                                  context.read<ProductDetailsBloc>().add(
                                    ChangeColorEvent(color),
                                  );
                                },
                              ),
                              const SizedBox(height: AppSize.s16),
                            ],

                            // ── Size ───────────────
                            if (state.product.sizes.isNotEmpty) ...[
                              Text(
                                "Size",
                                style: getBoldStyle(
                                  color: ColorManager.textPrimary,
                                  fontSize: FontSize.s14,
                                ),
                              ),
                              const SizedBox(height: AppSize.s8),
                              SizeSelector(
                                sizes: state.product.sizes,
                                selectedSize: state.selectedSize,
                                onSizeSelected: (size) {
                                  context.read<ProductDetailsBloc>().add(
                                    ChangeSizeEvent(size),
                                  );
                                },
                              ),
                            ],

                            const SizedBox(height: AppSize.s20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Bottom Button ──────────────
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(AppPadding.p16),
                    decoration: BoxDecoration(
                      color: ColorManager.white,
                      boxShadow: [
                        BoxShadow(
                          color: ColorManager.grey.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: MainButton(
                            title: "Buy Now",
                            onPressed: () {
                              context.read<CartBloc>().add(
                                AddCartItemEvent(
                                  productId: state.product.id,
                                  productName: state.product.name,
                                  productImage: state.product.images.isNotEmpty
                                      ? state.product.images.first
                                      : '',
                                  price: state.product.price,
                                  quantity: 1,
                                ),
                              );
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        const SizedBox(width: AppSize.s12),

                        // ── Cart Icon ──────────
                        GestureDetector(
                          onTap: () {
                            context.read<CartBloc>().add(
                              AddCartItemEvent(
                                productId: state.product.id,
                                productName: state.product.name,
                                productImage: state.product.images.isNotEmpty
                                    ? state.product.images.first
                                    : '',
                                price: state.product.price,
                                quantity: 1,
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(AppPadding.p12),
                            decoration: BoxDecoration(
                              color: ColorManager.primary,
                              borderRadius: BorderRadius.circular(
                                AppRadius.r12,
                              ),
                            ),
                            child: const Icon(
                              Icons.shopping_cart_outlined,
                              color: ColorManager.white,
                              size: AppSize.s24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
