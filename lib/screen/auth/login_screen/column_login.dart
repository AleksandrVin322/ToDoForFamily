import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/text_button_style.dart';
import '../../../widgets/text_field_style.dart';
import '../../loading_screen/loading_screen.dart';
import '../auth_flow_screen/bloc/auth_flow_bloc.dart';
import 'bloc/column_login_bloc.dart';

class ColumnLogin extends StatefulWidget {
  const ColumnLogin({
    super.key,
  });

  @override
  State<ColumnLogin> createState() => _ColumnLoginState();
}

class _ColumnLoginState extends State<ColumnLogin> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ColumnLoginBloc, ColumnLoginState>(
      listener: (context, state) {
        if (state is ColumnLoginInitialState) {
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
      child: BlocBuilder<ColumnLoginBloc, ColumnLoginState>(
        builder: (context, state) {
          if (state is ColumnLoginInitialState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Вход в аккаунт',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 89, 91, 131),
                  ),
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
                const SizedBox(height: 20),
                IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextButtonStyle(
                        text: 'Войти',
                        function: (!state.isLoading)
                            ? () => context.read<ColumnLoginBloc>().add(
                                  LoginEvent(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  ),
                                )
                            : null,
                      ),
                      const SizedBox(height: 10),
                      TextButtonStyle(
                        text: 'Создать аккаунт',
                        function: (!state.isLoading)
                            ? () => context
                                .read<AuthFlowBloc>()
                                .add(AuthFlowSwitchRegisterColumnEvent())
                            : null,
                      ),
                      const SizedBox(height: 10),
                      TextButtonStyle(
                        text: 'Сбросить пароль',
                        function: (!state.isLoading)
                            ? () => _resetPassword(context)
                            : null,
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

void _resetPassword(BuildContext context) async {
  final emailController = TextEditingController();
  final bloc = context.read<ColumnLoginBloc>();
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Center(child: Text('Сброс пароля')),
      content: TextField(
        controller: emailController,
        decoration: const InputDecoration(
          hintText: 'Укажите почту для сброса',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                bloc.add(
                  ResetPasswordEvent(email: emailController.text),
                );
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.done),
            ),
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
            ),
          ],
        ),
      ],
    ),
  );
}
