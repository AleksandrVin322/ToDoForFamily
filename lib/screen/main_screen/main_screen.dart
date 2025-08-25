import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repository/auth_service.dart';
import 'bloc/main_bloc.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

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

    return BlocProvider(
      create: (context) => MainBloc(authService: context.read<AuthService>())
        ..add(CheckVerificationEvent()),
      child: Scaffold(
        body: DecoratedBox(
          decoration: styleBoxDecoration,
          child: BlocBuilder<MainBloc, MainState>(
            builder: (context, state) {
              if (state is VerificationUserState) {
                return const _ColumnForVerificationUser();
              } else if (state is NonVerificationUserState) {
                return const _ColumnForNonVerificationUserState();
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

class _ColumnForNonVerificationUserState extends StatelessWidget {
  const _ColumnForNonVerificationUserState({
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
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Письмо для подтверждения email отправлено на ${context.read<MainBloc>().user!.email}.',
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(height: 20),
            TextButton(
              style: buttonStyle,
              onPressed: () =>
                  context.read<MainBloc>().add(SendVerificationEmailEvent()),
              child: const Text(
                'Отправить письмо повторно',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              style: buttonStyle,
              onPressed: () =>
                  context.read<MainBloc>().add(CheckVerificationEvent()),
              child: const Text(
                'Почта была подтверждена',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColumnForVerificationUser extends StatelessWidget {
  const _ColumnForVerificationUser({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Главное меню',
            style: TextStyle(
              color: Colors.black,
              fontSize: 50,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 100),
          _StyleTextButton(
            text: 'Задачи для меня',
            function: () => Navigator.of(context).pushNamed('/Tasks'),
          ),
          const SizedBox(height: 20),
          _StyleTextButton(
            text: 'Настройки профиля',
            function: () => Navigator.of(context).pushNamed('/options'),
          ),
          const SizedBox(height: 20),
          _StyleTextButton(
            color: Colors.red,
            function: () => context.read<MainBloc>().add(SignOutEvent()),
            text: 'Выйти',
          ),
        ],
      ),
    );
  }
}

class _StyleTextButton extends StatelessWidget {
  final String text;
  final Function()? function;
  final Color color;
  const _StyleTextButton({
    required this.text,
    required this.function,
    this.color = const Color(0xFF0077B6),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = TextButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: color.withAlpha(150),
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
    return SizedBox(
      width: 350,
      child: TextButton(
        style: buttonStyle,
        onPressed: function, // () => Navigator.of(context).pushNamed('/Tasks'),
        child: Text(
          text,
          style: const TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
