import 'dart:io';

import 'package:cabby/config/config.dart';
import 'package:cabby/config/utils.dart';
import 'package:cabby/models/profile.dart';
import 'package:cabby/services/api_service.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class ProfileService {
  final Dio _dio;
  final CookieJar _cookieJar = ApiService.sharedCookieJar;

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
    logger(response);
    return _processResponse(response);
  }

  Future<Map<String, dynamic>> createUserProfile(UserProfile profile) async {
    final response = await _dio.post('/create', data: profile);
    return response.data;
  }

  Future<Map<String, dynamic>> editUserProfile(
      String id, EditUserProfile profile) async {
    final response =
        await _dio.patch('/edit', data: profile, queryParameters: {'id': id});
    return _processResponse(response);
  }

  Future<Map<String, dynamic>> updateExpiryDate(UpdateExpiryDate dates) async {
    final response = await _dio.patch('/update-expiry', data: dates);
    return _processResponse(response);
  }

  Future<UserProfileModel> getCurrentProfile() async {
    try {
      // Log the request headers
      logger('Request headers: ${_dio.options.headers}');

      // Await the result of loadForRequest to get the cookies
      List<Cookie> cookies = await _cookieJar
          .loadForRequest(Uri.parse('${AppConfig.apiUrl}/profile/current'));
      logger('Cookies being sent: $cookies');

      final response = await _dio.get('/current');

      // Log the response details
      logger(
          'Received response for current profile: Status: ${response.statusCode}, Data: ${response.data}, Headers: ${response.headers}');

      if (response.data != null && response.statusCode == 200) {
        return UserProfileModel.fromJson(response.data['payload']);
      } else {
        throw Exception(
            'Failed to load user profile with status code: ${response.statusCode}');
      }
    } catch (e) {
      // Log exceptions
      logger('Error in getCurrentProfile: $e');
      rethrow;
    }
  }
}
