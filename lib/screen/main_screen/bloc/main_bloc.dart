import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../../domain/repository/auth_service.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final AuthService _authService;
  MainBloc({
    required AuthService authService,
  })  : _authService = authService,
        super(MainInitial()) {
    on<CheckVerificationEvent>(_checkVerification);
    on<SendVerificationEmailEvent>(_sendVerificationEmail);
    on<SignOutEvent>(_signOut);
  }

  void _checkVerification(
    CheckVerificationEvent event,
    Emitter<MainState> emit,
  ) async {
    final user = _authService.currentUser;
    if (user != null) {
      await user.reload();
      final updaterUser = _authService.currentUser;
      if (updaterUser!.emailVerified) {
        emit(VerificationUserState());
      } else {
        emit(NonVerificationUserState());
      }
    } else {
      return;
    }
  }

  void _sendVerificationEmail(
    SendVerificationEmailEvent event,
    Emitter<MainState> emit,
  ) async {
    await _authService.sendVerificationEmail();
  }

  void _signOut(
    SignOutEvent event,
    Emitter<MainState> emit,
  ) async {
    await _authService.signOut();
  }

  User? get user => _authService.currentUser;
}
