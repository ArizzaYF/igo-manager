import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Navy — same in both themes
  static const Color primary = Color(0xFF1E3A5F);
  static const Color primaryLight = Color(0xFF2C5282);
  static const Color primaryDark = Color(0xFF0F2440);
  static const Color primaryShade = Color(0xFFE8EDF3);

  // Accent Gold
  static const Color accent = Color(0xFFF5C44E);
  static const Color accentDark = Color(0xFFD4940F);
  static const Color accentLight = Color(0xFFFCE8A0);

  // Quadrant colors — fixed semantic meaning
  static const Color hacerYa = Color(0xFF2E7D32);
  static const Color estrategico = Color(0xFFF5C44E);
  static const Color rutina = Color(0xFF1565C0);
  static const Color descarte = Color(0xFF9E9E9E);

  // Semantic colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFED6C02);
  static const Color error = Color(0xFFD32F2F);
  static const Color info = Color(0xFF0288D1);

  // Surface colors (light mode defaults)
  static const Color background = Color(0xFFF5F6FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFEEEEEE);

  // Text colors (light mode defaults)
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnAccent = Color(0xFF212121);

  // Overlay
  static const Color overlay = Color(0x80000000);
  static const Color shimmer = Color(0xFFE0E0E0);

  // Dark mode constants
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF2C2C2C);
  static const Color darkBorder = Color(0xFF3A3A3A);
  static const Color darkDivider = Color(0xFF333333);
  static const Color darkTextPrimary = Color(0xFFE0E0E0);
  static const Color darkTextSecondary = Color(0xFF9E9E9E);
  static const Color darkTextHint = Color(0xFF616161);
  static const Color darkPrimaryShade = Color(0xFF1A2A40);

  /// Returns the correct color palette based on the current [context]'s brightness.
  static AppColorPalette of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      return AppColorPalette(
        background: darkBackground,
        surface: darkSurface,
        card: darkCard,
        border: darkBorder,
        divider: darkDivider,
        textPrimary: darkTextPrimary,
        textSecondary: darkTextSecondary,
        textHint: darkTextHint,
        primaryShade: darkPrimaryShade,
        shimmer: darkTextSecondary,
      );
    }
    return AppColorPalette(
      background: background,
      surface: surface,
      card: card,
      border: border,
      divider: divider,
      textPrimary: textPrimary,
      textSecondary: textSecondary,
      textHint: textHint,
      primaryShade: primaryShade,
      shimmer: shimmer,
    );
  }
}

class AppColorPalette {
  final Color background;
  final Color surface;
  final Color card;
  final Color border;
  final Color divider;
  final Color textPrimary;
  final Color textSecondary;
  final Color textHint;
  final Color primaryShade;
  final Color shimmer;

  // Fixed colors (same in both themes)
  Color get primary => AppColors.primary;
  Color get primaryLight => AppColors.primaryLight;
  Color get primaryDark => AppColors.primaryDark;
  Color get accent => AppColors.accent;
  Color get accentDark => AppColors.accentDark;
  Color get accentLight => AppColors.accentLight;
  Color get hacerYa => AppColors.hacerYa;
  Color get estrategico => AppColors.estrategico;
  Color get rutina => AppColors.rutina;
  Color get descarte => AppColors.descarte;
  Color get success => AppColors.success;
  Color get warning => AppColors.warning;
  Color get error => AppColors.error;
  Color get info => AppColors.info;
  Color get textOnPrimary => AppColors.textOnPrimary;
  Color get textOnAccent => AppColors.textOnAccent;
  Color get overlay => AppColors.overlay;

  const AppColorPalette({
    required this.background,
    required this.surface,
    required this.card,
    required this.border,
    required this.divider,
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
    required this.primaryShade,
    required this.shimmer,
  });
}
