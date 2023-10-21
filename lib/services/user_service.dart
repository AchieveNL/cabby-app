

import 'package:cabby/config/config.dart';
import 'package:cabby/models/user.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class UserService {
  final Dio _dio;
  final CookieJar _cookieJar = CookieJar();

  UserService()
      : _dio = Dio(BaseOptions(
          baseUrl: '${AppConfig.apiUrl}/users',
          headers: {'Content-Type': 'application/json'},
        )) {
    _dio.interceptors.add(CookieManager(_cookieJar));
  }

  Future<Map<String, dynamic>> _processResponse(Response response) async {
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed with status: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> signup(String email, String password) async {
    final response = await _dio.post(
      '/signup',
      data: {'email': email, 'password': password},
    );
    return _processResponse(response);
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _dio.post(
      '/mobile-login',
      data: {'email': email, 'password': password},
    );
    if (response.statusCode == 200) {
      return {
        'status': 'success',
        'user': UserModel.fromJson(response.data['payload']),
      };
    } else {
      return {
        'status': 'error',
        'message': response.data['message'],
      };
    }
  }

  Future<Map<String, dynamic>> verifyOtp(String email, String otp) async {
    final response = await _dio.post(
      '/verify-otp',
      data: {'email': email, 'otp': otp},
    );
    return _processResponse(response);
  }

  Future<Map<String, dynamic>> resetPassword(
      String email, String newPassword) async {
    final response = await _dio.post(
      '/reset-password',
      data: {'email': email, 'newPassword': newPassword},
    );
    return _processResponse(response);
  }

  Future<Map<String, dynamic>> deleteUser() async {
    final response = await _dio.delete('/delete-account');
    return _processResponse(response);
  }

  Future<Map<String, dynamic>> fetchCurrentUser() async {
    final response = await _dio.get('/current');
    return _processResponse(response);
  }

  Future<Map<String, dynamic>> fetchUserById(String id) async {
    final response = await _dio.get('/$id');
    return _processResponse(response);
  }
}
