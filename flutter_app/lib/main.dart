import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'pages/login_page.dart';

final Color primaryBlue = Color(0xFF1A237E); // Deep blue
final Color backgroundGray = Color(0xFFF5F6FA); // Light gray
final Color cardGray = Color(0xFF232946); // Darker gray for cards

ThemeData appTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: primaryBlue,
  scaffoldBackgroundColor: backgroundGray,
  fontFamily: 'Poppins',
  textTheme: TextTheme(
    titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryBlue),
    bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
  ),
  cardColor: cardGray,
  appBarTheme: AppBarTheme(
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
      textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      elevation: 0,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    filled: true,
    fillColor: Colors.white,
  ),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DHealth HR',
      theme: appTheme,
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
