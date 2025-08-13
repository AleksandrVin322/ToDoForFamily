import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_model.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthModel model = context.watch<AuthModel>();
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0077B6), // Темно-голубой
              Color(0xFF00B4D8), // Бирюзовый
              Color(0xFF90E0EF), // Светло-бирюзовый
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
              const Text(
                'Придумай имя пользователя',
                style: TextStyle(fontSize: 30),
              ),
              Padding(
                padding: const EdgeInsetsGeometry.symmetric(horizontal: 50),
                child: TextField(
                  controller: model.name,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => model.saveUserName(context: context),
                icon: const Icon(Icons.save),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
