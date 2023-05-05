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
        primary: Color(0xff274233),
        tertiary: Color.fromARGB(255, 6, 44, 133),
        onPrimary: Color.fromARGB(255, 210, 210, 210),
        secondary: Color(0xffFFAB2D),
        onSecondary: Color(0xff1A1B24),
        error: Color(0xFFFFCE37),
        onError: Color(0xFFFFFFFF),
        background: Color(0xffFfffff),
        onBackground: Color(0xFF2A292F),
        surface: Color.fromARGB(255, 160, 160, 160),
        onSurface: Color.fromARGB(255, 206, 52, 52),
        outline: Color.fromARGB(255, 160, 160, 160),
        surfaceVariant: Color.fromARGB(255, 29, 153, 84),
        onTertiary: Color.fromARGB(255, 137, 139, 137),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.mulish(
              fontSize: 50,
            fontWeight: FontWeight.w500,
            height: 1.0,
            letterSpacing: -1.5,
            color: const Color(0xFF000000)),
        displayMedium: GoogleFonts.mulish(
          fontSize: 32,
          height: 1.0,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.5,
          color: const Color(0xFF000000),
        ),
        displaySmall: GoogleFonts.mulish(
              fontSize: 32,
            height: 1.0,
            letterSpacing: -0.5,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF000000)),
        headlineMedium: GoogleFonts.mulish(
          fontSize: 25,
            fontWeight: FontWeight.w500,
          color: const Color(0xFF000000),
          letterSpacing: 0.25,
        ),
        headlineSmall: GoogleFonts.mulish(
          fontSize: 20,
          height: 1.0,
            fontWeight: FontWeight.w500,
          color: const Color(0xFF000000),
        ),
        titleLarge: GoogleFonts.mulish(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              // letterSpacing: 0.9,
            color: const Color(0xFF000000),
            height: 1.0),
        titleMedium: GoogleFonts.mulish(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            letterSpacing: 0.15,
            color: const Color(0xFF000000)),
        titleSmall: GoogleFonts.mulish(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.2,
            color: const Color(0xFF000000)),
        bodyLarge: GoogleFonts.mulish(
            fontSize: 15,
            fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
            color: const Color(0xFF000000),
        ),
        bodyMedium: GoogleFonts.mulish(
            fontSize: 12,
              fontWeight: FontWeight.w500,
            letterSpacing: 0.2,
            color: const Color(0xFF000000),
            height: 1.5),
        bodySmall: GoogleFonts.mulish(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2,
          color: const Color(0xFF000000),
        ),
        labelLarge: GoogleFonts.questrial(
            fontSize: 35,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.0,
            height: 1.0,
              color: const Color(0xff5484F5)),
       
        labelMedium: GoogleFonts.questrial(
          fontSize: 18,
            fontWeight: FontWeight.w500,
          letterSpacing: 1.0,
        ),
        labelSmall: GoogleFonts.questrial(
          fontSize: 13,
            fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData();
  }
}
