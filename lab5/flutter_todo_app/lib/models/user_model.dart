/// user_model.dart
/// Model ánh xạ với AuthResponseDto từ ASP.NET Core API
class UserModel {
  final int userId;
  final String username;
  final String email;
  final String token;
  final DateTime expiresAt;

  UserModel({
    required this.userId,
    required this.username,
    required this.email,
    required this.token,
    required this.expiresAt,
  });

  /// Tạo UserModel từ JSON response của API /api/auth/login
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      token: json['token'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'username': username,
        'email': email,
        'token': token,
        'expiresAt': expiresAt.toIso8601String(),
      };
}
