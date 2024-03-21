import 'package:cabby/config/config.dart';
import 'package:cabby/config/utils.dart';
import 'package:cabby/services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class PaymentService {
  final Dio _dio;

  PaymentService()
      : _dio = Dio(BaseOptions(
          baseUrl: '${AppConfig.apiUrl}/payment',
          headers: {'Content-Type': 'application/json'},
        )) {
    _dio.interceptors.add(CookieManager(ApiService.sharedCookieJar));
  }

  Future<String?> createRegistrationPayment() async {
    try {
      final response = await _dio.post('/registration');
      logger(response);
      if (response.statusCode == 201 && response.data != null) {
        return response.data['payload']['checkoutUrl']['checkoutUrl'];
      }
    } catch (e) {
      logger('Error creating registration payment: $e');
    }
    return null;
  }

  Future<String?> createOrderPaymentUrl(String orderId) async {
    try {
      final response = await _dio.post('/order/$orderId/checkout-url');
      logger(response);
      if (response.statusCode == 200 && response.data != null) {
        return response.data['payload']['checkoutUrl']['checkoutUrl'];
      }
    } catch (e) {
      logger('Error creating order payment: $e');
    }
    return null;
  }
}
