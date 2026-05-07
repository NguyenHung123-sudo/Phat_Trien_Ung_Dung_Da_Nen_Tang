import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../config/api_config.dart';
import '../models/user_model.dart';

/// AuthService xử lý:
/// - Gọi API Register / Login
/// - Lưu / đọc / xóa JWT token từ SharedPreferences
/// - Kiểm tra trạng thái đăng nhập
class AuthService {
  static const String _tokenKey = 'jwt_token';
  static const String _userKey  = 'user_data';

  // ── REGISTER ──────────────────────────────────────────
  /// Đăng ký tài khoản mới
  /// Trả về null nếu thành công, hoặc message lỗi
  Future<String?> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiConfig.register),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'username': username,
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 15));

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return null; // Thành công
      }
      return body['message'] ?? body['title'] ?? 'Đăng ký thất bại';
    } catch (e) {
      return 'Không thể kết nối đến server. Kiểm tra lại kết nối mạng.';
    }
  }

  // ── LOGIN ─────────────────────────────────────────────
  /// Đăng nhập và lưu JWT token vào SharedPreferences
  /// Trả về null nếu thành công, hoặc message lỗi
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiConfig.login),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 15));

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Lưu token và thông tin user vào SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_tokenKey, body['token']);
        await prefs.setString(_userKey, jsonEncode(body));
        return null; // Thành công
      }
      return body['message'] ?? 'Email hoặc mật khẩu không đúng';
    } catch (e) {
      return 'Không thể kết nối đến server. Kiểm tra lại kết nối mạng.';
    }
  }

  // ── LOGOUT ────────────────────────────────────────────
  /// Xóa token khỏi SharedPreferences
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  // ── GET TOKEN ─────────────────────────────────────────
  /// Lấy JWT token đang lưu
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // ── GET CURRENT USER ──────────────────────────────────
  /// Lấy thông tin user hiện tại từ SharedPreferences
  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson == null) return null;
    return UserModel.fromJson(jsonDecode(userJson));
  }

  // ── IS LOGGED IN ──────────────────────────────────────
  /// Kiểm tra user đã đăng nhập và token còn hạn không
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    if (token == null) return false;
    // JwtDecoder.isExpired kiểm tra exp claim trong token
    return !JwtDecoder.isExpired(token);
  }
}
