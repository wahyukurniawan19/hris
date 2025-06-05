import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config.dart';

class AttendanceService {
  /// Submit clock-in data ke server
  Future<Map<String, dynamic>> submitClockIn({
    required String token,
    required int userId,
    required String? note,
    required File? imageFile,
    required double latitude,
    required double longitude,
  }) async {
    String? base64Image;
    if (imageFile != null) {
      List<int> imageBytes = await imageFile.readAsBytes();
      base64Image = base64Encode(imageBytes);
    }
    final url = Uri.parse('$baseUrl/clock-in');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user_id': userId,
        'note': note,
        'photo': base64Image,
        'latitude': latitude,
        'longitude': longitude,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Clock In gagal: ${response.body}');
    }
  }

  /// Submit clock-out data ke server
  Future<Map<String, dynamic>> submitClockOut({
    required String token,
    required int userId,
    required String? note,
    required File? imageFile,
    required double latitude,
    required double longitude,
  }) async {
    String? base64Image;
    if (imageFile != null) {
      List<int> imageBytes = await imageFile.readAsBytes();
      base64Image = base64Encode(imageBytes);
    }
    final url = Uri.parse('$baseUrl/clock-out');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user_id': userId,
        'note': note,
        'photo': base64Image,
        'latitude': latitude,
        'longitude': longitude,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Clock Out gagal: ${response.body}');
    }
  }

  /// Ambil data absensi hari ini
  Future<Map<String, dynamic>> fetchTodayAttendance({required int userId, required String token}) async {
    final now = DateTime.now();
    final todayStr = '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final url = Uri.parse('$baseUrl/attendance/summary-json/$userId/$todayStr/$todayStr');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['data'] as Map<String, dynamic>)[todayStr] ?? {};
    } else {
      throw Exception('Gagal mengambil data absensi');
    }
  }

  /// Ambil summary absensi rentang tanggal
  Future<Map<String, dynamic>> fetchAttendanceSummary({
    required int userId,
    required String token,
    required String startDate,
    required String endDate,
  }) async {
    final url = Uri.parse('$baseUrl/attendance/summary-json/$userId/$startDate/$endDate');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load attendance summary');
    }
  }
} 