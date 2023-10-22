import 'dart:io';
import 'package:cabby/config/config.dart';
import 'package:cabby/config/utils.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';

class UploadService {
  final Dio _dio;
  final CookieJar _cookieJar = CookieJar();

  UploadService()
      : _dio = Dio(BaseOptions(
          baseUrl: '${AppConfig.apiUrl}/files',
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        )) {
    _dio.interceptors.add(CookieManager(_cookieJar));
  }

  Future<String?> uploadFile(File file) async {
    try {
      String fileType = determineFileType(file.path);

      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path),
        'type': fileType, // Adding the file type to the request
      });

      final response = await _dio.post('/upload', data: formData);
      logger(response);

      if (response.statusCode == 201 && response.data != null) {
        return response.data['payload'];
      }
      return null;
    } catch (e) {
      logger("Error while uploading file: $e");
      return null;
    }
  }
}

String determineFileType(String filePath) {
  if (filePath.endsWith('.pdf')) {
    return 'PDF';
  } else if (filePath.endsWith('.png') ||
      filePath.endsWith('.jpg') ||
      filePath.endsWith('.jpeg')) {
    return 'IMAGE';
  } else {
    throw Exception('Unsupported file type');
  }
}
