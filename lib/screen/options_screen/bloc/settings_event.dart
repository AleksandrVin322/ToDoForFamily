part of 'settings_bloc.dart';

@immutable
abstract class SettingsEvent {}

class GetUserNameEvent extends SettingsEvent {}

class ChangeUserNameEvent extends SettingsEvent {
  final String newName;
  ChangeUserNameEvent({required this.newName});
}

class ChangeUserPasswordEvent extends SettingsEvent {
  final String newPassword;
  final String oldPassword;
  final String checkNewPassword;
  ChangeUserPasswordEvent({
    required this.newPassword,
    required this.oldPassword,
    required this.checkNewPassword,
  });
}

class DeleteUserEvent extends SettingsEvent {
  final String oldPassword;

  DeleteUserEvent({
    required this.oldPassword,
  });
}
