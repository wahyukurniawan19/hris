import 'package:flutter/material.dart';

const Color primaryBlue = Color(0xFF1A237E); // Deep blue
const Color backgroundGray = Color(0xFFF5F6FA); // Light gray
const Color cardGray = Color(0xFF232946); // Darker gray for cards

final ThemeData appTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: primaryBlue,
  scaffoldBackgroundColor: backgroundGray,
  fontFamily: 'Poppins',
  textTheme: const TextTheme(
    titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryBlue),
    bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
  ),
  cardColor: cardGray,
  appBarTheme: const AppBarTheme(
    backgroundColor: primaryBlue,
    foregroundColor: Colors.white,
    elevation: 0,
    titleTextStyle: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 20),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryBlue,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      elevation: 0,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    filled: true,
    fillColor: Colors.white,
  ),
); 