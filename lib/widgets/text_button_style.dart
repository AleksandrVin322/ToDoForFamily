import 'package:flutter/material.dart';

class TextButtonStyle extends StatelessWidget {
  final String text;
  final void Function()? function;
  const TextButtonStyle({
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
    return TextButton(
      style: buttonStyle,
      onPressed: function,
      child: Text(
        text,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}
