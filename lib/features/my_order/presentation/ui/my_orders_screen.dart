import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project/core/network/check_internet_connection.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../data/datasources/my_orders_remote_datasource_impl.dart';
import '../../data/repository/my_orders_repo_impl.dart';
import '../../domain/entity/order_entity.dart';
import '../../domain/usecases/get_my_orders_usecase.dart';
import '../bloc/my_orders_bloc.dart';
import '../bloc/my_orders_event.dart';
import '../bloc/my_orders_state.dart';

import 'package:intl/intl.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MyOrdersBloc(
        getMyOrdersUseCase: GetMyOrdersUseCase(
          MyOrdersRepoImpl(
            remoteDataSource: MyOrdersRemoteDatasourceImpl(),
            networkInfo: CheckInternetConnectionImpl(
              InternetConnectionChecker(),
            ),
          ),
        ),
      )..add(const GetMyOrdersEvent()),
      child: const _MyOrdersView(),
    );
  }
}

class _MyOrdersView extends StatelessWidget {
  const _MyOrdersView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      body: Column(
        children: [
          // ── Header ──────────────────────────────
          _buildHeader(context),

          // ── Content ─────────────────────────────
          Expanded(
            child: BlocBuilder<MyOrdersBloc, MyOrdersState>(
              builder: (context, state) {
                if (state is MyOrdersLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF1a237e)),
                  );
                }

                if (state is MyOrdersErrorState) {
                  return _buildError(context, state.message);
                }

                if (state is MyOrdersLoadedState) {
                  if (state.orders.isEmpty) {
                    return _buildEmpty();
                  }
                  return RefreshIndicator(
                    color: const Color(0xFF1a237e),
                    onRefresh: () async {
                      context.read<MyOrdersBloc>().add(
                        const GetMyOrdersEvent(),
                      );
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.all(AppPadding.p16),
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      itemCount: state.orders.length,
                      itemBuilder: (ctx, i) =>
                          _OrderCard(order: state.orders[i]),
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ─────────────────────────────────────────
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
            color: Color(0x441a237e),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppPadding.p20,
          AppPadding.p52,
          AppPadding.p20,
          AppPadding.p24,
        ),
        child: Row(
          children: [
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Orders',
                  style: getBoldStyle(
                    color: Colors.white,
                    fontSize: FontSize.s22,
                  ),
                ),
                Text(
                  'Track your purchases',
                  style: getRegularStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: FontSize.s13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Empty State ────────────────────────────────────
  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppPadding.p24),
              decoration: BoxDecoration(
                color: const Color(0xFF1a237e).withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: Color(0xFF1a237e),
                size: 64,
              ),
            ),
            const SizedBox(height: AppSize.s20),
            Text(
              'No Orders Yet',
              style: getBoldStyle(
                color: const Color(0xFF1a237e),
                fontSize: FontSize.s20,
              ),
            ),
            const SizedBox(height: AppSize.s8),
            Text(
              'Your order history will appear here\nonce you make a purchase.',
              style: getRegularStyle(
                color: Colors.grey,
                fontSize: FontSize.s14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ── Error State ────────────────────────────────────
  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.redAccent,
              size: 64,
            ),
            const SizedBox(height: AppSize.s16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: getRegularStyle(
                color: Colors.grey,
                fontSize: FontSize.s14,
              ),
            ),
            const SizedBox(height: AppSize.s20),
            ElevatedButton(
              onPressed: () =>
                  context.read<MyOrdersBloc>().add(const GetMyOrdersEvent()),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1a237e),
              ),
              child: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Order Card ──────────────────────────────────────
class _OrderCard extends StatelessWidget {
  final OrderEntity order;
  const _OrderCard({required this.order});

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'processing':
        return Colors.orange;
      case 'shipped':
        return Colors.blue;
      default:
        return const Color(0xFF1a237e);
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Icons.check_circle_rounded;
      case 'cancelled':
        return Icons.cancel_rounded;
      case 'processing':
        return Icons.autorenew_rounded;
      case 'shipped':
        return Icons.local_shipping_rounded;
      default:
        return Icons.pending_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(order.status);
    final formattedDate = DateFormat('MMM dd, yyyy').format(order.createdAt);

    return Container(
      margin: const EdgeInsets.only(bottom: AppMargin.m16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.r20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Order Header ──────────────────────────
          Container(
            padding: const EdgeInsets.all(AppPadding.p16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.06),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppRadius.r20),
                topRight: Radius.circular(AppRadius.r20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppPadding.p8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _statusIcon(order.status),
                    color: color,
                    size: AppSize.s20,
                  ),
                ),
                const SizedBox(width: AppSize.s12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${order.id.length > 8 ? order.id.substring(order.id.length - 8) : order.id}',
                        style: getBoldStyle(
                          color: const Color(0xFF1a237e),
                          fontSize: FontSize.s14,
                        ),
                      ),
                      Text(
                        formattedDate,
                        style: getRegularStyle(
                          color: Colors.grey,
                          fontSize: FontSize.s12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.p10,
                    vertical: AppPadding.p4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppRadius.r50),
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Text(
                    order.status.toUpperCase(),
                    style: getMediumStyle(color: color, fontSize: FontSize.s11),
                  ),
                ),
              ],
            ),
          ),

          // ── Order Items ───────────────────────────
          ...order.items.map((item) => _OrderItemRow(item: item)),

          // ── Order Total ───────────────────────────
          Container(
            padding: const EdgeInsets.all(AppPadding.p16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${order.items.length} item${order.items.length != 1 ? 's' : ''}',
                  style: getRegularStyle(
                    color: Colors.grey,
                    fontSize: FontSize.s13,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Total',
                      style: getRegularStyle(
                        color: Colors.grey,
                        fontSize: FontSize.s11,
                      ),
                    ),
                    Text(
                      'EGP ${order.totalPrice.toStringAsFixed(0)}',
                      style: getBoldStyle(
                        color: const Color(0xFF1a237e),
                        fontSize: FontSize.s16,
                      ),
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
}

// ── Order Item Row ──────────────────────────────────
class _OrderItemRow extends StatelessWidget {
  final OrderItemEntity item;
  const _OrderItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.p16,
        vertical: AppPadding.p10,
      ),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF5F5F5))),
      ),
      child: Row(
        children: [
          // ── Product Image ──────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.r10),
            child: item.productImage.isNotEmpty
                ? Image.network(
                    item.productImage,
                    width: AppSize.s52,
                    height: AppSize.s52,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _imagePlaceholder(),
                  )
                : _imagePlaceholder(),
          ),

          const SizedBox(width: AppSize.s12),

          // ── Product Info ───────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName.isNotEmpty ? item.productName : 'Product',
                  style: getMediumStyle(
                    color: const Color(0xFF1a237e),
                    fontSize: FontSize.s13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSize.s4),
                Text(
                  'Qty: ${item.quantity}',
                  style: getRegularStyle(
                    color: Colors.grey,
                    fontSize: FontSize.s12,
                  ),
                ),
              ],
            ),
          ),

          // ── Price ──────────────────────────────
          Text(
            'EGP ${(item.price * item.quantity).toStringAsFixed(0)}',
            style: getBoldStyle(
              color: const Color(0xFF1a237e),
              fontSize: FontSize.s13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: AppSize.s52,
      height: AppSize.s52,
      color: const Color(0xFFF0F2F8),
      child: const Icon(
        Icons.directions_car_outlined,
        color: Colors.grey,
        size: 24,
      ),
    );
  }
}
