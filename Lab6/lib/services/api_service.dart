import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/login_model.dart';
import '../models/user_model.dart';
import '../singleton/auth_singleton.dart';

class ApiService {
  // Tự động nhận diện: 10.0.2.2 cho Android Emulator, localhost cho Windows/Web
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:5000/api';
    if (Platform.isAndroid) return 'http://10.0.2.2:5000/api';
    return 'http://localhost:5000/api';
  }

  // ─── Headers ──────────────────────────────────────────────────────────
  static Map<String, String> get _jsonHeaders => {
        'Content-Type': 'application/json',
      };

  static Map<String, String> get _authHeaders => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AuthSingleton().token}',
      };

  // ─── AUTH ─────────────────────────────────────────────────────────────

  /// Đăng ký tài khoản mới
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String role,
    String? fullName,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/register'),
            headers: _jsonHeaders,
            body: jsonEncode({
              'email': email,
              'password': password,
              'role': role,
              'fullName': fullName ?? '',
            }),
          )
          .timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': data['message'] ?? 'Registered successfully.'};
      } else {
        final msg = data['message'] ?? 'Registration failed.';
        return {'success': false, 'message': msg};
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error: ${e.toString()}'};
    }
  }

  /// Đăng nhập → trả về LoginModel
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/login'),
            headers: _jsonHeaders,
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final loginModel = LoginModel.fromJson(data);
        return {'success': true, 'data': loginModel};
      } else if (response.statusCode == 401) {
        return {'success': false, 'message': 'Invalid email or password.'};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login failed.'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error: ${e.toString()}'};
    }
  }

  // ─── USERS (Admin only) ────────────────────────────────────────────────

  /// Lấy danh sách tất cả users
  static Future<Map<String, dynamic>> getAllUsers() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/user/all'),
            headers: _authHeaders,
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final List list = jsonDecode(response.body);
        final users = list.map((e) => UserModel.fromJson(e)).toList();
        return {'success': true, 'data': users};
      } else if (response.statusCode == 401) {
        return {'success': false, 'message': '401', 'unauthorized': true};
      } else if (response.statusCode == 403) {
        return {'success': false, 'message': 'Access denied. Admin only.'};
      } else {
        return {'success': false, 'message': 'Failed to load users.'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error: ${e.toString()}'};
    }
  }

  /// Xóa user theo ID
  static Future<Map<String, dynamic>> deleteUser(String userId) async {
    try {
      final response = await http
          .delete(
            Uri.parse('$baseUrl/user/$userId'),
            headers: _authHeaders,
          )
          .timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': data['message']};
      } else if (response.statusCode == 401) {
        return {'success': false, 'message': '401', 'unauthorized': true};
      } else if (response.statusCode == 400) {
        return {'success': false, 'message': data['message']};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Delete failed.'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error: ${e.toString()}'};
    }
  }

  /// Lấy thông tin user hiện tại
  static Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/user/me'),
            headers: _authHeaders,
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = UserModel.fromJson(data);
        return {'success': true, 'data': user};
      } else if (response.statusCode == 401) {
        return {'success': false, 'message': '401', 'unauthorized': true};
      } else {
        return {'success': false, 'message': 'Failed to load user info.'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error: ${e.toString()}'};
    }
  }
}
