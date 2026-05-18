import 'package:flutter/material.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';

import '../../../../../core/utils/color_maanger.dart';
import '../../../domain/entity/brand_entity.dart';

class BrandsSection extends StatelessWidget {
  final List<BrandEntity> brands;

  const BrandsSection({super.key, required this.brands});

  // ✅ أيقونة لكل brand
  IconData _getBrandIcon(String name) {
    switch (name.toLowerCase()) {
      case 'hyundai':
      case 'kia':
      case 'bmw':
      case 'mercedes':
      case 'toyota':
      case 'nissan':
        return Icons.directions_car;
      default:
        return Icons.directions_car_outlined;
    }
  }

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
            "Global Company",
            style: getBoldStyle(
              color: ColorManager.textPrimary,
              fontSize: FontSize.s16,
            ),
          ),
        ),
        SizedBox(
          height: AppSize.s80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p16),
            itemCount: brands.length,
            itemBuilder: (context, index) {
              final brand = brands[index];
              return Padding(
                padding: const EdgeInsets.only(right: AppPadding.p16),
                child: Column(
                  children: [
                    // ✅ لو في صورة عرضها، لو لأ عرض أيقونة
                    CircleAvatar(
                      radius: AppSize.s24,
                      backgroundColor: ColorManager.primary.withOpacity(0.1),
                      backgroundImage: brand.image.isNotEmpty
                          ? NetworkImage(brand.image)
                          : null,
                      child: brand.image.isEmpty
                          ? Icon(
                              _getBrandIcon(brand.name),
                              color: ColorManager.primary,
                              size: AppSize.s20,
                            )
                          : null,
                    ),
                    const SizedBox(height: AppSize.s4),
                    Text(
                      brand.name,
                      style: getRegularStyle(
                        color: ColorManager.textPrimary,
                        fontSize: FontSize.s12,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
