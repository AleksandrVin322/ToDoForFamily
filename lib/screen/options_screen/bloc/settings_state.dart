part of 'settings_bloc.dart';

@immutable
abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class UserNameState extends SettingsState {
  final String userName;
  final String message;
  UserNameState({
    this.userName = 'Имя пользователя отсутствует',
    this.message = '',
  });
}

class SettingsFailureState extends SettingsState {
  final String errorMessage;
  SettingsFailureState({required this.errorMessage});
}
