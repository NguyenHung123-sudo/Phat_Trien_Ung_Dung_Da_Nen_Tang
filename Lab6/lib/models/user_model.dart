class UserModel {
  final String id;
  final String email;
  final String? fullName;
  final String role;
  final String? createdAt;

  UserModel({
    required this.id,
    required this.email,
    this.fullName,
    required this.role,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'],
      role: json['role'] ?? 'N/A',
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'role': role,
      'createdAt': createdAt,
    };
  }
}
