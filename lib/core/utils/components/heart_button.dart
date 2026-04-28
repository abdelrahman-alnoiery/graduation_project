import 'package:flutter/material.dart';

import '../color_maanger.dart';
import '../values_manager.dart';

class HeartButton extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onTap;
  final double? size;
  final Color? activeColor;
  final Color? inactiveColor;

  const HeartButton({
    super.key,
    required this.isFavorite,
    required this.onTap,
    this.size,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  State<HeartButton> createState() => _HeartButtonState();
}

class _HeartButtonState extends State<HeartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    _controller.forward().then((_) => _controller.reverse());
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Icon(
          widget.isFavorite ? Icons.favorite : Icons.favorite_border,
          color: widget.isFavorite
              ? (widget.activeColor ?? ColorManager.error)
              : (widget.inactiveColor ?? ColorManager.grey),
          size: widget.size ?? AppSize.s24,
        ),
      ),
    );
  }
}
