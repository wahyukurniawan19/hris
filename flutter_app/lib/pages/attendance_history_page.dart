import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/attendance_history/attendance_history_bloc.dart';
import '../repositories/attendance_repository.dart';

class AttendanceHistoryPage extends StatelessWidget {
  final Map<String, dynamic> userData;
  final String token;
  const AttendanceHistoryPage({super.key, required this.userData, required this.token});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AttendanceHistoryBloc(repository: AttendanceRepository())
        ..add(AttendanceHistoryFetch(userId: userData['id'], token: token, month: DateTime.now())),
      child: _AttendanceHistoryView(userData: userData, token: token),
    );
  }
}

class _AttendanceHistoryView extends StatelessWidget {
  final Map<String, dynamic> userData;
  final String token;
  const _AttendanceHistoryView({required this.userData, required this.token});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceHistoryBloc, AttendanceHistoryState>(
      builder: (context, state) {
        if (state is AttendanceHistoryLoading || state is AttendanceHistoryInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is AttendanceHistoryError) {
          return Scaffold(
            body: Center(child: Text(state.error)),
          );
        }
        if (state is AttendanceHistoryLoaded) {
          return DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Daftar Absensi'),
                backgroundColor: const Color(0xFF1A237E),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                bottom: const TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  indicatorColor: Colors.white,
                  tabs: [
                    Tab(text: 'Riwayat'),
                    Tab(text: 'Absensi'),
                    Tab(text: 'Shift'),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  _RiwayatTab(state: state, userId: userData['id'], token: token),
                  const Center(child: Text('Absensi (coming soon)', style: TextStyle(color: Colors.grey))),
                  const Center(child: Text('Shift (coming soon)', style: TextStyle(color: Colors.grey))),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _RiwayatTab extends StatelessWidget {
  final AttendanceHistoryLoaded state;
  final int userId;
  final String token;
  const _RiwayatTab({required this.state, required this.userId, required this.token});

  void _showMonthPicker(BuildContext context) async {
    final result = await showDialog<DateTime>(
      context: context,
      builder: (context) => _MonthPickerDialog(selected: state.selectedMonth),
    );
    if (result != null) {
      context.read<AttendanceHistoryBloc>().add(
        AttendanceHistoryFetch(userId: userId, token: token, month: result),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final monthStr = DateFormat('MMMM yyyy', 'id_ID').format(state.selectedMonth);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFF1A237E)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => _showMonthPicker(context),
                  icon: const Icon(Icons.calendar_today, color: Color(0xFF1A237E)),
                  label: Text(monthStr, style: const TextStyle(color: Color(0xFF1A237E))),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFE3E8F8),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _StatBox(label: 'Absent', value: state.absent.toString()),
                    _StatBox(label: 'Late clock in', value: state.lateClockIn.toString()),
                    _StatBox(label: 'Early clock out', value: state.earlyClockOut.toString()),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _StatBox(label: 'No clock in', value: state.noClockIn.toString()),
                    _StatBox(label: 'No clock out', value: state.noClockOut.toString()),
                    const SizedBox(width: 80),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            itemCount: state.attendanceList.length,
            itemBuilder: (context, i) {
              final item = state.attendanceList[i];
              final date = item['date'] as DateTime;
              final clockIn = item['clock_in_earliest'] ?? item['clock_in'] ?? '-';
              final clockOut = item['clock_out_latest'] ?? item['clock_out'] ?? '-';
              final isHolidayNational = item['is_holiday'] is String && item['is_holiday'] != '' && item['is_holiday'] != 'Hari Libur';
              final isHoliday = item['is_holiday'] == 'Hari Libur' || isHolidayNational;
              final isSaturday = date.weekday == DateTime.saturday;
              final isSunday = date.weekday == DateTime.sunday;

              Color fontColor = Colors.black;
              if (isSunday || isHolidayNational) {
                fontColor = Colors.red;
              } else if (isSaturday) {
                fontColor = Colors.redAccent;
              } else if (isHoliday) {
                fontColor = Colors.red;
              }

              return Container(
                color: isHoliday ? const Color(0xFFFFEBEE) : null,
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Tanggal dan status
                      Container(
                        width: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('d MMM', 'id_ID').format(date),
                              style: TextStyle(
                                color: fontColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 1),
                            isHolidayNational
                                ? Text(
                                    item['is_holiday'].toString(),
                                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 11),
                                  )
                                : isHoliday
                                    ? const Text('Hari libur', style: TextStyle(color: Colors.red, fontSize: 11))
                                    : Text('Jam kerja', style: TextStyle(color: fontColor.withOpacity(0.7), fontSize: 11)),
                          ],
                        ),
                      ),
                      // Jam clock in
                      Expanded(
                        child: Center(
                          child: Text(
                            clockIn,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: fontColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      // Jam clock out
                      Expanded(
                        child: Center(
                          child: Text(
                            clockOut,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: fontColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      // Icon detail
                      const Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Icon(Icons.chevron_right, color: Colors.grey, size: 24),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  const _StatBox({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.black54)),
      ],
    );
  }
}

class _MonthPickerDialog extends StatefulWidget {
  final DateTime selected;
  const _MonthPickerDialog({required this.selected});
  @override
  State<_MonthPickerDialog> createState() => _MonthPickerDialogState();
}

class _MonthPickerDialogState extends State<_MonthPickerDialog> {
  late int year;
  late int month;
  @override
  void initState() {
    super.initState();
    year = widget.selected.year;
    month = widget.selected.month;
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => setState(() => year--),
                ),
                Text('$year', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => setState(() => year++),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 320,
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: List.generate(12, (i) {
                  final m = i + 1;
                  final isSelected = m == month;
                  return GestureDetector(
                    onTap: () => setState(() => month = m),
                    child: Container(
                      width: 56,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? Color(0xFF1A237E) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isSelected ? Color(0xFF1A237E) : Colors.grey.shade300),
                      ),
                      child: Text(
                        DateFormat('MMM', 'id_ID').format(DateTime(0, m)),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.of(context).pop(DateTime(year, month)),
              child: const Text('LIHAT HASIL', style: TextStyle(color: Color(0xFF1A237E), fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
} 