import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//displayLarge: Font large
final lightTheme = ThemeData(
    hintColor: Colors.grey.withOpacity(0.2),
    brightness: Brightness.light,
    iconTheme:const IconThemeData(color: Colors.black45,),
    textTheme: TextTheme(
        headlineMedium: GoogleFonts.readexPro(color: const Color.fromRGBO(
            58, 59, 60, 1.0).withOpacity(0.5),fontSize: 14),
        displayLarge: GoogleFonts.readexPro(color: const Color.fromRGBO(
            58, 59, 60, 1.0),fontSize: 20),
        displayMedium: GoogleFonts.readexPro(color: const Color.fromRGBO(
            58, 59, 60, 1.0),fontSize: 16),
        headlineSmall: GoogleFonts.readexPro(color: const Color.fromRGBO(
            58, 59, 60, 1.0).withOpacity(0.5),fontSize: 14),
        displaySmall: GoogleFonts.readexPro(color:const Color.fromRGBO(
            58, 59, 60, 1.0),fontSize: 14),
        headlineLarge: GoogleFonts.readexPro(color:const Color.fromRGBO(1, 138, 221, 1.0),fontSize: 25,fontWeight: FontWeight.w500)
    ),
    colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.blue, brightness: Brightness.light)
        .copyWith(
      background: const Color.fromRGBO(
          246, 246, 250, 1.0),
      primary: const Color.fromRGBO(1, 138, 221, 1.0),
        onBackground: Colors.white,
        secondary: Colors.white,
        onSecondary: Colors.grey.withOpacity(0.3)
    ));
