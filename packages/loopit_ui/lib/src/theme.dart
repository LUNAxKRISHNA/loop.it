import 'package:flutter/material.dart';

class LoopitColors {
  static const Color black = Color(0xFF111111);
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF9F9F9);
  
  // Greys
  static const Color grey50 = Color(0xFFF2F2F2);
  static const Color grey100 = Color(0xFFE5E5E5);
  static const Color grey300 = Color(0xFFD4D4D4);
  static const Color grey500 = Color(0xFF737373);
  static const Color grey800 = Color(0xFF262626);
}

class LoopitTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: LoopitColors.black,
      scaffoldBackgroundColor: LoopitColors.background,
      fontFamily: 'Inter', // Assuming Inter or similar is used
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: LoopitColors.black, fontWeight: FontWeight.bold, fontSize: 32, height: 1.1),
        displayMedium: TextStyle(color: LoopitColors.black, fontWeight: FontWeight.bold, fontSize: 28, height: 1.2),
        bodyLarge: TextStyle(color: LoopitColors.grey800, fontSize: 16),
        bodyMedium: TextStyle(color: LoopitColors.grey500, fontSize: 14),
      ),
      colorScheme: const ColorScheme.light(
        primary: LoopitColors.black,
        secondary: LoopitColors.grey500,
        surface: LoopitColors.white,
      ),
    );
  }
}
