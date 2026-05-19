import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized theme for FlowSpace — Space Grotesk + Disney Blue palette.
///
/// All colors, typography, spacing, radius, and decoration helpers live here.
/// Widget files should reference [AppTheme] tokens instead of hardcoding values.
class AppTheme {
  AppTheme._();

  // ── BACKGROUNDS ─────────────────────────────────────────────────────────────
  static const Color background = Color(0xFF000000);
  static const Color surfaceCard = Color(0xFF080C14);
  static const Color surfaceElevated = Color(0xFF0D1520);
  static const Color surfaceBorder = Color(0xFF1A2640);
  static const Color surfaceHover = Color(0xFF0F1E35);

  // ── DISNEY BLUE PALETTE ─────────────────────────────────────────────────────
  static const Color primary = Color(0xFF006EE6);
  static const Color primaryLight = Color(0xFF1A85FF);
  static const Color primaryDark = Color(0xFF0055B3);
  static const Color primaryGlow = Color(0x33006EE6);
  static const Color primarySubtle = Color(0xFF001A3D);

  // ── ACCENT ──────────────────────────────────────────────────────────────────
  static const Color accent = Color(0xFF00B4FF);
  static const Color accentSubtle = Color(0xFF001F3D);

  // ── TEXT ─────────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF6B8CAE);
  static const Color textMuted = Color(0xFF2D4A6B);

  // ── SEMANTIC COLORS ─────────────────────────────────────────────────────────
  static const Color success = Color(0xFF00D4AA);
  static const Color warning = Color(0xFFFFB800);
  static const Color danger = Color(0xFFFF3B5C);
  static const Color dangerSubtle = Color(0xFF3D0015);

  // ── GRADIENTS ───────────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF006EE6), Color(0xFF00B4FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF080C14), Color(0xFF0D1520)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF000000), Color(0xFF000C1A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ── SPACING ─────────────────────────────────────────────────────────────────
  static const double spaceXXS = 2.0;
  static const double spaceXS = 4.0;
  static const double spaceSM = 8.0;
  static const double spaceMD = 16.0;
  static const double spaceLG = 24.0;
  static const double spaceXL = 32.0;
  static const double spaceXXL = 48.0;

  // ── BORDER RADIUS ───────────────────────────────────────────────────────────
  static const double radiusXS = 6.0;
  static const double radiusSM = 10.0;
  static const double radiusMD = 14.0;
  static const double radiusLG = 18.0;
  static const double radiusXL = 24.0;
  static const double radiusFull = 999.0;

