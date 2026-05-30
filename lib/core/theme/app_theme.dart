import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final colors = AppColors.light;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: colors.mainPink,
      brightness: Brightness.light,
      surface: colors.creamBackground,
      onSurface: colors.bodyText,
    );

    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colors.creamBackground,
      extensions: const <ThemeExtension<dynamic>>[
        AppColors.light,
      ],
      // Typography
      textTheme: TextTheme(
        displayLarge: GoogleFonts.plusJakartaSans(fontSize: 32, fontWeight: FontWeight.bold, color: colors.bodyText),
        headlineLarge: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.w600, color: colors.bodyText),
        headlineMedium: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.w600, color: colors.bodyText),
        bodyLarge: GoogleFonts.nunitoSans(fontSize: 18, color: colors.bodyText),
        bodyMedium: GoogleFonts.nunitoSans(fontSize: 16, color: colors.bodyText),
        bodySmall: GoogleFonts.nunitoSans(fontSize: 14, color: colors.bodyText),
        labelLarge: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600, color: colors.bodyText),
        labelSmall: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w500, color: colors.bodyText),
      ),
      // Components
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        margin: EdgeInsets.zero,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: colors.mainPink,
        unselectedItemColor: Colors.grey.shade400,
        type: BottomNavigationBarType.fixed,
        elevation: 16,
      ),
    );
  }
}
