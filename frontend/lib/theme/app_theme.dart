import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Palette: Creamy background and Deep Jet Black accents
  static const Color creamBg = Color(0xFFFAF7F2);
  static const Color creamSurface = Color(0xFFF3EEE6);
  static const Color creamCard = Color(0xFFF8F4EC);
  static const Color white = Color(0xFFFFFFFF);
  
  static const Color blackPrimary = Color(0xFF121212);
  static const Color blackSecondary = Color(0xFF262626);
  static const Color blackMuted = Color(0xFF4A4A4A);
  
  static const Color greySubtle = Color(0xFF8C8680);
  static const Color borderLight = Color(0xFFE5DFD5);
  static const Color borderDark = Color(0xFF333333);
  
  static const Color accentTan = Color(0xFFC8B39B);
  static const Color accentWarm = Color(0xFFD8CBB9);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: creamBg,
      primaryColor: blackPrimary,
      colorScheme: const ColorScheme.light(
        primary: blackPrimary,
        secondary: blackSecondary,
        surface: creamSurface,
        onPrimary: creamBg,
        onSecondary: creamBg,
        onSurface: blackPrimary,
        outline: borderLight,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: creamBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: blackPrimary, size: 20),
        titleTextStyle: GoogleFonts.playfairDisplay(
          color: blackPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.playfairDisplay(
          color: blackPrimary,
          fontSize: 32,
          fontWeight: FontWeight.w600,
          height: 1.2,
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          color: blackPrimary,
          fontSize: 26,
          fontWeight: FontWeight.w600,
          height: 1.2,
        ),
        headlineMedium: GoogleFonts.playfairDisplay(
          color: blackPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        titleLarge: GoogleFonts.plusJakartaSans(
          color: blackPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: GoogleFonts.plusJakartaSans(
          color: blackPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          color: blackPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          color: blackMuted,
          fontSize: 13,
          fontWeight: FontWeight.w400,
          height: 1.4,
        ),
        bodySmall: GoogleFonts.plusJakartaSans(
          color: greySubtle,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        labelLarge: GoogleFonts.plusJakartaSans(
          color: blackPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: creamSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderLight, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderLight, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: blackPrimary, width: 1.2),
        ),
        hintStyle: GoogleFonts.plusJakartaSans(
          color: greySubtle,
          fontSize: 13,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: blackPrimary,
          foregroundColor: creamBg,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: blackPrimary,
          side: const BorderSide(color: blackPrimary, width: 1.2),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: creamBg,
        selectedItemColor: blackPrimary,
        unselectedItemColor: greySubtle,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
    );
  }
}
