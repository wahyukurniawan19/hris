import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import '../bloc/calendar/calendar_bloc.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CalendarBloc(),
      child: const _CalendarView(),
    );
  }
}

class _CalendarView extends StatelessWidget {
  const _CalendarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalender'),
        backgroundColor: const Color(0xFF1A237E),
      ),
      backgroundColor: const Color(0xFFF5F6FA),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocBuilder<CalendarBloc, CalendarState>(
              builder: (context, state) {
                return TableCalendar(
                  firstDay: DateTime.utc(2000, 1, 1),
                  lastDay: DateTime.utc(2100, 12, 31),
                  focusedDay: state.focusedDay,
                  selectedDayPredicate: (day) => isSameDay(state.selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    context.read<CalendarBloc>().add(
                      CalendarDaySelected(selectedDay: selectedDay, focusedDay: focusedDay),
                    );
                  },
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: const Color(0xFF1A237E).withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: const BoxDecoration(
                      color: Color(0xFF1A237E),
                      shape: BoxShape.circle,
                    ),
                    weekendTextStyle: const TextStyle(color: Colors.redAccent),
                    defaultTextStyle: const TextStyle(fontFamily: 'Poppins'),
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF1A237E),
                    ),
                    leftChevronIcon: Icon(Icons.chevron_left, color: Color(0xFF1A237E)),
                    rightChevronIcon: Icon(Icons.chevron_right, color: Color(0xFF1A237E)),
                  ),
                  calendarFormat: CalendarFormat.month,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
} 