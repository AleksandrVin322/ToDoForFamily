import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../tasks_screen/models/model_task.dart';
import '../tasks_screen/tasks_body.dart';
import 'auth_screen.dart';
import 'model/model_auth.dart';
import 'welcome_screen.dart';

class AuthStateStream extends StatefulWidget {
  const AuthStateStream({super.key});

  @override
  State<AuthStateStream> createState() => _AuthStateStreamState();
}

class _AuthStateStreamState extends State<AuthStateStream> {
  final Stream<User?> authStateChanges =
      FirebaseAuth.instance.authStateChanges();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            return ChangeNotifierProvider<ModelAuth>(
              create: (BuildContext context) => ModelAuth(),
              child: const AuthScreen(),
            );
          } else {
            if (user.displayName != null && user.displayName!.isNotEmpty) {
              return ChangeNotifierProvider<ModelTask>(
                create: (BuildContext context) => ModelTask(),
                child: TasksBody(user: user),
              );
            } else {
              return ChangeNotifierProvider<ModelAuth>(
                create: (BuildContext context) => ModelAuth(),
                child: const WelcomeScreen(),
              );
            }
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
