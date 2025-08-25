part of '../login_page.dart';

class _ColumnLogin extends StatefulWidget {
  const _ColumnLogin({
    super.key,
  });

  @override
  State<_ColumnLogin> createState() => _ColumnLoginState();
}

class _ColumnLoginState extends State<_ColumnLogin> {
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UnauthenticatedState) {
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
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is UnauthenticatedState) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
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
                    StyleTextField(
                      hintText: 'Введите почту',
                      icon: const Icon(Icons.mail),
                      isPassword: false,
                      controller: _emailController,
                    ),
                    const SizedBox(height: 10),
                    StyleTextField(
                      hintText: 'Введите пароль',
                      icon: const Icon(Icons.password),
                      isPassword: true,
                      controller: _passwordController,
                    ),
                    const SizedBox(height: 20),
                    StyleTextButton(
                      text: 'Войти',
                      function: !state.isLoading
                          ? () {
                              context.read<AuthBloc>().add(
                                    LoginEvent(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    ),
                                  );
                            }
                          : null,
                    ),
                    const SizedBox(height: 10),
                    StyleTextButton(
                      text: 'Создать аккаунт',
                      function: !state.isLoading
                          ? () => context
                              .read<AuthBloc>()
                              .add(RegisterColumnEvent())
                          : null,
                    ),
                    const SizedBox(height: 10),
                    StyleTextButton(
                      text: 'Сбросить пароль',
                      function: !state.isLoading
                          ? () => _resetPassword(context)
                          : null,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

void _resetPassword(BuildContext context) async {
  final emailController = TextEditingController();
  final bloc = context.read<AuthBloc>();
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
