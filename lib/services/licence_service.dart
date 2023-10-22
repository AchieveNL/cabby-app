import 'package:cabby/config/config.dart';
import 'package:cabby/config/utils.dart';
import 'package:cabby/models/licence.dart';
import 'package:cabby/services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class LicenceService {
  final Dio _dio;

  LicenceService()
      : _dio = Dio(BaseOptions(
          baseUrl: '${AppConfig.apiUrl}/licence',
          headers: {'Content-Type': 'application/json'},
        )) {
    _dio.interceptors.add(CookieManager(ApiService.sharedCookieJar));
  }

  Future<bool> createDriverLicense(DriverLicenseRequest dto) async {
    try {
      logger('Creating driver license with data: $dto'); // Log here

      final response = await _dio.post('/', data: dto);
      logger(
          'Driver license creation response: ${response.toString()}'); // Log here

      return response.statusCode == 200;
    } catch (e) {
      logger('Error while creating driver license: $e'); // Log here
      return false;
    }
  }

  Future<bool> updateDriverLicense(String id, DriverLicenseRequest dto) async {
    try {
      final response = await _dio.patch('/$id', data: dto);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
