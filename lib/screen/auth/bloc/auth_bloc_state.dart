part of 'auth_bloc_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthenticatedState extends AuthState {
  final User user;

  AuthenticatedState({required this.user});
}

class Unauthenticated extends AuthState {
  final bool isLogin;
  final String errorMessage;
  final bool isLoading;

  Unauthenticated({
    this.isLogin = true,
    this.errorMessage = '',
    this.isLoading = false,
  });
}

class LoadingState extends AuthState {}
