// Singleton giữ JWT token cho toàn bộ app session
class AuthSingleton {
  static final AuthSingleton _instance = AuthSingleton._internal();
  factory AuthSingleton() => _instance;
  AuthSingleton._internal();

  String? token;
  String? role;
  String? email;
  String? userId;
  String? fullName;

  void clear() {
    token = null;
    role = null;
    email = null;
    userId = null;
    fullName = null;
  }

  bool get isLoggedIn => token != null;
}
