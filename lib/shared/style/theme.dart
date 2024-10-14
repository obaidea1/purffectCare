import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
const Color primaryColor = Color(0xFF80CC28); // Light Green
const Color secondaryColor = Color(0xFF2A9D8F); // Teal
const Color backgroundColor = Color(0xFFEFEFEF); // Light Gray

ThemeData theme = ThemeData(
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: primaryColor,
    onPrimary: Colors.white,
    secondary: secondaryColor,
    onSecondary: Colors.white,
    error: Colors.red,
    onError: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black,
  ),
  primaryColor: primaryColor,
  scaffoldBackgroundColor: backgroundColor,

  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    iconTheme: const IconThemeData(color: primaryColor),
    titleTextStyle: GoogleFonts.poppins(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: primaryColor,
    ),
  ),

  buttonTheme: ButtonThemeData(
    buttonColor: primaryColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
      side: const BorderSide(color: Colors.grey),
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.grey),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: primaryColor),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: primaryColor),
    ),
    labelStyle: const TextStyle(color: primaryColor),
    prefixIconColor: primaryColor,
  ),

  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: primaryColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  ),

  cardTheme: CardTheme(
    elevation: 5,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    margin: const EdgeInsets.all(10),
    color: Colors.white,
  ),

  chipTheme: ChipThemeData(
    backgroundColor: primaryColor.withOpacity(0.2),
    labelStyle: const TextStyle(color: primaryColor),
    shape: const StadiumBorder(),
    selectedColor: primaryColor.withOpacity(0.4),
  ),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: primaryColor,
    unselectedItemColor: Colors.grey,
    selectedLabelStyle: GoogleFonts.poppins(
      color: primaryColor,
      fontWeight: FontWeight.bold,
    ),
    unselectedLabelStyle: GoogleFonts.poppins(
      color: Colors.grey[400],
      fontWeight: FontWeight.normal,
    ),
    selectedIconTheme: const IconThemeData(
      color: primaryColor,
      size: 28,
    ),
    unselectedIconTheme: IconThemeData(
      color: Colors.grey[400],
      size: 24,
    ),
  ),

  textTheme: GoogleFonts.poppinsTextTheme(),  // Applying Poppins font
  useMaterial3: true,
);