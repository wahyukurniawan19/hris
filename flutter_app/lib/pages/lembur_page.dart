import 'package:flutter/material.dart';
import '../themes/theme.dart';

class LemburPage extends StatelessWidget {
  const LemburPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lembur'), backgroundColor: primaryBlue),
      backgroundColor: backgroundGray,
      body: const Center(child: Text('Halaman Lembur (Coming Soon)', style: TextStyle(fontFamily: 'Poppins'))),
    );
  }
} 