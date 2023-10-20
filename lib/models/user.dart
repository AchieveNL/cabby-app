class UserModel {
  final String id;
  final String email;
  final UserStatus status;
  final UserRole role;
  // Add other necessary fields you need

  UserModel({
    required this.id,
    required this.email,
    required this.status,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      status: UserStatus.values[json['status']],
      role: UserRole.values[json['role']],
      // Initialize other fields
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'status': status.index,
      'role': role.index,
    };
  }
}

enum UserStatus {
  ACTIVE,
  PENDING,
  BLOCKED,
  REJECTED,
}

enum UserRole {
  ADMIN,
  USER,
}
