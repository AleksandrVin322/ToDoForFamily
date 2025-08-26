import 'package:flutter/material.dart';

class TextFieldStyle extends StatelessWidget {
  final String hintText;
  final Icon icon;
  final bool isPassword;
  final TextEditingController controller;
  const TextFieldStyle({
    required this.icon,
    required this.hintText,
    required this.isPassword,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          enabledBorder: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(),
          prefixIcon: icon,
        ),
      ),
    );
  }
}
