// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0B1B5B),
//       body: Container(
//         color: const Color(0xFFF2F2F2),
//         child: Column(
//           children: [
//             // Header
//             Container(
//               width: double.infinity,
//               height: 150,
//               decoration: const BoxDecoration(
//                 color: Color(0xFF1F3C88),
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(40),
//                   bottomRight: Radius.circular(40),
//                 ),
//               ),
//               child: Center(
//                 child: Text(
//                   "CarGo",
//                   style: GoogleFonts.mali(
//                     fontSize: 44,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.white,
//                     fontStyle: FontStyle.italic,
//                   ),
//                 ),
//               ),
//             ),
//
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   children: [
//                     // Profile Image
//                     const CircleAvatar(
//                       radius: 45,
//                       backgroundImage: NetworkImage(
//                         "https://images.unsplash.com/photo-1542367597-8849eb950fd8",
//                       ),
//                     ),
//
//                     const SizedBox(height: 10),
//
//                     const Text(
//                       "Abdelrahman Rady",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                       ),
//                     ),
//                     const Text(
//                       "abdelrahmanalnoiery@gmail.com",
//                       style: TextStyle(color: Colors.grey),
//                     ),
//
//                     const SizedBox(height: 20),
//
//                     Row(
//                       children: [
//                         Expanded(child: _textField("First Name")),
//                         const SizedBox(width: 10),
//                         Expanded(child: _textField("Last Name")),
//                       ],
//                     ),
//
//                     const SizedBox(height: 15),
//                     _textField("Phone Number"),
//
//                     const SizedBox(height: 15),
//                     _textField("E-Mail"),
//
//                     const SizedBox(height: 15),
//                     _textField("Password", isPassword: true),
//
//                     const SizedBox(height: 20),
//
//                     // Save Button
//                     SizedBox(
//                       width: double.infinity,
//                       height: 50,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Color(0xFF1F3C88),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                         ),
//                         onPressed: () {},
//                         child: const Text(
//                           "Save Changes",
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ),
//
//                     const SizedBox(height: 10),
//
//                     // Logout Button
//                     SizedBox(
//                       width: double.infinity,
//                       height: 50,
//                       child: OutlinedButton(
//                         style: OutlinedButton.styleFrom(
//                           side: const BorderSide(color: Colors.red),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                         ),
//                         onPressed: () {},
//                         child: const Text(
//                           "Log Out",
//                           style: TextStyle(color: Colors.red),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _textField(String hint, {bool isPassword = false}) {
//     return TextField(
//       obscureText: isPassword,
//       decoration: InputDecoration(
//         hintText: hint,
//         filled: true,
//         fillColor: Colors.white,
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 16,
//           vertical: 14,
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(30),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }
// }
