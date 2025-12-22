import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../../../domain/service/auth_service.dart';

part 'column_login_event.dart';
part 'column_login_state.dart';

class ColumnLoginBloc extends Bloc<ColumnLoginEvent, ColumnLoginState> {
  final AuthService _authService;
  ColumnLoginBloc({required AuthService authService})
      : _authService = authService,
        super(ColumnLoginInitialState()) {
    on<LoginEvent>(_onLogin);
    on<ResetPasswordEvent>(_resetPassword);
  }

  void _onLogin(
    LoginEvent event,
    Emitter<ColumnLoginState> emit,
  ) async {
    emit(ColumnLoginInitialState(isLoading: true));
    try {
      await _authService.login(
        email: event.email,
        password: event.password,
      );
      emit(
        ColumnLoginInitialState(),
      );
    } on FirebaseAuthException catch (error) {
      emit(
        ColumnLoginInitialState(errorMessage: error.message!),
      );
    } catch (_) {
      emit(
        ColumnLoginInitialState(errorMessage: 'Ошибка. Попробуйте позже'),
      );
    }
  }

  void _resetPassword(
    ResetPasswordEvent event,
    Emitter<ColumnLoginState> emit,
  ) async {
    try {
      await _authService.resetPassword(email: event.email);
    } on FirebaseAuthException catch (error) {
      emit(
        ColumnLoginInitialState(
          errorMessage: error.message!,
        ),
      );
    }
  }
}
