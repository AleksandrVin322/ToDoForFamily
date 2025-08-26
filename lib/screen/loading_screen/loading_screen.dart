import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Row(
          children: [
            Text(
              'Загрузка...',
              style: TextStyle(fontSize: 40),
            ),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
