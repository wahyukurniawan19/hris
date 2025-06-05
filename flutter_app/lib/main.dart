import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'pages/login_page.dart';
import 'themes/theme.dart';

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
