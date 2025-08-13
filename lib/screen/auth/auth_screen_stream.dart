import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../tasks_screen/models/model_task.dart';
import '../tasks_screen/tasks_body.dart';
import 'auth_model.dart';
import 'auth_screen.dart';
import 'welcome_screen.dart';

class AuthScreenStream extends StatefulWidget {
  const AuthScreenStream({super.key});

  @override
  State<AuthScreenStream> createState() => _AuthScreenStreamState();
}

class _AuthScreenStreamState extends State<AuthScreenStream> {
  final email = TextEditingController();
  final password = TextEditingController();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return ChangeNotifierProvider<AuthModel>(
              create: (BuildContext context) => AuthModel(),
              child: const AuthScreen(),
            );
          } else {
            if (user.displayName != null && user.displayName!.isNotEmpty) {
              return ChangeNotifierProvider<ModelTask>(
                create: (BuildContext context) => ModelTask(),
                child: TasksBody(user: user),
              );
            } else {
              return ChangeNotifierProvider<AuthModel>(
                create: (BuildContext context) => AuthModel(),
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

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<UserCredential> sighIn({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> createAccount({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