  // ── CARD STYLE ──────────────────────────────────────────────────────────────
  static BoxDecoration get cardDecoration => BoxDecoration(
        color: surfaceCard,
        borderRadius: BorderRadius.circular(radiusLG),
        border: Border.all(color: surfaceBorder, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      );

  // ── GLASSMORPHISM CARD ──────────────────────────────────────────────────────
  static BoxDecoration get glassDecoration => BoxDecoration(
        color: const Color(0xFF080C14).withOpacity(0.85),
        borderRadius: BorderRadius.circular(radiusLG),
        border: Border.all(color: const Color(0xFF1A2640), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF006EE6).withOpacity(0.08),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      );

  // ── PRIMARY BUTTON STYLE ────────────────────────────────────────────────────
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: spaceMD,
          vertical: spaceSM + 4,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMD),
        ),
        elevation: 0,
        shadowColor: primaryGlow,
      ).copyWith(
        overlayColor: WidgetStateProperty.all(
          primaryLight.withOpacity(0.15),
        ),
      );

  // ── TYPOGRAPHY ──────────────────────────────────────────────────────────────
  static TextTheme get textTheme => GoogleFonts.spaceGroteskTextTheme(
        const TextTheme(
          // ── Display ─────────────────────
          displayLarge: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w700,
            color: Color(0xFFFFFFFF),
            letterSpacing: -1.5,
            height: 1.1,
          ),
          displayMedium: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w700,
            color: Color(0xFFFFFFFF),
            letterSpacing: -1.0,
            height: 1.15,
          ),

          // ── Headlines ───────────────────
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Color(0xFFFFFFFF),
            letterSpacing: -0.8,
            height: 1.2,
          ),
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFFFFFFFF),
            letterSpacing: -0.5,
            height: 1.25,
          ),
          headlineSmall: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFFFFFFFF),
            letterSpacing: -0.3,
            height: 1.3,
          ),

          // ── Titles ──────────────────────
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFFFFFFFF),
            letterSpacing: -0.2,
            height: 1.35,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFFFFFFFF),
            letterSpacing: -0.1,
            height: 1.4,
          ),
          titleSmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFFFFFFFF),
            letterSpacing: 0.0,
            height: 1.4,
          ),

          // ── Body ────────────────────────
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFFFFFFFF),
            letterSpacing: 0.0,
            height: 1.5,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF6B8CAE),
            letterSpacing: 0.0,
            height: 1.5,
          ),
          bodySmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: Color(0xFF6B8CAE),
            letterSpacing: 0.1,
            height: 1.5,
          ),

          // ── Labels ──────────────────────
          labelLarge: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFFFFFFFF),
            letterSpacing: 0.5,
            height: 1.4,
          ),
          labelMedium: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6B8CAE),
            letterSpacing: 1.2,
            height: 1.4,
          ),
          labelSmall: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6B8CAE),
            letterSpacing: 1.5,
            height: 1.4,
          ),
        ),
      );

  // ── THEME DATA ──────────────────────────────────────────────────────────────
  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: background,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF006EE6),
          secondary: Color(0xFF00B4FF),
          surface: Color(0xFF080C14),
          error: Color(0xFFFF3B5C),
          onPrimary: Color(0xFFFFFFFF),
          onSecondary: Color(0xFFFFFFFF),
          onSurface: Color(0xFFFFFFFF),
          onError: Color(0xFFFFFFFF),
          outline: Color(0xFF1A2640),
        ),
        textTheme: textTheme,
        fontFamily: GoogleFonts.spaceGrotesk().fontFamily,

        // AppBar
        appBarTheme: AppBarTheme(
          backgroundColor: background,
          foregroundColor: textPrimary,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: GoogleFonts.spaceGrotesk(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: -0.3,
          ),
          iconTheme: const IconThemeData(color: Color(0xFFFFFFFF)),
        ),

        // Bottom Navigation Bar
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF000000),
          selectedItemColor: Color(0xFF006EE6),
          unselectedItemColor: Color(0xFF2D4A6B),
          elevation: 0,
          type: BottomNavigationBarType.fixed,
        ),

        // Cards
        cardTheme: CardThemeData(
          color: const Color(0xFF080C14),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: Color(0xFF1A2640), width: 1),
          ),
        ),

        // Divider
        dividerTheme: const DividerThemeData(
          color: Color(0xFF1A2640),
          thickness: 1,
        ),

        // Input fields
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF080C14),
          hintStyle: GoogleFonts.spaceGrotesk(
            color: const Color(0xFF2D4A6B),
            fontSize: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF1A2640)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF1A2640)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF006EE6), width: 1.5),
          ),
        ),

        // Snackbar
        snackBarTheme: SnackBarThemeData(
          backgroundColor: const Color(0xFF0D1520),
          contentTextStyle: GoogleFonts.spaceGrotesk(
            color: Colors.white,
            fontSize: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          behavior: SnackBarBehavior.floating,
        ),

        // Bottom Sheet
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Color(0xFF080C14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
        ),

        // Dialog
        dialogTheme: DialogThemeData(
          backgroundColor: const Color(0xFF0D1520),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titleTextStyle: GoogleFonts.spaceGrotesk(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),

        // Chip
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFF080C14),
          selectedColor: const Color(0xFF001A3D),
          labelStyle: GoogleFonts.spaceGrotesk(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          side: const BorderSide(color: Color(0xFF1A2640)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
}
