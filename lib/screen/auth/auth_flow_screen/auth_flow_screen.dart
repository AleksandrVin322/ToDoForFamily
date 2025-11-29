import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../login_screen/column_login.dart';
import '../register_screen/column_register.dart';
import 'bloc/auth_flow_bloc.dart';

class AuthFlowScreen extends StatelessWidget {
  const AuthFlowScreen({super.key});

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
        child: SafeArea(
          child: Center(
            child: BlocBuilder<AuthFlowBloc, AuthFlowState>(
              builder: (context, state) => switch (state) {
                AuthFlowLoginState() => const ColumnLogin(),
                AuthFlowRegisterState() => const ColumnRegister(),
                _ => const CircularProgressIndicator(),
              },
            ),
          ),
        ),
      ),
    );
  }
}
