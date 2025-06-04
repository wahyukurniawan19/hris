import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../repositories/attendance_repository.dart';

// Event
abstract class AttendanceGridEvent extends Equatable {
  const AttendanceGridEvent();
  @override
  List<Object?> get props => [];
}

class AttendanceGridFetchToday extends AttendanceGridEvent {
  final int userId;
  final String token;
  const AttendanceGridFetchToday({required this.userId, required this.token});
  @override
  List<Object?> get props => [userId, token];
}

// State
abstract class AttendanceGridState extends Equatable {
  const AttendanceGridState();
  @override
  List<Object?> get props => [];
}

class AttendanceGridInitial extends AttendanceGridState {}
class AttendanceGridLoading extends AttendanceGridState {}
class AttendanceGridLoaded extends AttendanceGridState {
  final Map<String, dynamic> todayData;
  const AttendanceGridLoaded(this.todayData);
  @override
  List<Object?> get props => [todayData];
}
class AttendanceGridError extends AttendanceGridState {
  final String error;
  const AttendanceGridError(this.error);
  @override
  List<Object?> get props => [error];
}

// Bloc
class AttendanceGridBloc extends Bloc<AttendanceGridEvent, AttendanceGridState> {
  final AttendanceRepository repository;
  AttendanceGridBloc({required this.repository}) : super(AttendanceGridInitial()) {
    on<AttendanceGridFetchToday>(_onFetchToday);
  }

  Future<void> _onFetchToday(AttendanceGridFetchToday event, Emitter<AttendanceGridState> emit) async {
    emit(AttendanceGridLoading());
    try {
      final todayData = await repository.fetchTodayAttendance(userId: event.userId, token: event.token);
      emit(AttendanceGridLoaded(todayData));
    } catch (e) {
      emit(AttendanceGridError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
} 