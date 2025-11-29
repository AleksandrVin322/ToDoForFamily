import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../../../domain/service/auth_service.dart';
import '../../../../domain/service/firestore_service.dart';

part 'column_register_event.dart';
part 'column_register_state.dart';

class ColumnRegisterBloc
    extends Bloc<ColumnRegisterEvent, ColumnRegisterState> {
  final AuthService _authService;
  final FirestoreService _firestoreService;
  ColumnRegisterBloc({
    required AuthService authService,
    required FirestoreService firestoreService,
  })  : _authService = authService,
        _firestoreService = firestoreService,
        super(ColumnRegisterInitial()) {
    on<RegisterEvent>(_onRegister);
  }

  Future<void> _onRegister(
    RegisterEvent event,
    Emitter<ColumnRegisterState> emit,
  ) async {
    emit(
      ColumnRegisterInitial(isLoading: true),
    );
    try {
      if (event.password == event.checkPassword) {
        final userName = (event.userName.trim().isNotEmpty)
            ? event.userName.trim()
            : 'Anonymous';
        final user = await _authService.register(
          userName: userName,
          email: event.email,
          password: event.password,
        );

        if (user != null) {
          _firestoreService.addUser(
              id: user.uid, email: event.email, name: event.userName);
          emit(ColumnRegisterInitial());
        } else {
          emit(
            ColumnRegisterInitial(
              errorMessage: 'Пользователь не найден',
            ),
          );
        }
      } else {
        emit(
          ColumnRegisterInitial(
            errorMessage: 'Пароли не совпадают',
          ),
        );
      }
    } on FirebaseAuthException catch (error) {
      emit(
        ColumnRegisterInitial(
          errorMessage: error.message!,
        ),
      );
    }
  }
}
