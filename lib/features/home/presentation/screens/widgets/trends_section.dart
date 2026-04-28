import 'package:flutter/material.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';

import '../../../../../core/utils/color_maanger.dart';
import '../../../domain/entity/product_entity.dart';

class TrendsSection extends StatelessWidget {
  final List<ProductEntity> trends;

  const TrendsSection({super.key, required this.trends});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppPadding.p16,
            vertical: AppPadding.p12,
          ),
          child: Text(
            "Trends",
            style: getBoldStyle(
              color: ColorManager.textPrimary,
              fontSize: FontSize.s16,
            ),
          ),
        ),
        SizedBox(
          height: AppSize.s150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
            itemCount: trends.length,
            itemBuilder: (context, index) {
              final trend = trends[index];
              return Padding(
                padding: const EdgeInsets.only(right: AppPadding.p12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.r12),
                  child: Image.network(
                    trend.image,
                    width: AppSize.s200,
                    height: AppSize.s150,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: AppSize.s200,
                      height: AppSize.s150,
                      color: ColorManager.lightGrey,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: ColorManager.grey,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
