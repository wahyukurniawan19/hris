import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../themes/theme.dart';
import '../utils/date_formatter.dart';
import 'attendance_clockin_page.dart';
import 'attendance_clockout_page.dart';
import 'calendar_page.dart';
import 'attendance_history_page.dart';
import 'cuti_page.dart';
import 'slip_gaji_page.dart';
import 'lembur_page.dart';
import 'attendance_grid_page.dart';


class DashboardPage extends StatelessWidget {
  final Map<String, dynamic> userData;
  final String token;
  final bool showSuccess;
  final String? successMessage;
  const DashboardPage({super.key, required this.userData, required this.token, this.showSuccess = false, this.successMessage});

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Selamat pagi,';
    if (hour < 15) return 'Selamat siang,';
    if (hour < 18) return 'Selamat sore,';
    return 'Selamat malam,';
  }

  @override
  Widget build(BuildContext context) {
    if (showSuccess && successMessage != null) {
      Future.delayed(Duration.zero, () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(successMessage!),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 5),
          ),
        );
      });
    }
    final name = userData['name'] ?? '-';
    final now = DateTime.now();
    final dateStr = formatDate(now);
    final profilePic = userData['profile_pic'] ?? null;
    
    return Scaffold(
      backgroundColor: backgroundGray,
      bottomNavigationBar: _BottomNavBar(selectedIndex: 0),
      body: SafeArea(
        child: Column(
          children: [
            // Notification Banner (if any)
            _NotificationBanner(),
            // Header Card
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: primaryBlue,
                    backgroundImage: profilePic != null ? NetworkImage(profilePic) : null,
                    child: profilePic == null ? Icon(Icons.person, color: Colors.white, size: 36) : null,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getGreeting(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1A237E),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A237E),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dateStr,
                          style: const TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none, color: Color(0xFF1A237E)),
                    onPressed: () {
                      // Show notifications page
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Clock In/Out Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      label: 'Clock In',
                      color: primaryBlue,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AttendanceClockInPage(userData: userData, token: token),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      label: 'Clock Out',
                      color: primaryBlue,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AttendanceClockOutPage(userData: userData, token: token),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            // Menu Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  mainAxisSpacing: 18,
                  crossAxisSpacing: 18,
                  childAspectRatio: 1.2,
                  children: [
                    _DashboardMenuItem(
                      icon: Icons.list_alt,
                      label: 'Daftar Absen',
                      iconColor: Color(0xFF43A047),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AttendanceHistoryPage(userData: userData, token: token),
                          ),
                        );
                      },
                    ),
                    _DashboardMenuItem(
                      icon: Icons.calendar_today,
                      label: 'Kalender',
                      iconColor: Color(0xFFFBC02D),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const CalendarPage()),
                        );
                      },
                    ),
                    _DashboardMenuItem(
                      icon: Icons.how_to_reg,
                      label: 'Absen',
                      iconColor: Color(0xFF1976D2),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AttendanceGridPage(userData: userData, token: token),
                          ),
                        );
                      },
                    ),
                    _DashboardMenuItem(
                      icon: Icons.beach_access,
                      label: 'Cuti',
                      iconColor: Color(0xFF00897B),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const CutiPage()),
                        );
                      },
                    ),
                    _DashboardMenuItem(
                      icon: Icons.receipt_long,
                      label: 'Slip Gaji',
                      iconColor: Color(0xFF6D4C41),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const SlipGajiPage()),
                        );
                      },
                    ),
                    _DashboardMenuItem(
                      icon: Icons.access_time,
                      label: 'Lembur',
                      iconColor: Color(0xFFD84315),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const LemburPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _bulanIndo(int bulan) {
    const namaBulan = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return namaBulan[bulan];
  }
}

class _DashboardMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? iconColor;
  final VoidCallback? onTap;
  const _DashboardMenuItem({required this.icon, required this.label, this.iconColor, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 38, color: iconColor ?? primaryBlue),
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF232946)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  const _BottomNavBar({required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      backgroundColor: Colors.white,
      selectedItemColor: primaryBlue,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Karyawan'),
        BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifikasi'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
      ],
      onTap: (index) {
        // TODO: Implement navigation
      },
    );
  }
}

class _NotificationBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Example: show a static notification, replace with dynamic logic as needed
    return Container(
      width: double.infinity,
      color: primaryBlue,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: const [
          Icon(Icons.info_outline, color: Colors.white, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Jangan lupa absen hari ini!',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
} 