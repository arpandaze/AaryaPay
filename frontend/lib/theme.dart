import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

AppTheme currentTheme = AppTheme();

class AppTheme with ChangeNotifier {
  static bool _isDarkTheme = false;
  ThemeMode get currentTheme => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }

  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xff5484F5),
        tertiary: Color(0xff5B84E5),
        onPrimary: Color(0xFFFFFFFF),
        secondary: Color(0xFFEFF3FF),
        onSecondary: Color(0xff1A1B24),
        error: Color(0xFFFFCE37),
        onError: Color(0xFFFFFFFF),
        background: Color(0xFFFFFFFF),
        onBackground: Color(0xFF2A292F),
        surface: Color(0xffE53636),
        onSurface: Color(0xFF000000),
        outline: Color(0xff78BE7C),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.questrial(
            fontSize: 75,
            fontWeight: FontWeight.w500,
            height: 1.0,
            letterSpacing: -1.5,
            color: const Color(0xFF000000)),
        displayMedium: GoogleFonts.questrial(
          fontSize: 58,
          height: 1.0,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.5,
          color: const Color(0xFF000000),
        ),
        displaySmall: GoogleFonts.questrial(
            fontSize: 35,
            height: 1.0,
            letterSpacing: -0.5,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF000000)),
        headlineMedium: GoogleFonts.questrial(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF000000),
          letterSpacing: 0.25,
        ),
        headlineSmall: GoogleFonts.questrial(
          fontSize: 20,
          height: 1.0,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF000000),
        ),
        titleLarge: GoogleFonts.questrial(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.9,
            color: const Color(0xFF000000),
            height: 1.0),
        titleMedium: GoogleFonts.inconsolata(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.15,
            color: const Color(0xFF000000)),
        titleSmall: GoogleFonts.questrial(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
            color: const Color(0xFF000000)),
        bodyLarge: GoogleFonts.questrial(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.8,
            color: const Color(0xFF000000),
            height: 1.8),
        bodyMedium: GoogleFonts.questrial(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.9,
            color: const Color(0xFFA0A6AC),
            height: 1.5),
        labelLarge: GoogleFonts.questrial(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.25,
            height: 1.0,
            color: Color(0xff5484F5)),
        bodySmall: GoogleFonts.questrial(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
          color: const Color(0xFF000000),
        ),
        labelSmall: GoogleFonts.questrial(
          fontSize: 10,
          fontWeight: FontWeight.w400,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData();
  }
}
