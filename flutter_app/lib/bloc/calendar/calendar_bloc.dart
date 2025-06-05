import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

/// Event untuk CalendarBloc
abstract class CalendarEvent extends Equatable {
  const CalendarEvent();
  @override
  List<Object?> get props => [];
}

/// Event ketika hari pada kalender dipilih
class CalendarDaySelected extends CalendarEvent {
  final DateTime selectedDay;
  final DateTime focusedDay;
  const CalendarDaySelected({required this.selectedDay, required this.focusedDay});
  @override
  List<Object?> get props => [selectedDay, focusedDay];
}

/// State untuk CalendarBloc
class CalendarState extends Equatable {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  const CalendarState({required this.focusedDay, this.selectedDay});
  @override
  List<Object?> get props => [focusedDay, selectedDay];
}

/// Bloc untuk mengelola state kalender
class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc()
      : super(CalendarState(focusedDay: DateTime.now(), selectedDay: null)) {
    on<CalendarDaySelected>(_onDaySelected);
  }

  void _onDaySelected(CalendarDaySelected event, Emitter<CalendarState> emit) {
    emit(CalendarState(focusedDay: event.focusedDay, selectedDay: event.selectedDay));
  }
} 