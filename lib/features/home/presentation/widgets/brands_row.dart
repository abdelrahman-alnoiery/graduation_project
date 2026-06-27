import 'package:flutter/material.dart';
import 'package:graduation_project/core/utils/color_maanger.dart';
import 'package:graduation_project/core/utils/font_manager.dart';
import 'package:graduation_project/core/utils/styles_manager.dart';
import 'package:graduation_project/core/utils/values_manager.dart';
import 'package:graduation_project/features/home/domain/entity/brand_entity.dart';

class BrandsRow extends StatelessWidget {
  final List<BrandEntity> brands;

  const BrandsRow({super.key, required this.brands});

  static String _getLogo(String brandName) {
    const logos = {
      'Toyota': 'assets/images/png/toyota.png',
      'BMW': 'assets/images/png/bmw.png',
      'Mercedes': 'assets/images/png/Mercedes.png',
      'Hyundai': 'assets/images/png/hyundai.png',
      'KIA': 'assets/images/png/kia.png',
      'Nissan': 'assets/images/png/Nissan.jpeg',
      'Audi': 'assets/images/png/Audi.jpeg',
      'Skoda': 'assets/images/png/skoda.png',
      'Ford': 'assets/images/png/ford.png',
      'Honda': 'assets/images/png/honda.png',
    };
    return logos[brandName] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSize.s90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: brands.length,
        itemBuilder: (context, index) {
          final brand = brands[index];
          return Padding(
            padding: const EdgeInsets.only(right: AppPadding.p14),
            child: Column(
              children: [
                Container(
                  width: AppSize.s56,
                  height: AppSize.s56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1a237e).withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: const Color(0xFF1a237e).withOpacity(0.1),
                    ),
                  ),
                  child: ClipOval(
                    child: Padding(
                      padding: const EdgeInsets.all(AppPadding.p8),
                      child: Image.asset(
                        _getLogo(brand.name),
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Center(
                          child: Text(
                            brand.name[0],
                            style: getBoldStyle(
                              color: const Color(0xFF1a237e),
                              fontSize: FontSize.s20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSize.s6),
                Text(
                  brand.name,
                  style: getMediumStyle(
                    color: ColorManager.textPrimary,
                    fontSize: FontSize.s11,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
