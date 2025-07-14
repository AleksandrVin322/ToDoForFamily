import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../entity/task.dart';

class ModelTask extends ChangeNotifier {
  final List<Task> tasks = [];
  final db = FirebaseFirestore.instance;

  Future<String> initProjects() async {
    await db
        .collection("tasks")
        .withConverter(
          fromFirestore: Task.fromFirestore,
          toFirestore: (Task project, _) => project.toFirestore(),
        )
        .get()
        .then((querySnapshot) {
          for (final docSnapshot in querySnapshot.docs) {
            tasks.add(docSnapshot.data());
          }
        });

    return 'Data Loaded';
  }

  int selectedPage = 1;

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
                onPressed: () => saveNewTask(context),
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

  /// Сохранить новый проект в БД.
  void saveNewTask(BuildContext context) async {}
  }
