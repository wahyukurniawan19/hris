import 'package:flutter/material.dart';
import '../themes/theme.dart';

class CutiPage extends StatelessWidget {
  const CutiPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cuti'), backgroundColor: primaryBlue),
      backgroundColor: backgroundGray,
      body: const Center(child: Text('Halaman Cuti (Coming Soon)', style: TextStyle(fontFamily: 'Poppins'))),
    );
  }
} 