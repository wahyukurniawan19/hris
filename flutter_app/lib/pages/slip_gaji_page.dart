import 'package:flutter/material.dart';
import '../themes/theme.dart';

class SlipGajiPage extends StatelessWidget {
  const SlipGajiPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Slip Gaji'), backgroundColor: primaryBlue),
      backgroundColor: backgroundGray,
      body: const Center(child: Text('Halaman Slip Gaji (Coming Soon)', style: TextStyle(fontFamily: 'Poppins'))),
    );
  }
} 