import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;

  AuthService({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<T> _errorHandle<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } on FirebaseAuthException catch (error) {
      throw FirebaseAuthException(
        code: error.code,
        message: _translateFirebaseError(error.code),
      );
    } catch (error, stackTrace) {
      log('Unknown error in AuthService: $error', stackTrace: stackTrace);
      throw FirebaseAuthException(
        code: 'operation-failed',
        message: 'Не удалось выполнить операцию. Попробуйте еще раз.',
      );
    }
  }

  Future<User?> register({
    required String userName,
    required String email,
    required String password,
  }) async {
    return _errorHandle(
      () async {
        final UserCredential userCredential = await _firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);
        User? user = userCredential.user;
        if (user != null) {
          await user.updateDisplayName(userName);
          await user.reload();
          user = _firebaseAuth.currentUser;
          await userCredential.user!.sendEmailVerification();
          return user;
        }
      },
    );
  }

  Future<User?> login({
    required String email,
    required String password,
  }) async {
    return _errorHandle(() async {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    });
  }

  Future<void> signOut() async {
    return _errorHandle(
      () async {
        await _firebaseAuth.signOut();
      },
    );
  }

  Future<void> changeUserName({required String newName}) async {
    return _errorHandle(
      () async {
        final user = _firebaseAuth.currentUser;
        if (user != null) {
          await user.updateDisplayName(newName);
          await user.reload();
        }
      },
    );
  }

  Future<void> changePassword({
    required String newPassword,
    required String oldPassword,
  }) async {
    return _errorHandle(
      () async {
        final user = _firebaseAuth.currentUser;
        if (user != null) {
          final credential = EmailAuthProvider.credential(
            email: user.email!,
            password: oldPassword,
          );
          await user.reauthenticateWithCredential(credential);
          await user.updatePassword(newPassword);
        }
      },
    );
  }

  Future<void> deleteAcc({required String oldPassword}) async {
    return _errorHandle(
      () async {
        final user = _firebaseAuth.currentUser;
        if (user != null) {
          final credential = EmailAuthProvider.credential(
            email: user.email!,
            password: oldPassword,
          );
          await user.reauthenticateWithCredential(credential);
          await user.delete();
        }
      },
    );
  }

  Future<void> resetPassword({required String email}) {
    return _errorHandle(() async {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    });
  }

  Future<void> sendVerificationEmail() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    }
  }

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;
}

String _translateFirebaseError(String code) {
  switch (code) {
    case 'invalid-email':
      return 'Неверный формат email адреса';
    case 'user-disabled':
      return 'Аккаунт пользователя отключен';
    case 'user-not-found':
      return 'Пользователь с таким email не найден';
    case 'wrong-password':
      return 'Неверный пароль';
    case 'email-already-in-use':
      return 'Email уже используется другим аккаунтом';
    case 'weak-password':
      return 'Пароль слишком слабый. Используйте не менее 6 символов';
    case 'network-request-failed':
      return 'Ошибка сетевого соединения';
    case 'too-many-requests':
      return 'Слишком много запросов. Попробуйте позже';
    default:
      return 'Произошла ошибка: $code. Попробуйте еще раз';
  }
}
