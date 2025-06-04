import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// Event
abstract class CalendarEvent extends Equatable {
  const CalendarEvent();
  @override
  List<Object?> get props => [];
}

class CalendarDaySelected extends CalendarEvent {
  final DateTime selectedDay;
  final DateTime focusedDay;
  const CalendarDaySelected({required this.selectedDay, required this.focusedDay});
  @override
  List<Object?> get props => [selectedDay, focusedDay];
}

// State
class CalendarState extends Equatable {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  const CalendarState({required this.focusedDay, this.selectedDay});
  @override
  List<Object?> get props => [focusedDay, selectedDay];
}

// Bloc
class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc()
      : super(CalendarState(focusedDay: DateTime.now(), selectedDay: null)) {
    on<CalendarDaySelected>((event, emit) {
      emit(CalendarState(focusedDay: event.focusedDay, selectedDay: event.selectedDay));
    });
  }
} 