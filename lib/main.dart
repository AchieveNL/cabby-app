// ignore_for_file: use_build_context_synchronously

import 'package:cabby/config/config.dart';
import 'package:cabby/config/routes.dart';
import 'package:cabby/config/theme.dart';
import 'package:cabby/firebase_options.dart';
import 'package:cabby/services/api_service.dart';
import 'package:cabby/state/app_provider.dart';
import 'package:cabby/state/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ApiService.initializeCookieJar();
  await AppConfig.initialize();
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  initializeDateFormatting('nl_NL', null).then((_) => runApp(const CabbyApp()));
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
        navigatorKey: navigatorKey,
        theme: themeData,
        initialRoute: '/',
        routes: routes,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('nl', 'NL'), // Dutch
        ],
        locale: const Locale('nl', 'NL'), // Force app to Dutch
      ),
    );
  }
}
