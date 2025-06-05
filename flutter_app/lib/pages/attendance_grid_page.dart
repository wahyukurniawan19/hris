import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/custom_button.dart';
import '../utils/date_formatter.dart';
import '../themes/theme.dart';
import 'attendance_history_page.dart';
import '../bloc/attendance_grid/attendance_grid_bloc.dart';
import '../repositories/attendance_repository.dart';
import 'attendance_clockin_page.dart';
import 'attendance_clockout_page.dart';

class AttendanceGridPage extends StatelessWidget {
  final Map<String, dynamic> userData;
  final String token;
  const AttendanceGridPage({super.key, required this.userData, required this.token});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AttendanceGridBloc(repository: AttendanceRepository())
        ..add(AttendanceGridFetchToday(userId: userData['id'], token: token)),
      child: _AttendanceGridView(userData: userData, token: token),
    );
  }
}

class _AttendanceGridView extends StatelessWidget {
  final Map<String, dynamic> userData;
  final String token;
  const _AttendanceGridView({required this.userData, required this.token});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr = formatDate(now);

    return Scaffold(
      backgroundColor: primaryBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Absen', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: BlocBuilder<AttendanceGridBloc, AttendanceGridState>(
          builder: (context, state) {
            if (state is AttendanceGridLoading || state is AttendanceGridInitial) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            }
            if (state is AttendanceGridError) {
              return Center(
                child: Text(state.error, style: const TextStyle(color: Colors.white)),
              );
            }
            if (state is AttendanceGridLoaded) {
              final todayData = state.todayData;
              final isHoliday = todayData['holiday'] != false && todayData['holiday'] != null;
              final holidayLabel = isHoliday ? (todayData['holiday']['occassion'] ?? todayData['holiday'].toString()) : null;
              final shiftLabel = isHoliday ? holidayLabel : (todayData['shift'] ?? 'Jam kerja');
              final attendances = todayData['attendances'] as List<dynamic>? ?? [];
              return Column(
                children: [
                  const SizedBox(height: 16),
                  // Jam berjalan
                  StreamBuilder<DateTime>(
                    stream: Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now()),
                    builder: (context, snapshot) {
                      final now = snapshot.data ?? DateTime.now();
                      return Text(
                        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                      );
                    },
                  ),
                  const SizedBox(height: 4),
                  Text(dateStr, style: const TextStyle(color: Colors.white, fontSize: 16)),
                  const SizedBox(height: 12),
                  // Shift/jadwal
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          isHoliday ? (holidayLabel ?? '-') : (todayData['shift'] ?? 'Shift: 08:00 - 17:00'),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  // Tombol Clock In/Out
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                        label: 'Clock In',
                        color: Colors.white,
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AttendanceClockInPage(userData: userData, token: token),
                          ));
                        },
                      ),
                      const SizedBox(width: 16),
                      CustomButton(
                        label: 'Clock Out',
                        color: Colors.white,
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AttendanceClockOutPage(userData: userData, token: token),
                          ));
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  // Daftar absensi hari ini
                  Expanded(
                    child: attendances.isEmpty
                        ? const Center(
                            child: Text('Tidak ada log aktivitas hari ini\nAktivitas Clock In/Out Anda akan tampil di sini',
                                textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
                          )
                        : ListView.builder(
                            itemCount: attendances.length,
                            itemBuilder: (context, i) {
                              final att = attendances[i];
                              String title = '';
                              if (att['clock_in'] != '-' && att['clock_out'] != '-') {
                                title = 'Clock In: ${att['clock_in']}  |  Clock Out: ${att['clock_out']}';
                              } else if (att['clock_in'] != '-') {
                                title = 'Clock In: ${att['clock_in']}';
                              } else if (att['clock_out'] != '-') {
                                title = 'Clock Out: ${att['clock_out']}';
                              }
                              return ListTile(
                                leading: const Icon(Icons.access_time, color: Colors.white),
                                title: Text(title, style: const TextStyle(color: Colors.white)),
                              );
                            },
                          ),
                  ),
                  // Tombol lihat log
                  Padding(
                    padding: const EdgeInsets.only(right: 18, bottom: 12),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AttendanceHistoryPage(userData: userData, token: token),
                          ));
                        },
                        child: const Text('Lihat Log', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
} 