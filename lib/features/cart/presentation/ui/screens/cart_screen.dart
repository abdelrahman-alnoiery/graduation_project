import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_event.dart';
import 'package:graduation_project/features/cart/presentation/bloc/cart_state.dart';

import '../../../../../core/utils/color_maanger.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _listController;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  late Animation<double> _listFade;

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

  @override
  void dispose() {
    _headerController.dispose();
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      body: Column(
        children: [
          // ── Animated Header ───────────────────────
          FadeTransition(
            opacity: _headerFade,
            child: SlideTransition(
              position: _headerSlide,
              child: _buildHeader(context),
            ),
          ),

          // ── Body ──────────────────────────────────
          Expanded(
            child: BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                if (state is CartLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: ColorManager.primary,
                    ),
                  );
                }

                if (state is CartEmptyState || state is CartInitialState) {
                  return _buildEmpty(context);
                }

                if (state is GetCartItemsSuccessState) {
                  return FadeTransition(
                    opacity: _listFade,
                    child: _buildCartContent(context, state),
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
          // Positioned(
          //   right: -20,
          //   top: -20,
          //   child: Container(
          //     width: 120,
          //     height: 120,
          //     decoration: BoxDecoration(
          //       shape: BoxShape.circle,
          //       color: Colors.white.withOpacity(0.05),
          //     ),
          //   ),
          // ),
          // Positioned(
          //   left: -15,
          //   bottom: 0,
          //   child: Container(
          //     width: 80,
          //     height: 80,
          //     decoration: BoxDecoration(
          //       shape: BoxShape.circle,
          //       color: Colors.white.withOpacity(0.05),
          //     ),
          //   ),
          // ),

          // ── Content ───────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppPadding.p20,
              AppPadding.p52,
              AppPadding.p20,
              AppPadding.p24,
            ),
            child: Row(
              children: [
                // ── Back ──────────────────────
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(AppPadding.p8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(AppRadius.r12),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_rounded,
                      color: Colors.white,
                      size: AppSize.s20,
                    ),
                  ),
                ),

                const SizedBox(width: AppSize.s16),

                // ── Title ─────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "My Cart",
                        style: getBoldStyle(
                          color: Colors.white,
                          fontSize: FontSize.s22,
                        ),
                      ),
                      BlocBuilder<CartBloc, CartState>(
                        builder: (context, state) {
                          final count = state is GetCartItemsSuccessState
                              ? state.cartItems.length
                              : 0;
                          return Text(
                            "$count items",
                            style: getRegularStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: FontSize.s13,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // ── Clear Button ──────────────
                BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    if (state is GetCartItemsSuccessState &&
                        state.cartItems.isNotEmpty) {
                      return GestureDetector(
                        onTap: () => _showClearDialog(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppPadding.p12,
                            vertical: AppPadding.p8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(AppRadius.r12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.white,
                                size: AppSize.s16,
                              ),
                              const SizedBox(width: AppSize.s4),
                              Text(
                                "Clear",
                                style: getMediumStyle(
                                  color: Colors.white,
                                  fontSize: FontSize.s12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Cart Content ──────────────────────────────────
  Widget _buildCartContent(
    BuildContext context,
    GetCartItemsSuccessState state,
  ) {
    final items = state.cartItems;
    final total = items.fold(0.0, (sum, item) => sum + item.totalPrice);
    final savings = items.fold(
      0.0,
      (sum, item) => sum + (item.price * 0.1 * item.quantity),
    );

    return Column(
      children: [
        // ── Items List ────────────────────────
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              AppPadding.p16,
              AppPadding.p16,
              AppPadding.p16,
              AppPadding.p8,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildCartItem(context, item, index);
            },
          ),
        ),

        // ── Order Summary ─────────────────────
        _buildOrderSummary(context, total, savings),
      ],
    );
  }

  // ── Cart Item ─────────────────────────────────────
  Widget _buildCartItem(BuildContext context, item, int index) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: AppMargin.m12),
        decoration: BoxDecoration(
          color: ColorManager.error,
          borderRadius: BorderRadius.circular(AppRadius.r16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppPadding.p20),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_rounded, color: Colors.white, size: AppSize.s28),
            SizedBox(height: AppSize.s4),
            Text(
              "Remove",
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (_) {
        context.read<CartBloc>().add(RemoveCartItemEvent(item.id));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${item.name} removed"),
            backgroundColor: ColorManager.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.r12),
            ),
            action: SnackBarAction(
              label: "Undo",
              textColor: Colors.white,
              onPressed: () {
                context.read<CartBloc>().add(
                  AddCartItemEvent(
                    productId: item.id,
                    productName: item.name,
                    productImage: item.image,
                    price: item.price,
                    quantity: item.quantity,
                  ),
                );
              },
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppMargin.m12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.r16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.p12),
          child: Row(
            children: [
              // ── Image ─────────────────────────
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.r12),
                child: Container(
                  width: AppSize.s80,
                  height: AppSize.s80,
                  color: const Color(0xFFF0F2F8),
                  child: item.image.isNotEmpty
                      ? Image.network(
                          item.image,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildImageError(),
                        )
                      : _buildImageError(),
                ),
              ),

              const SizedBox(width: AppSize.s12),

              // ── Info ──────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: getMediumStyle(
                        color: ColorManager.textPrimary,
                        fontSize: FontSize.s14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: AppSize.s6),

                    Text(
                      "EGP ${item.price.toStringAsFixed(0)} / piece",
                      style: getRegularStyle(
                        color: ColorManager.textSecondary,
                        fontSize: FontSize.s12,
                      ),
                    ),

                    const SizedBox(height: AppSize.s8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // ── Total ──────────────
                        Text(
                          "EGP ${item.totalPrice.toStringAsFixed(0)}",
                          style: getBoldStyle(
                            color: ColorManager.primary,
                            fontSize: FontSize.s15,
                          ),
                        ),

                        // ── Quantity ───────────
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F2F8),
                            borderRadius: BorderRadius.circular(AppRadius.r50),
                          ),
                          child: Row(
                            children: [
                              _buildQtyButton(
                                icon: Icons.remove_rounded,
                                onTap: () {
                                  if (item.quantity > 1) {
                                    context.read<CartBloc>().add(
                                      UpdateCartItemEvent(
                                        productId: item.id,
                                        quantity: item.quantity - 1,
                                      ),
                                    );
                                  } else {
                                    context.read<CartBloc>().add(
                                      RemoveCartItemEvent(item.id),
                                    );
                                  }
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppPadding.p10,
                                ),
                                child: Text(
                                  "${item.quantity}",
                                  style: getBoldStyle(
                                    color: ColorManager.textPrimary,
                                    fontSize: FontSize.s15,
                                  ),
                                ),
                              ),
                              _buildQtyButton(
                                icon: Icons.add_rounded,
                                onTap: () {
                                  context.read<CartBloc>().add(
                                    UpdateCartItemEvent(
                                      productId: item.id,
                                      quantity: item.quantity + 1,
                                    ),
                                  );
                                },
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
  }

  Widget _buildQtyButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppSize.s32,
        height: AppSize.s32,
        decoration: BoxDecoration(
          color: ColorManager.primary,
          borderRadius: BorderRadius.circular(AppRadius.r50),
        ),
        child: Icon(icon, color: Colors.white, size: AppSize.s16),
      ),
    );
  }

  // ── Order Summary ─────────────────────────────────
  Widget _buildOrderSummary(
    BuildContext context,
    double total,
    double savings,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppPadding.p20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppRadius.r32),
          topRight: Radius.circular(AppRadius.r32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Drag Handle ───────────────────────
          Container(
            width: AppSize.s40,
            height: AppSize.s4,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(AppRadius.r4),
            ),
          ),

          const SizedBox(height: AppSize.s16),

          Text(
            "Order Summary",
            style: getBoldStyle(
              color: ColorManager.textPrimary,
              fontSize: FontSize.s16,
            ),
          ),

          const SizedBox(height: AppSize.s16),

          // ── Subtotal ──────────────────────────
          _buildSummaryRow(
            "Subtotal",
            "EGP ${total.toStringAsFixed(0)}",
            isRegular: true,
          ),

          const SizedBox(height: AppSize.s8),

          // ── Shipping ──────────────────────────
          _buildSummaryRow(
            "Shipping",
            "Free",
            valueColor: Colors.green,
            isRegular: true,
          ),

          const SizedBox(height: AppSize.s12),

          Divider(color: Colors.grey.withOpacity(0.15)),

          const SizedBox(height: AppSize.s12),

          // ── Total ─────────────────────────────
          _buildSummaryRow(
            "Total",
            "EGP ${total.toStringAsFixed(0)}",
            isBold: true,
          ),

          const SizedBox(height: AppSize.s20),

          // ── Checkout Button ───────────────────
          GestureDetector(
            onTap: () => _showCheckoutDialog(context, total),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: AppPadding.p16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1a237e), Color(0xFF3949ab)],
                ),
                borderRadius: BorderRadius.circular(AppRadius.r16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1a237e).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.white,
                    size: AppSize.s20,
                  ),
                  const SizedBox(width: AppSize.s8),
                  Text(
                    "Proceed to Checkout",
                    style: getBoldStyle(
                      color: Colors.white,
                      fontSize: FontSize.s16,
                    ),
                  ),
                  const SizedBox(width: AppSize.s8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.p8,
                      vertical: AppPadding.p2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppRadius.r50),
                    ),
                    child: Text(
                      "EGP ${total.toStringAsFixed(0)}",
                      style: getMediumStyle(
                        color: Colors.white,
                        fontSize: FontSize.s12,
                      ),
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

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isBold = false,
    bool isRegular = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isRegular
              ? getRegularStyle(
                  color: ColorManager.textSecondary,
                  fontSize: FontSize.s14,
                )
              : getBoldStyle(
                  color: ColorManager.textPrimary,
                  fontSize: FontSize.s16,
                ),
        ),
        Text(
          value,
          style: isBold
              ? getBoldStyle(
                  color: valueColor ?? ColorManager.primary,
                  fontSize: FontSize.s18,
                )
              : getMediumStyle(
                  color: valueColor ?? ColorManager.textPrimary,
                  fontSize: FontSize.s14,
                ),
        ),
      ],
    );
  }

  // ── Empty State ───────────────────────────────────
  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: AppSize.s130,
            height: AppSize.s130,
            decoration: BoxDecoration(
              color: ColorManager.primary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  color: ColorManager.primary.withOpacity(0.3),
                  size: AppSize.s80,
                ),
                Positioned(
                  top: AppSize.s24,
                  right: AppSize.s24,
                  child: Container(
                    width: AppSize.s28,
                    height: AppSize.s28,
                    decoration: const BoxDecoration(
                      color: ColorManager.error,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        "0",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSize.s24),

          Text(
            "Your Cart is Empty!",
            style: getBoldStyle(
              color: ColorManager.textPrimary,
              fontSize: FontSize.s22,
            ),
          ),

          const SizedBox(height: AppSize.s8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p32),
            child: Text(
              "Looks like you haven't added\nanything to your cart yet",
              style: getRegularStyle(
                color: ColorManager.textSecondary,
                fontSize: FontSize.s14,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: AppSize.s32),

          GestureDetector(
            onTap: () => Navigator.pop(context),
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
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.explore_outlined,
                    color: Colors.white,
                    size: AppSize.s20,
                  ),
                  const SizedBox(width: AppSize.s8),
                  Text(
                    "Start Shopping",
                    style: getBoldStyle(
                      color: Colors.white,
                      fontSize: FontSize.s16,
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

  // ── Checkout Dialog ───────────────────────────────
  void _showCheckoutDialog(BuildContext context, double total) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r24),
        ),
        child: Container(
          padding: const EdgeInsets.all(AppPadding.p24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.r24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppPadding.p16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline_rounded,
                  color: Colors.green,
                  size: AppSize.s40,
                ),
              ),

              const SizedBox(height: AppSize.s16),

              Text(
                "Confirm Order",
                style: getBoldStyle(
                  color: ColorManager.textPrimary,
                  fontSize: FontSize.s20,
                ),
              ),

              const SizedBox(height: AppSize.s8),

              Text(
                "Your order total is",
                style: getRegularStyle(
                  color: ColorManager.textSecondary,
                  fontSize: FontSize.s14,
                ),
              ),

              const SizedBox(height: AppSize.s8),

              Text(
                "EGP ${total.toStringAsFixed(0)}",
                style: getBoldStyle(
                  color: ColorManager.primary,
                  fontSize: FontSize.s28,
                ),
              ),

              const SizedBox(height: AppSize.s8),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.p12,
                  vertical: AppPadding.p8,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppRadius.r8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.local_shipping_outlined,
                      color: Colors.green,
                      size: AppSize.s16,
                    ),
                    const SizedBox(width: AppSize.s6),
                    Text(
                      "Free Shipping",
                      style: getMediumStyle(
                        color: Colors.green,
                        fontSize: FontSize.s13,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSize.s24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                        padding: const EdgeInsets.symmetric(
                          vertical: AppPadding.p14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.r12),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: getMediumStyle(
                          color: ColorManager.textSecondary,
                          fontSize: FontSize.s14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSize.s12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        context.read<CartBloc>().add(const ClearCartEvent());
                        // ✅ أضف ده عشان يتأكد من الـ reload
                        Future.delayed(const Duration(milliseconds: 300), () {
                          context.read<CartBloc>().add(
                            const GetCartItemsEvent(),
                          );
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Row(
                              children: [
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 8),
                                Text("Order placed successfully!"),
                              ],
                            ),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppRadius.r12,
                              ),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppPadding.p14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.r12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "Confirm",
                        style: getBoldStyle(
                          color: Colors.white,
                          fontSize: FontSize.s14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Clear Dialog ──────────────────────────────────
  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r24),
        ),
        child: Container(
          padding: const EdgeInsets.all(AppPadding.p24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.r24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppPadding.p16),
                decoration: BoxDecoration(
                  color: ColorManager.error.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.delete_outline_rounded,
                  color: ColorManager.error,
                  size: AppSize.s36,
                ),
              ),

              const SizedBox(height: AppSize.s16),

              Text(
                "Clear Cart",
                style: getBoldStyle(
                  color: ColorManager.textPrimary,
                  fontSize: FontSize.s20,
                ),
              ),

              const SizedBox(height: AppSize.s8),

              Text(
                "Are you sure you want to\nremove all items from your cart?",
                style: getRegularStyle(
                  color: ColorManager.textSecondary,
                  fontSize: FontSize.s14,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSize.s24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                        padding: const EdgeInsets.symmetric(
                          vertical: AppPadding.p14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.r12),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: getMediumStyle(
                          color: ColorManager.textSecondary,
                          fontSize: FontSize.s14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSize.s12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        context.read<CartBloc>().add(const ClearCartEvent());
                        Future.delayed(const Duration(milliseconds: 300), () {
                          context.read<CartBloc>().add(
                            const GetCartItemsEvent(),
                          );
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.error,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppPadding.p14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.r12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "Clear",
                        style: getBoldStyle(
                          color: Colors.white,
                          fontSize: FontSize.s14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Image Error ───────────────────────────────────
  Widget _buildImageError() {
    return const Center(
      child: Icon(
        Icons.directions_car_outlined,
        color: ColorManager.primary,
        size: AppSize.s32,
      ),
    );
  }
}
