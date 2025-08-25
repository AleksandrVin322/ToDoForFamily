import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repository/auth_service.dart';
import '../../domain/repository/firestore_service.dart';
import 'bloc/settings_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const boxDecoration = BoxDecoration(
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

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => FirestoreService(),
        ),
        RepositoryProvider(
          create: (context) => AuthService(),
        ),
      ],
      child: BlocProvider(
        create: (context) => SettingsBloc(
          firestoreService: context.read<FirestoreService>(),
          authService: context.read<AuthService>(),
        )..add(GetUserNameEvent()),
        child: BlocListener<SettingsBloc, SettingsState>(
          listener: (context, state) {
            if (state is UserNameState) {
              if (state.message.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(state.message),
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            }
          },
          child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              if (state is UserNameState) {
                return SafeArea(
                  child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: const Color(0xFF0077B6),
                    ),
                    body: DecoratedBox(
                      decoration: boxDecoration,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _ChangeUserNameWidget(userName: state.userName),
                          const SizedBox(height: 20),
                          const _ChangePasswordWidget(),
                          const SizedBox(height: 20),
                          _DeleteAccButton(state: state),
                        ],
                      ),
                    ),
                  ),
                );
              } else if (state is SettingsFailureState) {
                return const Center(
                  child: Text('Failure. Try again'),
                );
              } else {
                return const Scaffold(
                  body: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Загрузка...'),
                        CircularProgressIndicator(),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class _DeleteAccButton extends StatelessWidget {
  final UserNameState state;
  const _DeleteAccButton({
    required this.state,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        style: const ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.red),
        ),
        onPressed: () async {
          _deleteAcc(context, state);
        },
        child: const Text(
          'Удалить аккаунт',
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _ChangePasswordWidget extends StatelessWidget {
  const _ChangePasswordWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final checkNewPasswordController = TextEditingController();

    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '2. Сменить пароль',
            style: TextStyle(fontSize: 20),
          ),
          const Text(
            'Старый пароль',
            style: TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 10),
          _StyleTextField(
            controller: oldPasswordController,
            hintText: 'Введите старый пароль',
          ),
          const SizedBox(height: 10),
          const Text(
            'Новый пароль',
            style: TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 10),
          _StyleTextField(
            controller: newPasswordController,
            hintText: 'Введите новый пароль',
          ),
          const SizedBox(height: 10),
          const Text(
            'Проверка пароля',
            style: TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 10),
          _StyleTextField(
            controller: checkNewPasswordController,
            hintText: 'Проверка нового пароля',
          ),
          Center(
            child: IconButton(
              onPressed: () => context.read<SettingsBloc>().add(
                    ChangeUserPasswordEvent(
                      oldPassword: oldPasswordController.text,
                      newPassword: newPasswordController.text,
                      checkNewPassword: checkNewPasswordController.text,
                    ),
                  ),
              icon: const Icon(
                Icons.save,
                size: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChangeUserNameWidget extends StatelessWidget {
  final String userName;
  const _ChangeUserNameWidget({
    required this.userName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final newUserNameController = TextEditingController();
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '1. Текущее имя пользователя: $userName',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _StyleTextField(
                  controller: newUserNameController,
                  hintText: 'Введите новое имя пользователя',
                ),
              ),
              IconButton(
                onPressed: () => context.read<SettingsBloc>().add(
                      ChangeUserNameEvent(newName: newUserNameController.text),
                    ),
                icon: const Icon(
                  Icons.save,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StyleTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  const _StyleTextField({
    required this.hintText,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        enabledBorder: const OutlineInputBorder(),
      ),
    );
  }
}

void _deleteAcc(BuildContext context, SettingsState state) async {
  const inputDecoration = InputDecoration(border: OutlineInputBorder());
  final passwordController = TextEditingController();
  final bloc = context.read<SettingsBloc>();
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Center(child: Text('Создание задачи')),
      content: TextField(
        decoration: inputDecoration,
        controller: passwordController,
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                bloc.add(DeleteUserEvent(oldPassword: passwordController.text));
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.done,
                size: 50,
                color: Colors.blue,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.cancel,
                size: 50,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
