import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // ── Cinematic Void Palette ─────────────────────────────────
  static const void_bg      = Color(0xFF04040A);  // deepest void
  static const deep_bg      = Color(0xFF080812);  // deep dark
  static const glass        = Color(0x09FFFFFF);  // rgba(255,255,255,0.035)
  static const glassBorder  = Color(0x14FFFFFF);  // rgba(255,255,255,0.08)
  static const glassHover   = Color(0x11FFFFFF);  // rgba(255,255,255,0.065)

  static const violet       = Color(0xFF7C5CFC);  // primary accent
  static const violetGlow   = Color(0x597C5CFC);
  static const cyan         = Color(0xFF00E5D4);  // teal accent
  static const cyanGlow     = Color(0x4D00E5D4);
  static const gold         = Color(0xFFF5C542);  // gold accent
  static const goldGlow     = Color(0x4DF5C542);
  static const coral        = Color(0xFFFF6B6B);  // coral
  static const purple       = Color(0xFFB044FC);  // purple
  static const green        = Color(0xFF22D3A0);  // green

  static const white        = Color(0xFFFFFFFF);
  static const muted        = Color(0x73FFFFFF);  // rgba(255,255,255,0.45)
  static const faint        = Color(0x2EFFFFFF);  // rgba(255,255,255,0.18)
  static const border       = Color(0x0FFFFFFF);  // rgba(255,255,255,0.06)

  // Legacy aliases (used in admin/notification screens)
  static const primary      = violet;
  static const accent       = cyan;
  static const highlight    = cyan;
  static const highlight2   = green;
  static const warm         = gold;
  static const primaryMid   = Color(0xFF9D80FD);

  static const darkBg       = void_bg;
  static const darkSurface  = deep_bg;
  static const darkCard     = Color(0x09FFFFFF);
  static const darkBorder   = Color(0x14FFFFFF);
  static const lightBg      = void_bg;
  static const lightSurface = deep_bg;
  static const lightCard    = Color(0x09FFFFFF);
  static const lightBorder  = Color(0x14FFFFFF);

  static const textLight    = white;
  static const textDark     = white;
  static const textMuted    = muted;
  static const textInk2     = Color(0xA6FFFFFF);  // rgba(255,255,255,0.65)
  static const accentDark   = violet;
  static const primaryLight = cyan;
}

class AppTheme {
  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.void_bg,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.violet,
        secondary: AppColors.cyan,
        surface: AppColors.deep_bg,
        background: AppColors.void_bg,
      ),
      textTheme: _buildTextTheme(),
      cardColor: AppColors.glass,
      dividerColor: AppColors.border,
      useMaterial3: true,
    );
  }

  // Keep a light() that just returns dark (design is always dark now)
  static ThemeData light() => dark();

  static TextTheme _buildTextTheme() {
    return GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: GoogleFonts.syne(
        fontSize: 48, color: AppColors.white, height: 1.0,
        fontWeight: FontWeight.w800, letterSpacing: -2.0,
      ),
      displayMedium: GoogleFonts.syne(
        fontSize: 32, color: AppColors.white, height: 1.05,
        fontWeight: FontWeight.w800, letterSpacing: -1.2,
      ),
      headlineLarge: GoogleFonts.syne(
        fontSize: 26, color: AppColors.white,
        fontWeight: FontWeight.w800, letterSpacing: -0.8,
      ),
      headlineMedium: GoogleFonts.syne(
        fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.white,
      ),
      titleLarge: GoogleFonts.outfit(
        fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.white,
      ),
      bodyLarge: GoogleFonts.outfit(
        fontSize: 14, fontWeight: FontWeight.w400,
        color: AppColors.textInk2, height: 1.8,
      ),
      bodyMedium: GoogleFonts.outfit(
        fontSize: 12.5, fontWeight: FontWeight.w400,
        color: AppColors.muted, height: 1.6,
      ),
      labelLarge: GoogleFonts.outfit(
        fontSize: 10, fontWeight: FontWeight.w700,
        color: AppColors.violet, letterSpacing: 1.4,
      ),
    );
  }
}
