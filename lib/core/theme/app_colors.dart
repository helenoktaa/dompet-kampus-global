import 'package:flutter/material.dart';

class AppColors {
  // Primary Purple
  static const Color primary = Color(0xFF5448D6);
  static const Color primaryLight = Color(0xFF8A82E7);
  static const Color primaryDark = Color(0xFF1708BB);
  static const Color primaryDeep = Color(0xFF0C0093);
  static const Color primaryDarker = Color(0xFF080060);
  static const Color primaryDarkest = Color(0xFF030026);
  static const Color primarySurface = Color(0xFFF6F5FF);
  static const Color primaryBorder = Color(0xFFD3D0F8);

  // Semantic
  static const Color green = Color(0xFF16A571);
  static const Color greenSurface = Color(0xFFE8F8F2);
  static const Color amber = Color(0xFFD98512);
  static const Color amberSurface = Color(0xFFFDF3E3);
  static const Color red = Color(0xFFE5484D);
  static const Color redSurface = Color(0xFFFDECED);
  static const Color violet = Color(0xFF8A82E7);
  static const Color violetSurface = Color(0xFFE8E6FC);

  // Neutral
  static const Color ink = Color(0xFF0E1726);
  static const Color slate600 = Color(0xFF4B5E78);
  static const Color slate500 = Color(0xFF6B7A90);
  static const Color slate400 = Color(0xFF9DABBE);
  static const Color slate300 = Color(0xFFCBD2DD);
  static const Color line = Color(0xFFE8ECF2);
  static const Color line2 = Color(0xFFF3F5F8);
  static const Color bg = Color(0xFFF6F5FF);
  static const Color white = Color(0xFFFFFFFF);

  // Gradient splash
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.5, 1.0],
    colors: [primaryDark, primary, primaryLight],
  );

  // Gradient card
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDeep, primaryDark],
  );

  // Shadows
  static List<BoxShadow> shadowCard = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 24,
      spreadRadius: 0,
      offset: Offset(0, 4),
    ),
  ];
  static List<BoxShadow> shadowSoft = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 12,
      spreadRadius: 0,
      offset: Offset(0, 2),
    ),
  ];
  static List<BoxShadow> shadowPrimary = [
    BoxShadow(
      color: Color(0x525448D6),
      blurRadius: 22,
      spreadRadius: 0,
      offset: Offset(0, 10),
    ),
  ];

  static Map<String, List<Color>> tones = {
    'blue': [primarySurface, primary],
    'green': [greenSurface, green],
    'amber': [amberSurface, amber],
    'red': [redSurface, red],
    'violet': [violetSurface, violet],
    'slate': [bg, slate600],
  };

  static List<Color> tone(String name) => tones[name] ?? tones['blue']!;
}