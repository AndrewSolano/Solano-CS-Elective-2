import 'package:flutter/material.dart';

// One place that defines ALL the colors, text styles, and button styles
// for the whole app. We apply these at the MaterialApp level (see main.dart)
// instead of hardcoding colors inside individual widgets.
//
// This satisfies the "Design Theming" requirement.

class AppTheme {
  // Brand color used to generate the whole color scheme.
  static const Color seedColor = Color(0xFF2563EB); // modern tech blue
  static const Color darkAppBar = Color(0xFF111827); // slate-900

  static const TextTheme _textTheme = TextTheme(
    headlineSmall: TextStyle(fontWeight: FontWeight.w800, fontSize: 24, letterSpacing: -0.5),
    titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    titleMedium: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
    titleSmall: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
    bodyLarge: TextStyle(fontSize: 15, height: 1.4),
    bodyMedium: TextStyle(fontSize: 14, height: 1.4),
    labelLarge: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF7F8FA),
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    ),
    textTheme: _textTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: seedColor,
      foregroundColor: Colors.white,
      centerTitle: false,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: seedColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: seedColor.withValues(alpha: 0.08),
      labelStyle: const TextStyle(color: seedColor, fontWeight: FontWeight.w600, fontSize: 12),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide.none,
    ),
    dividerColor: const Color(0xFFE5E7EB),
    // Used by the cart icon's item-count badge on Home.
    badgeTheme: const BadgeThemeData(
      backgroundColor: seedColor,
      textColor: Colors.white,
    ),
    // Used by the "Added to cart" feedback in AddToCartControls.
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color(0xFF111827),
      contentTextStyle: const TextStyle(color: Colors.white),
      actionTextColor: const Color(0xFF93C5FD),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0B0F19),
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    ),
    textTheme: _textTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkAppBar,
      foregroundColor: Colors.white,
      centerTitle: false,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: seedColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF161B29),
      surfaceTintColor: Colors.transparent,
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: seedColor.withValues(alpha: 0.18),
      labelStyle: const TextStyle(color: Color(0xFF93C5FD), fontWeight: FontWeight.w600, fontSize: 12),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide.none,
    ),
    dividerColor: const Color(0xFF2A3142),
    badgeTheme: const BadgeThemeData(
      backgroundColor: Color(0xFF93C5FD),
      textColor: darkAppBar,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: seedColor,
      contentTextStyle: const TextStyle(color: Colors.white),
      actionTextColor: Colors.white,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}
