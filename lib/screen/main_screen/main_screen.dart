import 'package:flutter/material.dart';

import '../../domain/repository/auth_service.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    const BoxDecoration styleBoxDecoration = BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xFF0077B6),
          Color.fromARGB(255, 255, 255, 255),
        ],
        stops: [
          0.0,
          1,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );

    return Scaffold(
      body: DecoratedBox(
        decoration: styleBoxDecoration,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Главное меню',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 100),
              _StyleTextButton(
                text: 'Задачи для меня',
                function: () => Navigator.of(context).pushNamed('/Tasks'),
              ),
              const SizedBox(height: 20),
              _StyleTextButton(
                text: 'Настройки профиля',
                function: () => Navigator.of(context).pushNamed('/options'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => auth.signOut(),
                child: const Text('Выйти'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StyleTextButton extends StatelessWidget {
  final String text;
  final Function()? function;
  const _StyleTextButton({
    required this.text,
    required this.function,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = TextButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: const Color(0xFF0077B6).withAlpha(150),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: const Color.fromARGB(
            255,
            0,
            0,
            0,
          ).withAlpha(50),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 12,
      ),
    );
    return SizedBox(
      width: 350,
      child: TextButton(
        style: buttonStyle,
        onPressed: function, // () => Navigator.of(context).pushNamed('/Tasks'),
        child: Text(
          text,
          style: const TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
