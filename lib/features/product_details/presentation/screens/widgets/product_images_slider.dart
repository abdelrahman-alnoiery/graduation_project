import 'package:flutter/material.dart';
import 'package:graduation_project/core/utils/values_manager.dart';

import '../../../../../core/utils/color_maanger.dart';

class ProductImagesSlider extends StatefulWidget {
  final List<String> images;

  const ProductImagesSlider({super.key, required this.images});

  @override
  State<ProductImagesSlider> createState() => _ProductImagesSliderState();
}

class _ProductImagesSliderState extends State<ProductImagesSlider> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Main Image ─────────────────────────
        SizedBox(
          height: AppSize.s250,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              return Image.network(
                widget.images[index],
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.image_not_supported_outlined,
                  color: ColorManager.grey,
                  size: AppSize.s60,
                ),
              );
            },
          ),
        ),

        const SizedBox(height: AppSize.s12),

        // ── Thumbnail Row ──────────────────────
        SizedBox(
          height: AppSize.s60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              final isSelected = _currentIndex == index;
              return GestureDetector(
                onTap: () {
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(right: AppMargin.m8),
                  width: AppSize.s60,
                  height: AppSize.s60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.r8),
                    border: Border.all(
                      color: isSelected
                          ? ColorManager.primary
                          : ColorManager.lightGrey,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.r8),
                    child: Image.network(
                      widget.images[index],
                      fit: BoxFit.cover,
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
