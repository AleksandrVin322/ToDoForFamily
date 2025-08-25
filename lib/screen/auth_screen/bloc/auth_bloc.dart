import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../domain/repository/auth_service.dart';
import '../../../domain/repository/firestore_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;
  final FirestoreService firestoreService;
  StreamSubscription<User?>? _authSubscription;

  AuthBloc({
    required this.authService,
    required this.firestoreService,
  }) : super(AuthInitialState()) {
    on<CheckAuthEvent>(_onCheckAuth);
    on<LoginColumnEvent>(_loginColumn);
    on<RegisterColumnEvent>(_registerColumn);
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<ResetPasswordEvent>(_resetPassword);

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

  void _loginColumn(
    LoginColumnEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(UnauthenticatedState());
  }

  void _registerColumn(
    RegisterColumnEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(UnauthenticatedState(isLogin: false));
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }

  Future<void> _onLogin(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(UnauthenticatedState(isLoading: true));

      final user = await authService.login(
        email: event.email,
        password: event.password,
      );
      if (user != null) {
        emit(AuthenticatedState(user: user));
      } else {
        emit(UnauthenticatedState(errorMessage: 'Пользователь не найден'));
      }
    } on FirebaseAuthException catch (error) {
      emit(
        UnauthenticatedState(errorMessage: error.message!),
      );
    } catch (_) {
      emit(
        UnauthenticatedState(errorMessage: 'Ошибка. Попробуйте позже'),
      );
    }
  }

  Future<void> _onRegister(
    RegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      UnauthenticatedState(
        isLoading: true,
        isLogin: false,
      ),
    );
    try {
      if (event.password == event.checkPassword) {
        final userName = (event.userName.trim().isNotEmpty)
            ? event.userName.trim()
            : 'Anonymous';
        final user = await authService.register(
          userName: userName,
          email: event.email,
          password: event.password,
        );

        if (user != null) {
          firestoreService.addUser(
              id: user.uid, email: event.email, name: event.userName);
          emit(AuthenticatedState(user: user));
        } else {
          emit(
            UnauthenticatedState(
              errorMessage: 'Пользователь не найден',
              isLogin: false,
            ),
          );
        }
      } else {
        emit(
          UnauthenticatedState(
            errorMessage: 'Пароли не совпадают',
            isLogin: false,
          ),
        );
      }
    } on FirebaseAuthException catch (error) {
      emit(
        UnauthenticatedState(
          errorMessage: error.message!,
          isLogin: false,
        ),
      );
    }
  }

  void _resetPassword(
    ResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await authService.resetPassword(email: event.email);
    } on FirebaseAuthException catch (error) {
      emit(
        UnauthenticatedState(
          errorMessage: error.message!,
        ),
      );
    }
  }
}
