import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

import '../../entity/family.dart';
import '../../entity/task.dart';
import '../../entity/user_bd.dart';

class FirestoreService {
  final FirebaseFirestore _firebaseFirestore;

  FirestoreService({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Stream<List<Task>> getUserTasks({required String userId}) {
    try {
      return _firebaseFirestore
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
      final docRef = _firebaseFirestore.collection('tasks').doc();
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
      await _firebaseFirestore
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
      await _firebaseFirestore
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
      final docSnap = await _firebaseFirestore
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
      await _firebaseFirestore
          .collection('users')
          .doc(id)
          .withConverter(
            fromFirestore: UserBD.fromFirestore,
            toFirestore: (UserBD user, _) => user.toFirestore(),
          )
          .set(user);
    } on FirebaseException catch (_) {
      rethrow;
    } catch (error) {
      throw FirebaseException(message: 'unknown', plugin: 'Firestore:');
    }
  }

  Future<void> changeUserName({
    required String newName,
    required String idUser,
  }) async {
    try {
      await _firebaseFirestore
          .collection('users')
          .doc(idUser)
          .update({'name': newName});
    } on FirebaseException catch (_) {
      rethrow;
    } catch (error) {
      throw FirebaseException(message: 'unknown', plugin: 'Firestore:');
    }
  }

  Future<Family> getFamily({required String userId}) async {
    final DocumentSnapshot snapshot =
        await _firebaseFirestore.collection('users').doc(userId).get();
    final DocumentReference ref = snapshot.get('family');
    final familySnapshot = await ref
        .withConverter(
          fromFirestore: Family.fromFirestore,
          toFirestore: (Family family, _) => family.toFirestore(),
        )
        .get();
    final Family? family = familySnapshot.data();
    if (family != null) {
      return family;
    }
    return const Family(id: 'unknown', name: 'unknown');
  }

  Future<List<UserBD>> getMembersFamily({required String familyId}) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> membersSnapshot =
          await FirebaseFirestore.instance
              .collection('families')
              .doc(familyId)
              .collection('members')
              .get();
      if (membersSnapshot.docs.isEmpty) {
        return [];
      }
      final List<DocumentReference<Map<String, dynamic>>> userRefs =
          membersSnapshot.docs
              .map(
                (doc) => doc.data()['docRef']
                    as DocumentReference<Map<String, dynamic>>?,
              )
              .where((ref) => ref != null)
              .toList()
              .cast<DocumentReference<Map<String, dynamic>>>();
      if (userRefs.isEmpty) {
        return [];
      }
      final List<Future<DocumentSnapshot<Map<String, dynamic>>>> userFutures =
          userRefs.map((ref) => ref.get()).toList();
      final List<DocumentSnapshot<Map<String, dynamic>>> userSnapshots =
          await Future.wait(userFutures);
      final List<UserBD> users = userSnapshots
          .where((snapshot) => snapshot.exists)
          .map((snapshot) => UserBD.fromFirestore(snapshot, null))
          .toList();
      return users;
    } catch (e) {
      return [];
    }
  }

  Future<void> addMember({
    required DocumentReference docFamilies,
    required DocumentReference docUser,
  }) async {
    await _firebaseFirestore
        .collection('families')
        .doc(docFamilies.id)
        .collection('members')
        .doc(docUser.id)
        .set({'docRef': docUser});
    await _firebaseFirestore.collection('users').doc(docUser.id).update(
      {'family': docFamilies},
    );
  }

  Future<void> deleteMember({
    required String userId,
    required String familiesId,
    required String memberId,
  }) async {
    await _firebaseFirestore.collection('users').doc(userId).update(
      {'family': null},
    );
    await _firebaseFirestore
        .collection('families')
        .doc(familiesId)
        .collection('members')
        .doc(memberId)
        .delete();
  }

  Future<void> createFamily({required String name, required User user}) async {
    final docRefFamily =
        await _firebaseFirestore.collection('families').add({'name': name});
    await docRefFamily.update({'id': docRefFamily.id});

    final userDocRef = _firebaseFirestore.collection('users').doc(user.uid);

    final familyMembersDocRef = _firebaseFirestore
        .collection('families')
        .doc(docRefFamily.id)
        .collection('members')
        .doc(user.uid);

    await userDocRef.update({
      'family': _firebaseFirestore.collection('families').doc(docRefFamily.id),
    });
    await familyMembersDocRef.set({'docRef': userDocRef});
  }
}
