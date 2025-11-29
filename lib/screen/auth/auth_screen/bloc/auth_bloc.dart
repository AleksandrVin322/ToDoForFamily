import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../domain/service/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;
  StreamSubscription<User?>? _authSubscription;

  AuthBloc({
    required this.authService,
  }) : super(AuthInitialState()) {
    on<CheckAuthEvent>(_onCheckAuth);

    add(CheckAuthEvent());
    _authSubscription = authService.authStateChanges.listen((user) {
      add(CheckAuthEvent());
    });
  }

  void _onCheckAuth(
    CheckAuthEvent event,
    Emitter<AuthState> emit,
  ) {
    final user = authService.currentUser;
    if (user != null) {
      emit(AuthenticatedState(user: user));
    } else {
      emit(UnauthenticatedState());
    }
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
