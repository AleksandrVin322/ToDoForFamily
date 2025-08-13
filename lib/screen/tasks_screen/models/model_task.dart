import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../entity/task.dart';

class ModelTask extends ChangeNotifier {
  int selectedPage = 0;
  final db = FirebaseFirestore.instance;

  void onSelect(int index) {
    if (selectedPage == index) return;
    selectedPage = index;
    notifyListeners();
  }

  void addTask(BuildContext context) {
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
                    () => saveNewTask(context, name.text, description.text),
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
  ) async {
    final id = db.collection('tasks').doc().id;
    final task =
        Task(
          id: id,
          createTime: DateTime.now().toString(),
          name: name,
          description: description,
          status: 'ready',
        ).toFirestore();
    db.collection('tasks').doc(id).set(task);
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
