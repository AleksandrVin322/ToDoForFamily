import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../../entity/task.dart';

class ModelTask extends ChangeNotifier {
  int selectedPage = 0;

  final db = FirebaseFirestore.instance;

  void onSelect(int index) {
    if (selectedPage == index) return;
    selectedPage = index;
    notifyListeners();
  }

  Stream<List<Task>> getUserTasks(String userId) {
    return FirebaseFirestore.instance
        .collection('users/$userId/userTasks')
        .snapshots()
        .switchMap((userTasksSnapshot) {
          if (userTasksSnapshot.docs.isEmpty) {
            return Stream.value([]);
          }

          final taskStreams =
              userTasksSnapshot.docs.map((doc) {
                final ref = doc['taskRef'] as DocumentReference;
                return ref.snapshots().map(Task.fromFirestore);
              }).toList();
          print(userTasksSnapshot.docs.length);
          return CombineLatestStream.list(taskStreams);
        });
  }

  void addTask(BuildContext context, String uid) {
    final name = TextEditingController();
    final description = TextEditingController();
    showDialog<String>(
      context: context,
      builder:
          (BuildContext context) => AlertDialog(
            title: const Center(child: Text('Создание задачи')),
            content: SizedBox(
              height: 300,
              width: 300,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text('Введите название новой задачи'),
                  TextField(controller: name),
                  const SizedBox(height: 10),
                  const Text('Введите описание новой задачи'),
                  TextField(controller: description, maxLines: 4),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed:
                    () =>
                        saveNewTask(context, name.text, description.text, uid),
                child: const Text('Save'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
    );
  }

  //Сохранить новый проект в БД.
  void saveNewTask(
    BuildContext context,
    String name,
    String description,
    String uid,
  ) async {
    final docRef = db.collection('tasks').doc();
    final id = docRef.id;
    final task =
        Task(
          id: id,
          createTime: DateTime.now().toString(),
          name: name,
          description: description,
          status: 'ready',
        ).toFirestore();
    await docRef.set(task);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('userTasks')
        .doc(id)
        .set({'taskRef': docRef});
    selectedPage = 0;
    Navigator.of(context).pop();
  }

  void deleteTask(String idDoc) {
    db.collection('tasks').doc(idDoc).update({'status': 'delete'});
  }

  void doneTask(String idDoc) {
    db.collection('tasks').doc(idDoc).update({'status': 'done'});
  }

  void closeTask(String idDoc) {
    db.collection('tasks').doc(idDoc).update({'status': 'close'});
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
