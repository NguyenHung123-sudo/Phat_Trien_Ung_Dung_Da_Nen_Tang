import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://69ddcc1a410caa3d47b9fdad.mockapi.io',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
    },
  ));

  // Lấy danh sách user từ API
  Future<List<dynamic>> getUsers() async {
    try {
      final response = await _dio.get('/login');
      return response.data as List<dynamic>;
    } on DioException catch (e) {
      throw Exception('Lỗi kết nối: ${e.message}');
    }
  }

  // Đăng nhập - kiểm tra username và password trong API
  Future<Map<String, dynamic>?> login(String username, String password) async {
    try {
      final response = await _dio.get('/login');
      final List<dynamic> users = response.data;

      // Tìm user khớp với email và password
      for (var user in users) {
        if (user['email'] == username && user['password'] == password) {
          return user;
        }
      }
      return null; // Không tìm thấy user
    } on DioException catch (e) {
      throw Exception('Lỗi kết nối API: ${e.message}');
    }
  }
}
