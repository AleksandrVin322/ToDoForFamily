import 'package:flutter/material.dart';

class AuthTextStyle extends StatelessWidget {
  final String text;
  const AuthTextStyle({
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
