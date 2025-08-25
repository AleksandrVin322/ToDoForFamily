part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthenticatedState extends AuthState {
  final User user;

  AuthenticatedState({required this.user});
}

class UnauthenticatedState extends AuthState {
  final bool isLogin;
  final String errorMessage;
  final bool isLoading;

  UnauthenticatedState({
    this.isLogin = true,
    this.errorMessage = '',
    this.isLoading = false,
  });
}

class ResetPasswordState extends AuthState {}

class LoadingState extends AuthState {}
