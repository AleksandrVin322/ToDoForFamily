part of 'column_login_bloc.dart';

@immutable
abstract class ColumnLoginEvent {}

class LoginEvent extends ColumnLoginEvent {
  final String email;
  final String password;
  LoginEvent({
    required this.email,
    required this.password,
  });
}

class ResetPasswordEvent extends ColumnLoginEvent {
  final String email;

  ResetPasswordEvent({required this.email});
}
