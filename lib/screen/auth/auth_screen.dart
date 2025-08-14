import 'package:flutter/material.dart';

import '../../domain/main_navigation.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0077B6),
              Color(0xFF00B4D8),
              Color(0xFF90E0EF),
            ],
            stops: [0.0, 0.5, 1.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Buttons(
                text: 'Войти',
                func: () => Navigator.of(context)
                    .pushNamed(NavigationRoutes.loginScreen),
              ),
              const SizedBox(height: 10),
              _Buttons(
                text: 'Регистрация',
                func: () => Navigator.of(
                  context,
                ).pushNamed(NavigationRoutes.registerScreen),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Buttons extends StatelessWidget {
  final String text;
  final void Function()? func;
  const _Buttons({
    required this.text,
    required this.func,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      child: TextButton(
        onPressed: func,
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.white.withAlpha(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: const Color.fromARGB(255, 0, 0, 0).withAlpha(50),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 50),
        ),
      ),
    );
  }
}
