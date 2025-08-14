import 'package:flutter/material.dart';

import '../screen/auth/auth_screen.dart';
import '../screen/auth/auth_state_stream.dart';
import '../screen/auth/login_screen.dart';
import '../screen/auth/register_screen.dart';

abstract class NavigationRoutes {
  static const mainScreen = '/';
  static const authScreen = '/auth_screen';
  static const loginScreen = '/auth_screen/login';
  static const registerScreen = '/auth_screen/register';
}

class MainNavigation {
  final routes = <String, Widget Function(BuildContext)>{
    NavigationRoutes.mainScreen: (context) => const AuthStateStream(),
    NavigationRoutes.authScreen: (context) => const AuthScreen(),
    NavigationRoutes.loginScreen: (context) => const LoginScreen(),
    NavigationRoutes.registerScreen: (context) => const RegisterScreen(),
  };
}
