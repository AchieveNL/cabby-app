import 'dart:convert';

import 'package:cabby/config/config.dart';
import 'package:cabby/config/utils.dart';
import 'package:cabby/models/order.dart';
import 'package:cabby/services/api_service.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class OrdersService {
  final Dio _dio;
  final CookieJar _cookieJar = ApiService.sharedCookieJar;

  OrdersService()
      : _dio = Dio(BaseOptions(
          baseUrl: '${AppConfig.apiUrl}/orders',
          headers: {'Content-Type': 'application/json'},
        )) {
    _dio.interceptors.add(CookieManager(_cookieJar));
  }

  Future<VehicleAvailability> fetchVehicleAvailability(String vehicleId) async {
    try {
      Response response = await _dio.get('/vehicle/$vehicleId/availability');
      if (response.statusCode == 200) {
        logger("fetchVehicleAvailability: ${response.data}");
        return VehicleAvailability.fromJson(response.data['payload']);
      } else {
        throw Exception('Failed to fetch vehicle availability');
      }
    } catch (error) {
      logger(error);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> checkVehicleAvailabilityForTimeslot(
      String vehicleId, DateTime start, DateTime end) async {
    try {
      Response response = await _dio.get(
        '/vehicle/$vehicleId/check-availability',
        queryParameters: {
          'rentStarts': start.toIso8601String(),
          'rentEnds': end.toIso8601String(),
        },
      );
      if (response.statusCode == 200) {
        return response.data["payload"];
      } else {
        throw Exception('Failed to check vehicle availability for timeslot');
      }
    } catch (error) {
      logger(error);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createOrder({
    required String vehicleId,
    required DateTime rentalStartDate,
    required DateTime rentalEndDate,
  }) async {
    String toIso8601WithoutMilliseconds(DateTime dateTime) {
      return "${dateTime.toUtc().toIso8601String().split('.')[0]}Z";
    }

    logger(jsonEncode({
      'vehicleId': vehicleId,
      'rentalStartDate': toIso8601WithoutMilliseconds(rentalStartDate),
      'rentalEndDate': toIso8601WithoutMilliseconds(rentalEndDate),
    }));

    try {
      final response = await _dio.post(
        '/create',
        data: {
          'vehicleId': vehicleId,
          'rentalStartDate': toIso8601WithoutMilliseconds(rentalStartDate),
          'rentalEndDate': toIso8601WithoutMilliseconds(rentalEndDate),
        },
      );

      logger("createOrder: ${response.data}");

      if (response.statusCode == 201) {
        if (response.data["payload"]['error'] != null) {
          logger("createOrder: ${response.data["payload"]['error']}");
          return {
            'error': response.data["payload"]['error'],
          };
        }
        return {
          'order': response.data["payload"]['order'],
          'checkoutUrl': response.data["payload"]['checkoutUrl'],
        };
      } else {
        throw Exception('Failed to create order');
      }
    } catch (error) {
      logger(error);
      rethrow;
    }
  }

  Future<List<OrderOverview>> fetchUserOrdersByStatus(String? status) async {
    try {
      Response response = await _dio.get(
        '/user-orders',
        queryParameters: status != null
            ? {
                'status': status.toUpperCase(),
              }
            : null,
      );

      if (response.statusCode == 200) {
        List<OrderOverview> orders = (response.data["payload"] as List)
            .map((order) => OrderOverview.fromJson(order))
            .toList();
        return orders;
      } else {
        throw Exception('Failed to fetch user orders by status');
      }
    } catch (error) {
      logger(error);
      rethrow;
    }
  }

  Future<OrderDetails> fetchOrderDetails(String orderId) async {
    try {
      Response response = await _dio.get('/$orderId/details');
      if (response.statusCode == 200) {
        return OrderDetails.fromJson(response.data['payload']);
      } else {
        throw Exception('Failed to fetch order details');
      }
    } catch (error) {
      logger(error);
      rethrow;
    }
  }

  Future<bool> cancelOrder(String orderId) async {
    try {
      Response response = await _dio.post('/cancel', data: {
        'orderId': orderId,
      });
      logger(response);
      return true;
    } catch (error) {
      logger(error);
      rethrow;
    }
  }

  Future<bool> completeOrder(String orderId) async {
    try {
      Response response = await _dio.patch('/orders/$orderId/complete');

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to complete order');
      }
    } catch (error) {
      logger(error);
      rethrow;
    }
  }

  Future<bool> unlockVehicleOrder(String orderId) async {
    try {
      logger("unlockVehicleOrder");
      Response response = await _dio.post('/order/$orderId/unlockVehicle');
      logger(response);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to unlockVehicle order');
      }
    } catch (error) {
      logger(error);
      rethrow;
    }
  }

  Future<bool> lockVehicleOrder(String orderId) async {
    logger("unlockVehicleOrder");
    try {
      Response response = await _dio.post('/order/$orderId/lockVehicle');
      logger("lockVehicleOrder");
      logger(response);
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to unlockVehicle order');
      }
    } catch (error) {
      logger(error);
      rethrow;
    }
  }
}
