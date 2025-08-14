import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../../entity/task.dart';
import '../../../entity/user_bd.dart';

class ModelTask extends ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;
  StreamSubscription<List<Task>>? _tasksSubscription;

  int _selectedPage = 0;
  int get selectedPage => _selectedPage;

  final _db = FirebaseFirestore.instance;

  final fromTask = TextEditingController();

  List<UserBD> users = [];
  static String _displayStringForOption(UserBD option) => option.name!;

  void onSelect(int index) {
    if (_selectedPage == index) return;
    _selectedPage = index;
    notifyListeners();
  }

  void initTasksStream(String userId) {
    _tasksSubscription = getUserTasks(userId).listen((tasks) {
      _tasks = tasks;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _tasksSubscription?.cancel();
    super.dispose();
  }

  Stream<List<Task>> getUserTasks(String userId) {
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
  }

  void addTask(BuildContext context, User user) async {
    final name = TextEditingController();
    final description = TextEditingController();
    await initUsers();
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Center(child: Text('Создание задачи')),
        content: SizedBox(
          height: 500,
          width: 300,
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text('Введите название новой задачи'),
              TextField(controller: name),
              const SizedBox(height: 10),
              const Text('Введите описание новой задачи'),
              TextField(controller: description, maxLines: 4),
              const SizedBox(height: 10),
              const Text('Выбери ответственного за задачу'),
              Autocomplete<UserBD>(
                displayStringForOption: _displayStringForOption,
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<UserBD>.empty();
                  }
                  return users.where((UserBD option) {
                    return option.toString().contains(
                          textEditingValue.text.toLowerCase(),
                        );
                  });
                },
                onSelected: (UserBD selection) {
                  fromTask.text = selection.id!;
                },
                fieldViewBuilder: (
                  context,
                  textEditingController,
                  focusNode,
                  onFieldSubmitted,
                ) {
                  return TextField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      labelText: 'Выберите пользователя',
                      border: OutlineInputBorder(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => saveNewTask(
              context,
              name.text,
              description.text,
              user,
              fromTask.text,
            ),
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

  Future<void> initUsers() async {
    final List<UserBD> currentListUsers = [];

    await FirebaseFirestore.instance
        .collection('users')
        .withConverter(
          fromFirestore: UserBD.fromFirestore,
          toFirestore: (UserBD user, _) => user.toFirestore(),
        )
        .get()
        .then((querySnapshot) {
      for (final docSnapshot in querySnapshot.docs) {
        currentListUsers.add(docSnapshot.data());
      }
    });
    users = currentListUsers;
  }

  ///Сохранить новый проект в БД.
  void saveNewTask(
    BuildContext context,
    String name,
    String description,
    User user,
    String email,
  ) async {
    final docRef = _db.collection('tasks').doc();
    final id = docRef.id;
    final task = Task(
      id: id,
      createTime: DateTime.now().toString(),
      name: name,
      description: description,
      status: 'ready',
      author: user.displayName!,
      responsible: fromTask.text,
    ).toFirestore();
    await docRef.set(task);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(fromTask.text)
        .collection('userTasks')
        .doc(id)
        .set({'taskRef': docRef});
    _selectedPage = 0;
    Navigator.of(context).pop();
  }

  void deleteTask(String idDoc) {
    _db.collection('tasks').doc(idDoc).update({'status': 'delete'});
  }

  void doneTask(String idDoc) {
    _db.collection('tasks').doc(idDoc).update({'status': 'done'});
  }

  void closeTask(String idDoc) {
    _db.collection('tasks').doc(idDoc).update({'status': 'close'});
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
