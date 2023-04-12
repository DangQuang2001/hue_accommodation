import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


final darkTheme = ThemeData(
    hintColor: Colors.grey.withOpacity(0.2),

    brightness: Brightness.dark,
    iconTheme:const IconThemeData(color: Colors.white,),

    textTheme: TextTheme(
        headlineMedium: GoogleFonts.readexPro(color:  const Color.fromRGBO(
            227, 229, 234, 1.0).withOpacity(0.5),fontSize: 14),
        headlineSmall: GoogleFonts.readexPro(color: const Color.fromRGBO(
            227, 229, 234, 1.0).withOpacity(0.5),fontSize: 14),
        displayLarge: GoogleFonts.readexPro(color:const Color.fromRGBO(
            227, 229, 234, 1.0), fontSize: 20),
        displayMedium: GoogleFonts.readexPro(color: const Color.fromRGBO(
            227, 229, 234, 1.0), fontSize: 16),
        displaySmall: GoogleFonts.readexPro(color: const Color.fromRGBO(
            227, 229, 234, 1.0), fontSize: 14),
        headlineLarge: GoogleFonts.readexPro(color:const Color.fromRGBO(
            227, 229, 234, 1.0),fontSize: 25,fontWeight: FontWeight.w500)
    ),
    colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.blue, brightness: Brightness.dark)
        .copyWith(background: const Color.fromRGBO(24, 25, 26, 1),
        primary: const Color.fromRGBO(71, 72, 73, 1.0),
        onBackground: const Color.fromRGBO(58, 59, 60, 1.0),
        secondary: const Color.fromRGBO(175, 178, 183, 1.0),
        onSecondary: Colors.grey.withOpacity(0.5)
    ));
