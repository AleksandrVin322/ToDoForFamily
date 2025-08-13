import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_model.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ChangeNotifierProvider(
          create: (BuildContext context) => AuthModel(),
          child: const DecoratedBox(
            decoration: BoxDecoration(
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
            child: BodyRegisterScreen(),
          ),
        ),
      ),
    );
  }
}

class BodyRegisterScreen extends StatelessWidget {
  const BodyRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const textFieldDecoration = InputDecoration(
      border: OutlineInputBorder(),
      filled: true,
      fillColor: Colors.white,
    );

    final AuthModel model = context.watch<AuthModel>();
    return AbsorbPointer(
      absorbing: model.absorbing,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: Navigator.of(context).pop,
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 40,
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsetsGeometry.symmetric(horizontal: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (model.registerDone.isNotEmpty)
                      ? Center(
                        child: Text(
                          model.registerDone,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 8, 104, 13),
                            fontSize: 50,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                      : const SizedBox.shrink(),
                  const LoginTextStyle(text: 'Почта'),
                  const SizedBox(height: 10),
                  TextField(
                    controller: model.email,
                    decoration: textFieldDecoration,
                  ),
                  const SizedBox(height: 10),
                  const LoginTextStyle(text: 'Пароль'),
                  const SizedBox(height: 10),
                  TextField(
                    controller: model.password,
                    decoration: textFieldDecoration,
                  ),
                  (model.textError.isNotEmpty)
                      ? Text(
                        model.textError,
                        style: const TextStyle(color: Colors.red, fontSize: 20),
                      )
                      : const SizedBox.shrink(),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 200,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.white.withAlpha(15),
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
                      ),
                      onPressed: () {
                        model.register(
                          email: model.email.text,
                          password: model.password.text,
                          context: context,
                        );
                      },
                      child: const Text(
                        'Регистрация',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginTextStyle extends StatelessWidget {
  final String text;
  const LoginTextStyle({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 30, color: Colors.white),
    );
  }
}
