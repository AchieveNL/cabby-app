import 'package:cabby/config/config.dart';
import 'package:cabby/config/utils.dart';
import 'package:cabby/models/permit.dart';
import 'package:cabby/services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class PermitService {
  final Dio _dio;

  PermitService()
      : _dio = Dio(BaseOptions(
          baseUrl: '${AppConfig.apiUrl}/permit',
          headers: {'Content-Type': 'application/json'},
        )) {
    _dio.interceptors.add(CookieManager(ApiService.sharedCookieJar));
  }

  Future<bool> createPermit(PermitRequest dto) async {
    try {
      logger('Creating permit with data: $dto'); // Log here

      final response = await _dio.post('/', data: dto);
      logger('Permit creation response: ${response.toString()}'); // Log here

      return response.statusCode == 200;
    } catch (e) {
      logger('Error while creating permit: $e'); // Log here
      return false;
    }
  }

  Future<bool> updatePermit(String userId, PermitRequest dto) async {
    try {
      final response = await _dio.patch('/$userId', data: dto);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
