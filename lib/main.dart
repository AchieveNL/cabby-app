import 'package:cabby/config/routes.dart';
import 'package:cabby/state/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const CabbyApp());
}

class CabbyApp extends StatelessWidget {
  const CabbyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
        initialRoute: '/',
        routes: routes,
      ),
    );
  }
}
