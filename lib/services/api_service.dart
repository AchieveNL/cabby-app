import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';

class ApiService {
  static late PersistCookieJar sharedCookieJar;

  static void initializeCookieJar() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    sharedCookieJar =
        PersistCookieJar(storage: FileStorage("$appDocPath/.cookies/"));
  }
}
