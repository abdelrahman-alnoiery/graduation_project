// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class CategoriesScreen extends StatelessWidget {
//   const CategoriesScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: const Color(0xFFF5F5F5),
//         child: Column(
//           children: [
//             // Header
//             Container(
//               padding: const EdgeInsets.all(16),
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                 color: Color(0xFF1F3C88),
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(25),
//                   bottomRight: Radius.circular(25),
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 40),
//
//                   Text(
//                     "CarGo",
//                     style: GoogleFonts.mali(
//                       fontSize: 44,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white,
//                       fontStyle: FontStyle.italic,
//                     ),
//                   ),
//
//                   const SizedBox(height: 10),
//
//                   // Search
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Container(
//                           height: 45,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                           padding: const EdgeInsets.symmetric(horizontal: 12),
//                           child: const Row(
//                             children: [
//                               Icon(Icons.search, color: Colors.grey),
//                               SizedBox(width: 8),
//                               Text(
//                                 "Search...",
//                                 style: TextStyle(color: Colors.grey),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Container(
//                         height: 45,
//                         width: 45,
//                         decoration: const BoxDecoration(
//                           color: Colors.white,
//                           shape: BoxShape.circle,
//                         ),
//                         child: const Icon(Icons.shopping_cart_outlined),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//
//             // SizedBox(height: 10),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Text(
//                     "All Categories",
//                     // textAlign: TextAlign.start,
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
