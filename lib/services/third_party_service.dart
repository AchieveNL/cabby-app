import 'package:cabby/config/config.dart';
import 'package:cabby/config/utils.dart';
import 'package:cabby/services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class ThirdPartyService {
  final Dio _dio;

  ThirdPartyService()
      : _dio = Dio(BaseOptions(
          baseUrl: '${AppConfig.apiUrl}/third-party',
          headers: {'Content-Type': 'application/json'},
        )) {
    _dio.interceptors.add(CookieManager(ApiService.sharedCookieJar));
  }

  Future<bool> verifyUserInfo() async {
    try {
      logger('Verifying user info...');

      final response = await _dio.get('/verify-user-info');
      logger('User info verification response: $response');

      return response.statusCode == 200;
    } catch (e) {
      logger('Error while creating permit: $e');
      return false;
    }
  }
}
