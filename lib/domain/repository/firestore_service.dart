import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import '../../entity/task.dart';
import '../../entity/user_bd.dart';

class FirestoreService {
  Stream<List<Task>> getUserTasks({required String userId}) {
    try {
      return FirebaseFirestore.instance
          .collection('users/$userId/userTasks')
          .snapshots()
          .switchMap((userTasksSnapshot) {
        if (userTasksSnapshot.docs.isEmpty) {
          return Stream.value([]);
        }

        final taskStreams = userTasksSnapshot.docs.map((doc) {
          final ref = doc['taskRef'] as DocumentReference;
          return ref.snapshots().map(Task.fromFirestore);
        }).toList();
        return CombineLatestStream.list(taskStreams);
      });
    } on FirebaseException catch (_) {
      rethrow;
    } catch (error) {
      throw FirebaseException(message: 'unknown', plugin: 'Firestore:');
    }
  }

  Future<void> addTask({
    required String name,
    required String description,
    required String author,
    required String responsibleID,
  }) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('tasks').doc();
      final id = docRef.id;
      final task = Task(
        id: id,
        createTime: DateTime.now().toString(),
        name: name,
        description: description,
        status: 'ready',
        author: author,
        responsible: responsibleID,
      ).toFirestore();
      await docRef.set(task);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(responsibleID)
          .collection('userTasks')
          .doc(id)
          .set({'taskRef': docRef});
    } on FirebaseException catch (_) {
      rethrow;
    } catch (error) {
      throw FirebaseException(message: 'unknown', plugin: 'Firestore:');
    }
  }

  Future<void> updateStatusTask({
    required String idDoc,
    required String status,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(idDoc)
          .update({'status': status});
    } on FirebaseException catch (_) {
      rethrow;
    } catch (error) {
      throw FirebaseException(message: 'unknown', plugin: 'Firestore:');
    }
  }

  Future<List<UserBD>> getUsers() async {
    final List<UserBD> users = [];
    try {
      final docSnap = await FirebaseFirestore.instance
          .collection('users')
          .withConverter(
            fromFirestore: UserBD.fromFirestore,
            toFirestore: (UserBD user, _) => user.toFirestore(),
          )
          .get();
      for (final doc in docSnap.docs) {
        users.add(doc.data());
      }
      return users;
    } on FirebaseException catch (_) {
      rethrow;
    } catch (error) {
      throw FirebaseException(message: 'unknown', plugin: 'Firestore:');
    }
  }

  void addUser({
    required String id,
    required String email,
    required String name,
  }) async {
    try {
      final user = UserBD(id: id, email: email, name: name);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .withConverter(
              fromFirestore: UserBD.fromFirestore,
              toFirestore: (UserBD user, _) => user.toFirestore())
          .set(user);
    } on FirebaseException catch (_) {
      rethrow;
    } catch (error) {
      throw FirebaseException(message: 'unknown', plugin: 'Firestore:');
    }
  }
}
