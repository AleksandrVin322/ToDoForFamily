import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthModel extends ChangeNotifier {
  bool login = true;
  String textError = '';
  String registerDone = '';
  bool absorbing = false;

  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();

  void toggleLoginButton() {
    login = !login;
    notifyListeners();
  }

  Future<void> register({
    required String email,
    required String password,
    BuildContext? context,
  }) async {
    absorbing = true;
    notifyListeners();
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user?.sendEmailVerification();
      await FirebaseAuth.instance.signOut();
      registerDone = 'Регистрация прошла успешно';
      notifyListeners();
      await Future.delayed(Duration(seconds: 2));
      if (context != null) {
        Navigator.of(context).pop();
        absorbing = false;
      }
    } on FirebaseAuthException catch (error) {
      absorbing = false;
      textError = error.message ?? '';
      notifyListeners();
    }
  }

  Future<void> loginAcc({
    required String email,
    required String password,
    BuildContext? context,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (context != null) {
        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (error) {
      textError = error.message ?? '';
      notifyListeners();
    }
  }

  void saveUserName({BuildContext? context}) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updateDisplayName(name.text);
        await user.reload();
        if (context != null) {
          Navigator.of(context).pushNamed('/');
        }
      }
    } on FirebaseAuthException catch (e) {}
  }
}
