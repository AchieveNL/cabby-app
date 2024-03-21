// ignore_for_file: constant_identifier_names

import 'package:cabby/config/utils.dart';

class UserModel {
  final String id;
  final String email;
  final UserStatus status;
  final UserRole role;

  UserModel({
    required this.id,
    required this.email,
    required this.status,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    logger("JSON: $json");
    logger("Status: ${json['status']}");
    logger("Role: ${json['role']}");

    return UserModel(
      id: json['id'],
      email: json['email'],
      status: _statusFromString(json['status']),
      role: _roleFromString(json['role']),
    );
  }

  factory UserModel.fromJsonWithInt(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      status: UserStatus.values[json['status']],
      role: UserRole.values[json['role']],
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

  static UserStatus _statusFromString(String status) {
    for (UserStatus value in UserStatus.values) {
      if (value.toString().split('.').last == status) {
        return value;
      }
    }
    throw Exception('Unknown status value: $status');
  }

  static UserRole _roleFromString(String role) {
    for (UserRole value in UserRole.values) {
      if (value.toString().split('.').last == role) {
        return value;
      }
    }
    throw Exception('Unknown role value: $role');
  }
}

enum UserStatus {
  APPROVED,
  ACTIVE,
  PENDING,
  BLOCKED,
  REJECTED,
  REQUIRE_REGISTRATION_FEE,
}

enum UserRole {
  ADMIN,
  USER,
}
