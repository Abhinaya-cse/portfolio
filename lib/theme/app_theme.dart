import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Brand
  static const primary = Color(0xFF6C63FF);
  static const primaryLight = Color(0xFF9D97FF);
  static const accent = Color(0xFF00D4AA);
  static const accentDark = Color(0xFF00A882);

  // Dark theme
  static const darkBg = Color(0xFF0D0D0F);
  static const darkSurface = Color(0xFF16161A);
  static const darkCard = Color(0xFF1E1E24);
  static const darkBorder = Color(0xFF2A2A35);

  // Light theme
  static const lightBg = Color(0xFFF8F8FC);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightCard = Color(0xFFF2F2F8);
  static const lightBorder = Color(0xFFE0E0EE);

  // Text
  static const textLight = Color(0xFFF0F0F5);
  static const textMuted = Color(0xFF8888A0);
  static const textDark = Color(0xFF1A1A2E);
}

class AppTheme {
  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBg,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.darkSurface,
        background: AppColors.darkBg,
      ),
      textTheme: GoogleFonts.dmSansTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.dmSans(
          fontSize: 48, fontWeight: FontWeight.w700, color: AppColors.textLight, height: 1.1,
        ),
        displayMedium: GoogleFonts.dmSans(
          fontSize: 36, fontWeight: FontWeight.w700, color: AppColors.textLight, height: 1.2,
        ),
        headlineLarge: GoogleFonts.dmSans(
          fontSize: 28, fontWeight: FontWeight.w600, color: AppColors.textLight,
        ),
        headlineMedium: GoogleFonts.dmSans(
          fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textLight,
        ),
        titleLarge: GoogleFonts.dmSans(
          fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textLight,
        ),
        bodyLarge: GoogleFonts.dmSans(
          fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textMuted, height: 1.6,
        ),
        bodyMedium: GoogleFonts.dmSans(
          fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textMuted, height: 1.6,
        ),
        labelLarge: GoogleFonts.dmSans(
          fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textLight,
          letterSpacing: 0.5,
        ),
      ),
      cardColor: AppColors.darkCard,
      dividerColor: AppColors.darkBorder,
      useMaterial3: true,
    );
  }

  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBg,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.lightSurface,
        background: AppColors.lightBg,
      ),
      textTheme: GoogleFonts.dmSansTextTheme(ThemeData.light().textTheme).copyWith(
        displayLarge: GoogleFonts.dmSans(
          fontSize: 48, fontWeight: FontWeight.w700, color: AppColors.textDark, height: 1.1,
        ),
        displayMedium: GoogleFonts.dmSans(
          fontSize: 36, fontWeight: FontWeight.w700, color: AppColors.textDark, height: 1.2,
        ),
        headlineLarge: GoogleFonts.dmSans(
          fontSize: 28, fontWeight: FontWeight.w600, color: AppColors.textDark,
        ),
        headlineMedium: GoogleFonts.dmSans(
          fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textDark,
        ),
        titleLarge: GoogleFonts.dmSans(
          fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textDark,
        ),
        bodyLarge: GoogleFonts.dmSans(
          fontSize: 16, fontWeight: FontWeight.w400, color: const Color(0xFF555566), height: 1.6,
        ),
        bodyMedium: GoogleFonts.dmSans(
          fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xFF555566), height: 1.6,
        ),
        labelLarge: GoogleFonts.dmSans(
          fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textDark,
          letterSpacing: 0.5,
        ),
      ),
      cardColor: AppColors.lightCard,
      dividerColor: AppColors.lightBorder,
      useMaterial3: true,
    );
  }
}
