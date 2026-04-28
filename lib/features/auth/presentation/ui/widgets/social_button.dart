import 'package:flutter/material.dart';

Widget socialButton(String text) {
  return SizedBox(
    height: 45,
    child: OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFF1F3C88)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onPressed: () {},
      child: Text(text, style: const TextStyle(color: Color(0xFF1F3C88))),
    ),
  );
}
