import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final mainTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    textTheme: GoogleFonts.orbitronTextTheme().copyWith(
      bodyLarge: TextStyle(color: Colors.white),
      titleLarge: TextStyle(color: Colors.orangeAccent, fontSize: 24),
    ),
    colorScheme: ColorScheme.dark(
      primary: Colors.orangeAccent,
      secondary: Colors.redAccent,
    ),
  );
}
