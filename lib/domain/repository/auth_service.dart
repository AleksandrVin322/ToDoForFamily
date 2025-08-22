import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> register({
    required String userName,
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      final user = userCredential.user;
      if (user != null) {
        user.updateDisplayName(userName);
        await user.reload();
        return user;
      }
    } on FirebaseAuthException catch (_) {
      rethrow;
    } catch (error) {
      throw FirebaseAuthException(code: 'unknown', message: 'unknown');
    }
  }

  Future<User?> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (_) {
      rethrow;
    } catch (error) {
      throw FirebaseAuthException(code: 'unknown', message: 'unknown');
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (_) {
      rethrow;
    } catch (error) {
      throw FirebaseAuthException(code: 'unknown', message: 'unknown');
    }
  }

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;
}
