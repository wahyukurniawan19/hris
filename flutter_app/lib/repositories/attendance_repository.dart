import 'dart:convert';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import '../services/attendance_service.dart';

class AttendanceRepository {
  final AttendanceService _service = AttendanceService();

  /// Ambil lokasi saat ini
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location service is disabled.');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission permanently denied.');
    }
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  /// Ambil foto dari kamera
  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  /// Submit clock-in (delegasi ke service)
  Future<Map<String, dynamic>> submitClockIn({
    required String token,
    required int userId,
    required String? note,
    required File? imageFile,
    required double latitude,
    required double longitude,
  }) async {
    return _service.submitClockIn(
      token: token,
      userId: userId,
      note: note,
      imageFile: imageFile,
      latitude: latitude,
      longitude: longitude,
    );
  }

  /// Submit clock-out (delegasi ke service)
  Future<Map<String, dynamic>> submitClockOut({
    required String token,
    required int userId,
    required String? note,
    required File? imageFile,
    required double latitude,
    required double longitude,
  }) async {
    return _service.submitClockOut(
      token: token,
      userId: userId,
      note: note,
      imageFile: imageFile,
      latitude: latitude,
      longitude: longitude,
    );
  }

  /// Ambil absensi hari ini (delegasi ke service)
  Future<Map<String, dynamic>> fetchTodayAttendance({required int userId, required String token}) async {
    return _service.fetchTodayAttendance(userId: userId, token: token);
  }

  /// Ambil summary absensi (delegasi ke service)
  Future<Map<String, dynamic>> fetchAttendanceSummary({
    required int userId,
    required String token,
    required String startDate,
    required String endDate,
  }) async {
    return _service.fetchAttendanceSummary(
      userId: userId,
      token: token,
      startDate: startDate,
      endDate: endDate,
    );
  }
} 