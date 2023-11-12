import 'dart:io';

import 'package:cabby/config/config.dart';
import 'package:cabby/config/utils.dart';
import 'package:cabby/models/damage_report.dart';
import 'package:cabby/services/api_service.dart';
import 'package:cabby/services/upload_service.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class DamageReportService {
  final Dio _dio;
  final CookieJar _cookieJar = ApiService.sharedCookieJar;

  DamageReportService()
      : _dio = Dio(BaseOptions(
          baseUrl: '${AppConfig.apiUrl}/damage-reports',
          headers: {'Content-Type': 'application/json'},
        )) {
    _dio.interceptors.add(CookieManager(_cookieJar));
  }

  Future<bool> sendDamageReport(
      String description, String vehicleId, List<File> imageFiles) async {
    try {
      List<String> imageUrls = [];
      for (var imageFile in imageFiles) {
        String? imageUrl = await UploadService().uploadFile(imageFile);
        if (imageUrl != null) {
          imageUrls.add(imageUrl);
        }
      }

      final response = await _dio.post(
        '/',
        data: {
          'description': description,
          'vehicleId': vehicleId,
          'images': imageUrls,
        },
      );

      logger(response);

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<List<DamageReport>> fetchDamageReports(String vehicleId) async {
    try {
      final response = await _dio.get('/vehicle/$vehicleId');
      logger(response);
      if (response.statusCode == 200) {
        List<dynamic> reportList = response.data['payload'];
        return reportList.map((json) => DamageReport.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load damage reports');
      }
    } catch (e) {
      throw Exception('Failed to load damage reports: $e');
    }
  }
}
