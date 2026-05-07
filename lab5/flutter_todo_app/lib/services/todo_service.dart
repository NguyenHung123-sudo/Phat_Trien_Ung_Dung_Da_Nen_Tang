import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/todo_model.dart';
import 'auth_service.dart';

/// TodoService xử lý toàn bộ CRUD Todo
/// Mỗi request đều gắn JWT token vào header Authorization
class TodoService {
  final AuthService _authService = AuthService();

  /// Tạo header với Bearer token cho mọi request cần xác thực
  Future<Map<String, String>> _authHeaders() async {
    final token = await _authService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // Gắn JWT vào header
    };
  }

  // ── GET ALL TODOS ─────────────────────────────────────
  /// Lấy danh sách todos của user hiện tại
  /// GET /api/todos
  Future<List<TodoModel>> getTodos() async {
    final response = await http
        .get(
          Uri.parse(ApiConfig.todos),
          headers: await _authHeaders(),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => TodoModel.fromJson(json)).toList();
    }
    throw Exception('Lỗi khi lấy danh sách todo: ${response.statusCode}');
  }

  // ── CREATE TODO ───────────────────────────────────────
  /// Tạo todo mới
  /// POST /api/todos
  Future<TodoModel> createTodo({
    required String title,
    String? description,
  }) async {
    final response = await http
        .post(
          Uri.parse(ApiConfig.todos),
          headers: await _authHeaders(),
          body: jsonEncode({'title': title, 'description': description}),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 201) {
      return TodoModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Lỗi khi tạo todo: ${response.statusCode}');
  }

  // ── UPDATE TODO ───────────────────────────────────────
  /// Cập nhật todo theo ID
  /// PUT /api/todos/{id}
  Future<TodoModel> updateTodo({
    required int id,
    required String title,
    String? description,
    required bool isCompleted,
  }) async {
    final response = await http
        .put(
          Uri.parse(ApiConfig.todoById(id)),
          headers: await _authHeaders(),
          body: jsonEncode({
            'title': title,
            'description': description,
            'isCompleted': isCompleted,
          }),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      return TodoModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Lỗi khi cập nhật todo: ${response.statusCode}');
  }

  // ── DELETE TODO ───────────────────────────────────────
  /// Xóa todo theo ID
  /// DELETE /api/todos/{id}
  Future<void> deleteTodo(int id) async {
    final response = await http
        .delete(
          Uri.parse(ApiConfig.todoById(id)),
          headers: await _authHeaders(),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Lỗi khi xóa todo: ${response.statusCode}');
    }
  }

  // ── TOGGLE COMPLETE ───────────────────────────────────
  /// Đảo trạng thái hoàn thành của todo
  Future<TodoModel> toggleComplete(TodoModel todo) async {
    return updateTodo(
      id: todo.id,
      title: todo.title,
      description: todo.description,
      isCompleted: !todo.isCompleted,
    );
  }
}
