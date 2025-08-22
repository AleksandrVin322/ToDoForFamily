part of '../login_page.dart';

class _ColumnRegister extends StatefulWidget {
  const _ColumnRegister({
    super.key,
  });

  @override
  State<_ColumnRegister> createState() => _ColumnRegisterState();
}

class _ColumnRegisterState extends State<_ColumnRegister> {
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
                      'Создание нового аккаунта',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 89, 91, 131),
                      ),
                    ),
                    const SizedBox(height: 10),
                    StyleTextField(
                      hintText: 'Введите имя пользователя',
                      icon: const Icon(Icons.account_circle),
                      isPassword: false,
                      controller: _userNameController,
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
                    const SizedBox(height: 10),
                    StyleTextField(
                      hintText: 'Повторите пароль',
                      icon: const Icon(Icons.password),
                      isPassword: true,
                      controller: _checkPasswordController,
                    ),
                    const SizedBox(height: 20),
                    StyleTextButton(
                      text: 'Регистрация',
                      function: () => context.read<AuthBloc>().add(
                            RegisterEvent(
                              userName: _userNameController.text,
                              email: _emailController.text,
                              password: _passwordController.text,
                              checkPassword: _checkPasswordController.text,
                            ),
                          ),
                    ),
                    const SizedBox(height: 10),
                    StyleTextButton(
                      text: 'Есть аккаунт?',
                      function: () =>
                          context.read<AuthBloc>().add(LoginColumnEvent()),
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
