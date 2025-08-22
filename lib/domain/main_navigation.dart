import 'package:flutter/material.dart';

abstract class NavigationRoutes {
  static const mainScreen = '/';
  static const authScreen = '/auth_screen';
  static const loginScreen = '/auth_screen/login';
  static const registerScreen = '/auth_screen/register';
}

class MainNavigation {
  final routes = <String, Widget Function(BuildContext)>{};
}
