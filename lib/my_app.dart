import 'package:flutter/material.dart';

import 'domain/main_navigation.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: MainNavigation().routes,
      initialRoute: NavigationRoutes.mainScreen,
    );
  }
}
