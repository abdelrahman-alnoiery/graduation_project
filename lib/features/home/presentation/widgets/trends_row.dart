import 'package:flutter/material.dart';
import 'package:graduation_project/config/routes_manager/routes.dart';
import 'package:graduation_project/core/utils/color_maanger.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';
import 'package:graduation_project/features/home/domain/entity/product_entity.dart';

class TrendsRow extends StatelessWidget {
  final List<ProductEntity> trends;

  const TrendsRow({super.key, required this.trends});

  @override
  Widget build(BuildContext context) {
    if (trends.isEmpty) {
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
        itemCount: trends.length,
        itemBuilder: (context, index) {
          final trend = trends[index];
          return _TrendCard(
            trend: trend,
            onTap: () => Navigator.pushNamed(
              context,
              Routes.productDetails,
              arguments: trend,
            ),
          );
        },
      ),
    );
  }
}

class _TrendCard extends StatelessWidget {
  final ProductEntity trend;
  final VoidCallback onTap;

  const _TrendCard({required this.trend, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                          _TrendPlaceholder(name: trend.name),
                    )
                  : _TrendPlaceholder(name: trend.name),
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
                            borderRadius: BorderRadius.circular(AppRadius.r50),
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
  }
}

class _TrendPlaceholder extends StatelessWidget {
  final String name;

  const _TrendPlaceholder({required this.name});

  @override
  Widget build(BuildContext context) {
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
              style: getMediumStyle(color: Colors.white, fontSize: FontSize.s14),
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
