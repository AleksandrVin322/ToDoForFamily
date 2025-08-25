import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/auth_bloc_bloc.dart';
import 'widgets/style/style_email_text_field.dart';
import 'widgets/style/style_text_button.dart';

part 'widgets/column_login.dart';
part 'widgets/column_register.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    const BoxDecoration styleBoxDecoration = BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xFF0077B6),
          Color.fromARGB(255, 255, 255, 255),
        ],
        stops: [
          0.0,
          1,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );

    return Scaffold(
      body: DecoratedBox(
        decoration: styleBoxDecoration,
        child: Center(
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is UnauthenticatedState) {
                return state.isLogin
                    ? const _ColumnLogin()
                    : const _ColumnRegister();
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }
}
