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
        if (state is Unauthenticated) {
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
          if (state is Unauthenticated) {
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
