import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../entity/task.dart';
import 'models/model_task.dart';
import 'tasks.dart';

class TasksBody extends StatelessWidget {
  final User user;
  const TasksBody({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    final ModelTask model = context.watch<ModelTask>();

    return Scaffold(
      body: StreamBuilder<List<Task>>(
        stream: model.getUserTasks(user.uid),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final tasks = snapshot.data ?? [];
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () => model.addTask(context, user.uid),
                backgroundColor: Colors.blue,
                child: const Icon(Icons.add, color: Colors.black),
              ),
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Row(
                  children: [
                    Expanded(child: Text(user?.displayName ?? '')),
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
