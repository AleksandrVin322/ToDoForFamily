part of 'auth_bloc_bloc.dart';

@immutable
abstract class AuthEvent {}

class CheckAuthEvent extends AuthEvent {}

class LoginColumnEvent extends AuthEvent {}

class RegisterColumnEvent extends AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  LoginEvent({
    required this.email,
    required this.password,
  });
}

class RegisterEvent extends AuthEvent {
  final String userName;
  final String email;
  final String password;
  final String checkPassword;
  RegisterEvent({
    required this.userName,
    required this.email,
    required this.password,
    required this.checkPassword,
  });
}

class ResetPasswordEvent extends AuthEvent {
  final String email;

  ResetPasswordEvent({required this.email});
}

class LoadingFailureEvent extends AuthEvent {}
