import 'package:flutter/material.dart';
import 'package:graduation_project/core/utils/font_manager.dart';

import '../../../core/utils/color_maanger.dart';

class MainBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MainBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: ColorManager.white,
        selectedItemColor: ColorManager.primary,
        unselectedItemColor: ColorManager.grey,
        selectedFontSize: FontSize.s12,
        unselectedFontSize: FontSize.s12,
        elevation: 0,
        items: const [
          // ── Home ──────────────────────────────
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home",
          ),

          // ── Categories ────────────────────────
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            activeIcon: Icon(Icons.category),
            label: "Categories",
          ),

          // ── Favourites ────────────────────────
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            activeIcon: Icon(Icons.favorite),
            label: "Favourites",
          ),

          // ── Chatbot ───────────────────────────
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy_outlined),
            activeIcon: Icon(Icons.smart_toy),
            label: "Chatbot",
          ),

          // ── Profile ───────────────────────────
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
