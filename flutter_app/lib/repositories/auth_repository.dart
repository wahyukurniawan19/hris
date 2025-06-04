import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

class AuthRepository {
  Future<Map<String, dynamic>> login({required String email, required String password}) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Login gagal. Cek email dan password.');
    }
  }
} 