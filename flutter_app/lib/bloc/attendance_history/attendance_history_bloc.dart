import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import '../../repositories/attendance_repository.dart';

// Event
abstract class AttendanceHistoryEvent extends Equatable {
  const AttendanceHistoryEvent();
  @override
  List<Object?> get props => [];
}

class AttendanceHistoryFetch extends AttendanceHistoryEvent {
  final int userId;
  final String token;
  final DateTime month;
  const AttendanceHistoryFetch({required this.userId, required this.token, required this.month});
  @override
  List<Object?> get props => [userId, token, month];
}

// State
abstract class AttendanceHistoryState extends Equatable {
  const AttendanceHistoryState();
  @override
  List<Object?> get props => [];
}

class AttendanceHistoryInitial extends AttendanceHistoryState {}
class AttendanceHistoryLoading extends AttendanceHistoryState {}
class AttendanceHistoryLoaded extends AttendanceHistoryState {
  final List<Map<String, dynamic>> attendanceList;
  final int absent;
  final int lateClockIn;
  final int earlyClockOut;
  final int noClockIn;
  final int noClockOut;
  final DateTime selectedMonth;
  const AttendanceHistoryLoaded({
    required this.attendanceList,
    required this.absent,
    required this.lateClockIn,
    required this.earlyClockOut,
    required this.noClockIn,
    required this.noClockOut,
    required this.selectedMonth,
  });
  @override
  List<Object?> get props => [attendanceList, absent, lateClockIn, earlyClockOut, noClockIn, noClockOut, selectedMonth];
}
class AttendanceHistoryError extends AttendanceHistoryState {
  final String error;
  const AttendanceHistoryError(this.error);
  @override
  List<Object?> get props => [error];
}

// Bloc
class AttendanceHistoryBloc extends Bloc<AttendanceHistoryEvent, AttendanceHistoryState> {
  final AttendanceRepository repository;
  AttendanceHistoryBloc({required this.repository}) : super(AttendanceHistoryInitial()) {
    on<AttendanceHistoryFetch>(_onFetch);
  }

  Future<void> _onFetch(AttendanceHistoryFetch event, Emitter<AttendanceHistoryState> emit) async {
    emit(AttendanceHistoryLoading());
    try {
      final now = event.month;
      final prevMonth = now.month == 1 ? DateTime(now.year - 1, 12) : DateTime(now.year, now.month - 1);
      final startDate = DateTime(prevMonth.year, prevMonth.month, 21);
      final endDate = DateTime(now.year, now.month, 20);
      final summary = await repository.fetchAttendanceSummary(
        userId: event.userId,
        token: event.token,
        startDate: DateFormat('yyyy-MM-dd').format(startDate),
        endDate: DateFormat('yyyy-MM-dd').format(endDate),
      );
      // Statistik
      final absent = summary['absentDays'] ?? 0;
      final lateClockIn = summary['daysLate'] ?? 0;
      final earlyClockOut = 0; // Isi jika ada di response
      final noClockIn = 0; // Isi jika ada di response
      final noClockOut = 0; // Isi jika ada di response
      // Generate semua tanggal dalam periode
      final List<Map<String, dynamic>> attendanceList = [];
      final data = summary['data'] as Map<String, dynamic>;
      DateTime d = startDate;
      while (!d.isAfter(endDate)) {
        final dateStr = DateFormat('yyyy-MM-dd').format(d);
        final entry = data[dateStr] ?? {};
        attendanceList.add({
          'date': d,
          'clock_in_earliest': entry['clock_in_earliest'] ?? entry['clock_in'] ?? '-',
          'clock_out_latest': entry['clock_out_latest'] ?? entry['clock_out'] ?? '-',
          'clock_in': entry['clock_in'] ?? '-',
          'clock_out': entry['clock_out'] ?? '-',
          'is_holiday': entry['holiday'] != false ? entry['holiday'] : (d.weekday == DateTime.sunday ? 'Hari Libur' : false),
          'leave': entry['leave'] ?? false,
        });
        d = d.add(const Duration(days: 1));
      }
      emit(AttendanceHistoryLoaded(
        attendanceList: attendanceList,
        absent: absent,
        lateClockIn: lateClockIn,
        earlyClockOut: earlyClockOut,
        noClockIn: noClockIn,
        noClockOut: noClockOut,
        selectedMonth: event.month,
      ));
    } catch (e) {
      emit(AttendanceHistoryError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
} 