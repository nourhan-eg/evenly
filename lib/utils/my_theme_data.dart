import 'package:evently_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyThemeData {
  static final LightModeColors _lightColors = LightModeColors();
  static final DarkModeColors _darkColors = DarkModeColors();

  static ThemeData lightMode = ThemeData(
      brightness: Brightness.light,
      primaryColor: _lightColors.primaryColor(),
      scaffoldBackgroundColor: _lightColors.backgroundColor(),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            backgroundColor: _lightColors.primaryColor(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.white24),
            ),
          )
      ),
      textTheme: TextTheme(
        titleLarge: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
        titleMedium:  GoogleFonts.poppins(
          fontSize: 18,
          fontWeight:  FontWeight.w500,
        ),
        titleSmall:GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400),
      )
  );

  static ThemeData darkMode = ThemeData(
      brightness: Brightness.dark,
      primaryColor: _darkColors.primaryColor(),
      scaffoldBackgroundColor: _darkColors.backgroundColor(),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            backgroundColor: _darkColors.primaryColor(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.white24),
            ),
          )
      ),
      textTheme: TextTheme(
        titleLarge: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        titleMedium:  GoogleFonts.poppins(
          fontSize: 18,
          fontWeight:  FontWeight.w500,
          color: Colors.white,
        ),
        titleSmall:GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white70),
      )
  );
}