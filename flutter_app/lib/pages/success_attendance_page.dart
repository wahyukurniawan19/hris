import 'package:flutter/material.dart';
import '../themes/theme.dart';
import '../widgets/custom_button.dart';
import 'dashboard_page.dart';
import 'attendance_history_page.dart';

class SuccessAttendancePage extends StatelessWidget {
  final bool isClockIn;
  final Map<String, dynamic> userData;
  final String token;
  final String scheduleDate;
  final String scheduleTime;
  final String clockTime;

  const SuccessAttendancePage({
    Key? key,
    required this.isClockIn,
    required this.userData,
    required this.token,
    required this.scheduleDate,
    required this.scheduleTime,
    required this.clockTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            Icon(Icons.check_circle_rounded, size: 120, color: Color(0xFF2ECC40)),
            const SizedBox(height: 24),
            Text(
              isClockIn ? 'Jam masuk berhasil' : 'Jam pulang berhasil',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF232946)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Jadwal: $scheduleDate',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            Text(
              scheduleTime,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              clockTime,
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF232946)),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      label: 'kembali ke beranda',
                      color: primaryBlue,
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => DashboardPage(userData: userData, token: token),
                          ),
                          (route) => false,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => AttendanceHistoryPage(userData: userData, token: token),
                        ),
                        (route) => false,
                      );
                    },
                    child: const Text(
                      'Lihat daftar absensi',
                      style: TextStyle(fontSize: 15, color: Colors.grey, decoration: TextDecoration.underline),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 