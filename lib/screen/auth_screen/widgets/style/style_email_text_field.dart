import 'package:flutter/material.dart';

class StyleTextField extends StatelessWidget {
  final String hintText;
  final Icon icon;
  final bool isPassword;
  final TextEditingController controller;
  const StyleTextField({
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
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          enabledBorder: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(),
          prefixIcon: icon,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Поле не может быть пустым';
          }
          if (value.length < 10) {
            return 'Пароль должен быть больше 10 символов';
          }
          return null;
        },
      ),
    );
  }
}
