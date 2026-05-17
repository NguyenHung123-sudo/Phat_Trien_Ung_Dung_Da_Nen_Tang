class LoginModel {
  final String token;
  final String email;
  final String role;
  final String userId;
  final String? fullName;

  LoginModel({
    required this.token,
    required this.email,
    required this.role,
    required this.userId,
    this.fullName,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      token: json['token'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      userId: json['userId'] ?? '',
      fullName: json['fullName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'email': email,
      'role': role,
      'userId': userId,
      'fullName': fullName,
    };
  }
}
