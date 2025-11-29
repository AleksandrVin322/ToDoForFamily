part of 'column_register_bloc.dart';

@immutable
abstract class ColumnRegisterEvent {}

class RegisterEvent extends ColumnRegisterEvent {
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
