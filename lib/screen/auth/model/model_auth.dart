import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../domain/main_navigation.dart';
import '../../../domain/repository/auth_service.dart';

class ModelAuth extends ChangeNotifier {
  final _authService = AuthService();
  bool _absorbing = false;
  bool get absorbing => _absorbing;
  bool _isRegister = false;
  bool get isRegister => _isRegister;
  String _errorText = '';
  String get errorText => _errorText;

  final _email = TextEditingController();
  TextEditingController get email => _email;

  final _password = TextEditingController();
  TextEditingController get password => _password;

  final _name = TextEditingController();
  TextEditingController get name => _name;

  Future<void> register({
    BuildContext? context,
  }) async {
    _toggleAbsorbing();
    notifyListeners();
    try {
      await _authService.register(email: _email.text, password: _password.text);
      _toggleIsRegister();
      notifyListeners();
      await Future<dynamic>.delayed(const Duration(seconds: 2));
      if (context != null) {
        Navigator.of(context).pop();
        _absorbing = false;
      }
      _toggleIsRegister();
    } on FirebaseAuthException catch (error) {
      _toggleAbsorbing();
      _errorText = error.message ?? '';
      notifyListeners();
    } catch (error) {
      _toggleAbsorbing();

      _errorText = 'Unknown error';
      notifyListeners();
    }
  }

  Future<void> loginAcc({
    BuildContext? context,
  }) async {
    try {
      await _authService.login(email: _email.text, password: _password.text);
      if (context != null) {
        Navigator.of(context).pop();
      }
    } on FirebaseAuthException catch (error) {
      _errorText = error.message ?? '';
      notifyListeners();
    }
  }

  void saveUserName({BuildContext? context}) async {
    try {
      await _authService.saveUser(name: _name.text);
      if (context != null) {
        Navigator.of(context).pushNamed(NavigationRoutes.mainScreen);
      }
    } on FirebaseAuthException catch (_) {}
  }

  void _toggleAbsorbing() {
    _absorbing = !_absorbing;
  }

  void _toggleIsRegister() {
    _isRegister = !_isRegister;
  }

  void signOut() async {
    try {
      await _authService.signOut();
    } on FirebaseAuthException catch (_) {}
  }
}
