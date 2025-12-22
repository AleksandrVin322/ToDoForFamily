import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../../domain/service/auth_service.dart';
import '../../../domain/service/firestore_service.dart';

part 'settings_event.dart';
part 'settings_state.dart';

const _undefinedUserName = 'Имя пользователя отсутствует';
const _nullUser = 'Пользователь не найден.';
const _undefinedError = 'Неизвестная ошибка. Попробуйте позже.';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final FirestoreService firestoreService;
  final AuthService authService;
  SettingsBloc({
    required this.firestoreService,
    required this.authService,
  }) : super(SettingsInitial()) {
    on<ChangeUserNameEvent>(_changeUserName);
    on<GetUserNameEvent>(_getUserName);
    on<ChangeUserPasswordEvent>(_changePassword);
    on<DeleteUserEvent>(_deleteAcc);
  }

  void _getUserName(GetUserNameEvent event, Emitter<SettingsState> emit) {
    emit(SettingsLoading());
    final user = authService.currentUser;
    if (user != null) {
      emit(UserNameState(userName: user.displayName ?? _undefinedUserName));
    } else {
      emit(
        SettingsFailureState(errorMessage: _nullUser),
      );
    }
  }

  void _changeUserName(
    ChangeUserNameEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    final user = authService.currentUser;
    if (user != null) {
      try {
        await authService.changeUserName(newName: event.newName);
        await firestoreService.changeUserName(
          newName: event.newName,
          idUser: user.uid,
        );
        emit(
          UserNameState(userName: event.newName),
        );
      } on FirebaseAuthException catch (error) {
        emit(
          UserNameState(
            userName: user.displayName ?? _undefinedUserName,
            message: error.message ?? _undefinedError,
          ),
        );
      } catch (error) {
        emit(
          UserNameState(
            userName: user.displayName ?? _undefinedUserName,
            message: error.toString(),
          ),
        );
      }
    } else {
      emit(SettingsFailureState(errorMessage: _nullUser));
    }
  }

  void _changePassword(
    ChangeUserPasswordEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final user = authService.currentUser;
    if (user != null) {
      final userName = user.displayName;
      if (event.newPassword == event.oldPassword) {
        emit(
          UserNameState(
            message: 'Старый и новый пароль одинаковые.',
            userName: userName ?? _undefinedUserName,
          ),
        );
      } else {
        if (event.checkNewPassword != event.newPassword) {
          emit(
            UserNameState(
              message: 'Пароли не совпадают.',
              userName: userName ?? _undefinedUserName,
            ),
          );
        } else {
          emit(SettingsLoading());
          try {
            await authService.changePassword(
              newPassword: event.newPassword,
              oldPassword: event.oldPassword,
            );
            emit(
              UserNameState(
                userName: userName ?? _undefinedUserName,
                message: 'Пароль обновлен.',
              ),
            );
          } on FirebaseAuthException catch (error) {
            emit(
              UserNameState(
                  userName: userName ?? _undefinedUserName,
                  message: error.message ?? _undefinedError),
            );
          } catch (error) {
            emit(
              UserNameState(
                userName: userName ?? _undefinedUserName,
                message: error.toString(),
              ),
            );
          }
        }
      }
    } else {
      emit(SettingsFailureState(errorMessage: _nullUser));
    }
  }

  void _deleteAcc(
    DeleteUserEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    final user = authService.currentUser;
    if (user != null) {
      final userName = user.displayName;
      try {
        await authService.deleteAcc(oldPassword: event.oldPassword);
      } on FirebaseAuthException catch (error) {
        emit(UserNameState(
          message: error.message ?? _undefinedError,
          userName: userName ?? _undefinedUserName,
        ));
      } catch (error) {
        emit(UserNameState(
          message: error.toString(),
          userName: userName ?? _undefinedUserName,
        ));
      }
    } else {
      emit(SettingsFailureState(errorMessage: _nullUser));
    }
  }
}
