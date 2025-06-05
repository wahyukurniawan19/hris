class Attendance {
  final int id;
  final DateTime date;
  final String status;

  Attendance({required this.id, required this.date, required this.status});

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'],
      date: DateTime.parse(json['date']),
      status: json['status'],
    );
  }
} 