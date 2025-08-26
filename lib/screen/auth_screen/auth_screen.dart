import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repository/auth_service.dart';
import '../../domain/repository/firestore_service.dart';
import '../auth_flow_screen/auth_flow_screen.dart';
import '../auth_flow_screen/bloc/auth_flow_bloc.dart';
import '../loading_screen/loading_screen.dart';
import '../login_screen/bloc/column_login_bloc.dart';
import '../main_screen/main_screen.dart';
import '../register_screen/bloc/column_register_bloc.dart';
import 'bloc/auth_bloc.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            authService: context.read<AuthService>(),
          ),
        ),
        BlocProvider(
          create: (context) => AuthFlowBloc(),
        ),
        BlocProvider(
          create: (context) =>
              ColumnLoginBloc(authService: context.read<AuthService>()),
        ),
        BlocProvider(
          create: (context) => ColumnRegisterBloc(
            authService: context.read<AuthService>(),
            firestoreService: context.read<FirestoreService>(),
          ),
        ),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) => switch (state) {
          UnauthenticatedState() => const AuthFlowScreen(),
          AuthenticatedState() => const MainScreen(),
          _ => const LoadingScreen(),
        },
      ),
    );
  }
}
