import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../entity/user_bd.dart';

class AuthService {
  Future<void> register({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user?.sendEmailVerification();
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (_) {
      rethrow;
    } catch (error) {
      throw FirebaseAuthException(code: 'unknown', message: 'unknown');
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (_) {
      rethrow;
    } catch (error) {
      throw FirebaseAuthException(code: 'unknown', message: 'unknown');
    }
  }

  Future<void> saveUser({
    required String name,
  }) async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await currentUser.updateDisplayName(name);
        await currentUser.reload();
        final doc =
            FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
        final userBD = UserBD(
          id: currentUser.uid,
          email: currentUser.email,
          name: name,
        );
        await doc.set(userBD.toFirestore());
      }
    } on FirebaseAuthException catch (_) {
      rethrow;
    } catch (error) {
      throw FirebaseAuthException(code: 'unknown', message: 'unknown');
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (_) {
      rethrow;
    } catch (error) {
      throw FirebaseAuthException(code: 'unknown', message: 'unknown');
    }
  }
}
