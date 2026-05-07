/// api_config.dart
/// Tập trung tất cả URL và endpoints của API vào một nơi
/// Khi thay đổi IP/port chỉ cần sửa ở đây
class ApiConfig {
  // ─────────────────────────────────────────────────────────────
  // HƯỚNG DẪN CẤU HÌNH:
  //   • Android Emulator  → dùng 10.0.2.2  (emulator trỏ vào localhost máy host)
  //   • Thiết bị thật     → dùng IP WiFi máy tính, vd: 192.168.1.100
  //   • Web / Desktop     → dùng localhost
  // ─────────────────────────────────────────────────────────────
  // static const String _baseHost = '10.0.2.2'; // Android emulator
  static const String _baseHost = 'localhost';       // Web / Desktop
  // static const String _baseHost = '192.168.x.x';    // Thiết bị thật (thay IP thật)

  static const int    _port   = 5001;   // HTTP port của ASP.NET Core (launchSettings.json)
  static const String _scheme = 'http'; // Dùng HTTP để tránh lỗi SSL trên emulator

  static String get baseUrl => '$_scheme://$_baseHost:$_port';

  // ── Auth Endpoints ──
  static String get register => '$baseUrl/api/auth/register';
  static String get login    => '$baseUrl/api/auth/login';

  // ── Todo Endpoints ──
  static String get todos        => '$baseUrl/api/todos';
  static String todoById(int id) => '$baseUrl/api/todos/$id';
}
