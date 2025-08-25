import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repository/auth_service.dart';
import '../../domain/repository/firestore_service.dart';
import '../main_screen/main_screen.dart';
import 'bloc/auth_bloc_bloc.dart';
import 'login_page.dart';

class AuthStateStream extends StatelessWidget {
  const AuthStateStream({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthService(),
        ),
        RepositoryProvider(create: (context) => FirestoreService()),
      ],
      child: BlocProvider(
        create: (context) => AuthBloc(
            authService: context.read<AuthService>(),
            firestoreService: context.read<FirestoreService>()),
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is UnauthenticatedState) {
              return const LoginPage();
            } else if (state is AuthenticatedState) {
              return const MainScreen();
            } else {
              return const _LoadingWidget();
            }
          },
        ),
      ),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Загрузка...',
              style: TextStyle(fontSize: 50),
            ),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
