import 'package:flutter/material.dart';
import 'package:graduation_project/features/categories/presentation/screens/categories_screen.dart';
import 'package:graduation_project/features/profile_tab/presentation/screens/profile_screen.dart';

import '../chat_bot/presentation/screens/chatbot_screen.dart';
import '../favourite/presentation/ui/screens/favourites_screen.dart';
import '../home/presentation/home_tab.dart';
import 'widgets/bottom_nav_bar.dart';

class HomePageLayout extends StatefulWidget {
  const HomePageLayout({super.key});

  @override
  State<HomePageLayout> createState() => _HomePageLayoutState();
}

class _HomePageLayoutState extends State<HomePageLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    CategoriesScreen(),
    FavouritesScreen(),
    ChatbotScreen(), // ✅ بدل CartScreen
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: MainBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
//
// import '../categories/presentation/categories_tab.dart';
// import '../favourite/presentation/favourite_tab.dart';
// import '../home/presentation/home_tab.dart';
// import '../profile_tab/presentation/profile_tab.dart';
//
// class HomePageLayout extends StatefulWidget {
//   const HomePageLayout({super.key});
//
//   @override
//   State<HomePageLayout> createState() => _HomePageLayoutState();
// }
//
// class _HomePageLayoutState extends State<HomePageLayout> {
//   int selectedIndex = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: tabs[selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         backgroundColor: Color(0xFF1F3C88),
//         selectedItemColor: Colors.white,
//         unselectedItemColor: Colors.black,
//         iconSize: 25,
//         currentIndex: selectedIndex,
//         onTap: (value) {
//           selectedIndex = value;
//           setState(() {});
//         },
//         items: [
//           BottomNavigationBarItem(
//             backgroundColor: Color(0xFF1F3C88),
//             icon: Icon(Icons.home),
//             label: "",
//           ),
//           BottomNavigationBarItem(
//             backgroundColor: Color(0xFF1F3C88),
//             icon: Icon(Icons.grid_view),
//             label: "",
//           ),
//           BottomNavigationBarItem(
//             backgroundColor: Color(0xFF1F3C88),
//             icon: Icon(Icons.favorite_border),
//             label: "",
//           ),
//           BottomNavigationBarItem(
//             backgroundColor: Color(0xFF1F3C88),
//             icon: Icon(Icons.person_outline),
//             label: "",
//           ),
//         ],
//       ),
//     );
//   }
//
//   List<Widget> tabs = [
//     HomeScreen(),
//     CategoriesScreen(),
//     FavoritesScreen(),
//     ProfileScreen(),
//   ];
// }
