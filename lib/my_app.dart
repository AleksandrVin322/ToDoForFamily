import 'package:flutter/material.dart';

import 'screen/auth/auth_state_stream.dart';
import 'screen/tasks_screen/tasks_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const AuthStateStream(),
        '/Tasks': (context) => const TasksScreen(),
      },
      initialRoute: '/',
    );
  }
}
