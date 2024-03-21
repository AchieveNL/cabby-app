import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppConfig {
  static late final String _currentEnvironment;
  static late final String _baseUrl;
  static late final String _apiUrl;
  static late final String _rentalAgreementUrl;
  static late final String _supabaseUrl;
  static late final String _supabaseAnonKey;
  static late final bool _isProduction;

  static Future<void> initialize() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (kDebugMode || packageInfo.buildSignature.contains("staging")) {
      await dotenv.load(fileName: ".env");
      _currentEnvironment = 'staging';
    } else {
      _currentEnvironment = 'production';
      await dotenv.load(fileName: ".env.prod");
    }

    Map<String, String> _baseUrls = {
      'staging': dotenv.env['_baseUrl']!,
      'production': dotenv.env['_baseUrl']!,
    };

    _baseUrl = _baseUrls[_currentEnvironment]!;
    _apiUrl = '$_baseUrl/api/v1/$_currentEnvironment';
    _rentalAgreementUrl = '$_baseUrl/assets/cabby_huurovereenkomst.pdf';
    _isProduction = _currentEnvironment == 'production';
    _supabaseUrl = dotenv.env['_supabaseUrl']!;
    _supabaseAnonKey = dotenv.env['_supabaseAnonKey']!;
  }

  static String get currentEnvironment => _currentEnvironment;
  static String get baseUrl => _baseUrl;
  static String get apiUrl => _apiUrl;
  static String get rentalAgreementUrl => _rentalAgreementUrl;
  static bool get isProduction => _isProduction;
  static String get supabaseUrl => _supabaseUrl;
  static String get supabaseAnonKey => _supabaseAnonKey;
}

Future<String> getBundleIdentifier() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.packageName;
}
