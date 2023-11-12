import 'package:cabby/config/config.dart';
import 'package:cabby/config/utils.dart';
import 'package:cabby/models/vehicle.dart';
import 'package:cabby/services/api_service.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class VehicleService {
  final Dio _dio;
  final CookieJar _cookieJar = ApiService.sharedCookieJar;

  VehicleService()
      : _dio = Dio(BaseOptions(
          baseUrl: '${AppConfig.apiUrl}/vehicles',
          headers: {'Content-Type': 'application/json'},
        )) {
    _dio.interceptors.add(CookieManager(_cookieJar));
  }

  Future<List<Vehicle>> getPopularVehicles() async {
    try {
      final response = await _dio.get('/');
      if (response.statusCode == 200) {
        final List<dynamic> payload = response.data['payload'];
        return payload.map((json) => Vehicle.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load vehicles.');
      }
    } catch (error) {
      logger(error.toString());
      throw Exception('Failed to load vehicles.');
    }
  }

  Future<List<AvailableVehicleModels>> getAvailableVehicles() async {
    try {
      final response = await _dio.get('/available-models');
      if (response.statusCode == 200) {
        final List<dynamic> payload = response.data['payload'];
        return payload
            .map((json) => AvailableVehicleModels.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load available vehicles.');
      }
    } catch (error) {
      logger(error.toString());
      throw Exception('Failed to load available vehicles.');
    }
  }
}
