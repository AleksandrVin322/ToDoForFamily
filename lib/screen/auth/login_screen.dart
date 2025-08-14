import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/model_auth.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ModelAuth(),
      child: const SafeArea(
        child: Scaffold(
          body: DecoratedBox(
            decoration: BoxDecoration(
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
            child: BodyLoginScreen(),
          ),
        ),
      ),
    );
  }
}

class BodyLoginScreen extends StatelessWidget {
  const BodyLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const textFieldDecoration = InputDecoration(
      border: OutlineInputBorder(),
      filled: true,
      fillColor: Colors.white,
    );

    final ModelAuth model = context.watch<ModelAuth>();
    return Column(
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
                (model.errorText.isNotEmpty)
                    ? Text(
                        model.errorText,
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
                      model.loginAcc(
                        context: context,
                      );
                    },
                    child: const Text(
                      'Войти',
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class LoginTextStyle extends StatelessWidget {
  final String text;
  const LoginTextStyle({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 30,
        color: Colors.white,
      ),
    );
  }
}
