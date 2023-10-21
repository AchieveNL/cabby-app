import 'dart:io';

import 'package:cabby/config/config.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class ProfileService {
  final Dio _dio;
  final CookieJar _cookieJar = CookieJar();

  ProfileService()
      : _dio = Dio(BaseOptions(
          baseUrl: '${AppConfig.apiUrl}/profile',
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

  Future<Map<String, dynamic>> createRentalAgreement(File signature) async {
    final formData = FormData.fromMap({
      'signature': await MultipartFile.fromFile(signature.path,
          filename: signature.path.split('/').last),
    });

    final response = await _dio.post('/rental-agreement', data: formData);
    return _processResponse(response);
  }
}
