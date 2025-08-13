import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../entity/task.dart';
import 'models/model_task.dart';
import 'tasks.dart';

class TasksBody extends StatefulWidget {
  final User? user;
  const TasksBody({required this.user, super.key});

  @override
  State<TasksBody> createState() => _TasksBodyState();
}

class _TasksBodyState extends State<TasksBody> {
  final Stream<QuerySnapshot> _tasksStream =
      FirebaseFirestore.instance.collection('tasks').snapshots();

  @override
  Widget build(BuildContext context) {
    final ModelTask model = context.watch<ModelTask>();
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _tasksStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final tasks =
                snapshot.data!.docs
                        .map<Task>(
                          (DocumentSnapshot<Map<String, dynamic>> doc) =>
                              Task.fromFirestore(doc),
                        )
                        .toList()
                    as List<Task>;

            return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () => model.addTask(context),
                backgroundColor: Colors.blue,
                child: const Icon(Icons.add, color: Colors.black),
              ),
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Row(
                  children: [
                    Expanded(child: Text(widget.user?.displayName ?? '')),
                    IconButton(
                      onPressed: model.signOut,
                      icon: const Icon(Icons.logout),
                    ),
                  ],
                ),
                backgroundColor: Colors.blue,
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: model.selectedPage,
                onTap: model.onSelect,
                backgroundColor: Colors.blue,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.black,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.task),
                    label: 'В работе',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.done),
                    label: 'Выполненные',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.close),
                    label: 'Отмененные',
                  ),
                ],
              ),
              body: IndexedStack(
                index: model.selectedPage,
                children: <Tasks>[
                  Tasks(status: 'ready', tasks: tasks),
                  Tasks(status: 'done', tasks: tasks),
                  Tasks(status: 'close', tasks: tasks),
                ],
              ),
            );
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
