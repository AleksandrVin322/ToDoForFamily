import 'package:flutter/material.dart';

import 'screen/auth/auth_screen.dart';
import 'screen/auth/auth_screen_stream.dart';
import 'screen/auth/login_screen.dart';
import 'screen/auth/register_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const AuthScreenStream(),
        '/auth_screen': (context) => const AuthScreen(),
        '/auth_screen/login': (context) => const LoginScreen(),
        '/auth_screen/register': (context) => const RegisterScreen(),
      },
      initialRoute: '/',
    );
  }
}
