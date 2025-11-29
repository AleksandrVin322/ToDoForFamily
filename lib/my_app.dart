import 'package:flutter/material.dart';

import 'screen/auth/auth_screen/auth_screen.dart';
import 'screen/family_screen/family_screen.dart';
import 'screen/food_product_screen/food_product_screen.dart';
import 'screen/options_screen/settings_screen.dart';
import 'screen/tasks_screen/tasks_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const AuthScreen(),
        '/Tasks': (context) => const TasksScreen(),
        '/options': (context) => const SettingsScreen(),
        '/family': (context) => const FamilyScreen(),
        '/products': (context) => const FoodProductScreen(),
      },
      initialRoute: '/',
    );
  }
}
