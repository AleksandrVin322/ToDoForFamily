import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/text_button_style.dart';
import '../../widgets/text_field_style.dart';
import '../auth_flow_screen/bloc/auth_flow_bloc.dart';
import '../loading_screen/loading_screen.dart';
import 'bloc/column_register_bloc.dart';

class ColumnRegister extends StatefulWidget {
  const ColumnRegister({
    super.key,
  });

  @override
  State<ColumnRegister> createState() => _ColumnRegisterState();
}

class _ColumnRegisterState extends State<ColumnRegister> {
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _checkPasswordController = TextEditingController();

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _checkPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ColumnRegisterBloc, ColumnRegisterState>(
      listener: (context, state) {
        if (state is ColumnRegisterInitial) {
          if (state.errorMessage.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(state.errorMessage),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      },
      child: BlocBuilder<ColumnRegisterBloc, ColumnRegisterState>(
        builder: (context, state) {
          if (state is ColumnRegisterInitial) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Создание нового аккаунта',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 89, 91, 131),
                  ),
                ),
                const SizedBox(height: 10),
                TextFieldStyle(
                  hintText: 'Введите имя пользователя',
                  icon: const Icon(Icons.account_circle),
                  isPassword: false,
                  controller: _userNameController,
                ),
                const SizedBox(height: 10),
                TextFieldStyle(
                  hintText: 'Введите почту',
                  icon: const Icon(Icons.mail),
                  isPassword: false,
                  controller: _emailController,
                ),
                const SizedBox(height: 10),
                TextFieldStyle(
                  hintText: 'Введите пароль',
                  icon: const Icon(Icons.password),
                  isPassword: true,
                  controller: _passwordController,
                ),
                const SizedBox(height: 10),
                TextFieldStyle(
                  hintText: 'Повторите пароль',
                  icon: const Icon(Icons.password),
                  isPassword: true,
                  controller: _checkPasswordController,
                ),
                const SizedBox(height: 20),
                IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextButtonStyle(
                        text: 'Регистрация',
                        function: () => context.read<ColumnRegisterBloc>().add(
                              RegisterEvent(
                                userName: _userNameController.text,
                                email: _emailController.text,
                                password: _passwordController.text,
                                checkPassword: _checkPasswordController.text,
                              ),
                            ),
                      ),
                      const SizedBox(height: 10),
                      TextButtonStyle(
                        text: 'Есть аккаунт?',
                        function: () => context.read<AuthFlowBloc>().add(
                              AuthFlowSwitchLoginColumnEvent(),
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const LoadingScreen();
          }
        },
      ),
    );
  }
}
