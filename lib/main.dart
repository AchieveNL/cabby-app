import 'package:cabby/config/routes.dart';
import 'package:cabby/config/theme.dart';
import 'package:cabby/services/api_service.dart';
import 'package:cabby/state/app_provider.dart';
import 'package:cabby/state/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ApiService.initializeCookieJar();
  runApp(const CabbyApp());
}

class CabbyApp extends StatelessWidget {
  const CabbyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => AppProvider()),
      ],
      child: MaterialApp(
        theme: themeData,
        initialRoute: '/',
        routes: routes,
      ),
    );
  }
}
