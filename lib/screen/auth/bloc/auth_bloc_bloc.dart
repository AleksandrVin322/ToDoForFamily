import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../domain/repository/auth_service.dart';
import '../../../domain/repository/firestore_service.dart';

part 'auth_bloc_event.dart';
part 'auth_bloc_state.dart';

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
      emit(Unauthenticated());
    }
  }

  void _loginColumn(
    LoginColumnEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(Unauthenticated());
  }

  void _registerColumn(
    RegisterColumnEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(Unauthenticated(isLogin: false));
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
      emit(Unauthenticated(isLoading: true));

      final user = await authService.login(
        email: event.email,
        password: event.password,
      );
      if (user != null) {
        emit(AuthenticatedState(user: user));
      } else {
        emit(Unauthenticated(errorMessage: 'Пользователь не найден'));
      }
    } on FirebaseAuthException catch (error) {
      emit(
        Unauthenticated(errorMessage: error.message!),
      );
    } catch (_) {
      emit(
        Unauthenticated(errorMessage: 'Ошибка. Попробуйте позже'),
      );
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(
      Unauthenticated(
        isLoading: true,
        isLogin: false,
      ),
    );
    try {
      if (event.password == event.checkPassword) {
        final user = await authService.register(
          userName: event.userName,
          email: event.email,
          password: event.password,
        );

        if (user != null) {
          firestoreService.addUser(
              id: user.uid, email: event.email, name: event.userName);
          emit(AuthenticatedState(user: user));
        } else {
          emit(
            Unauthenticated(
              errorMessage: 'Пользователь не найден',
              isLogin: false,
            ),
          );
        }
      } else {
        emit(
          Unauthenticated(
            errorMessage: 'Пароли не совпадают',
            isLogin: false,
          ),
        );
      }
    } on FirebaseAuthException catch (error) {
      emit(
        Unauthenticated(
          errorMessage: error.message!,
          isLogin: false,
        ),
      );
    }
  }
}

  // Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
  //   await authService.signOut();
  //   emit(AuthInitial());
  // }



