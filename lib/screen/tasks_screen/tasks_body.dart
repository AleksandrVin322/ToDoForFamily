import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../entity/task.dart';
import '../auth/model/model_auth.dart';
import 'models/model_task.dart';
import 'tasks_with_status.dart';

class TasksBody extends StatefulWidget {
  final User user;
  const TasksBody({
    required this.user,
    super.key,
  });

  @override
  State<TasksBody> createState() => _TasksBodyState();
}

class _TasksBodyState extends State<TasksBody> {
  @override
  void initState() {
    super.initState();
    Provider.of<ModelTask>(context, listen: false)
        .initTasksStream(widget.user.uid);
  }

  @override
  Widget build(BuildContext context) {
    final ModelTask modelTask = context.watch<ModelTask>();

    return Scaffold(
      body: StreamBuilder<List<Task>>(
        stream: modelTask.getUserTasks(widget.user.uid),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () => modelTask.addTask(context, widget.user),
                backgroundColor: const Color.fromRGBO(175, 195, 211, 1),
                child: const Icon(Icons.add, color: Colors.black),
              ),
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Row(
                  children: [
                    Expanded(child: Text(widget.user.displayName ?? '')),
                    ChangeNotifierProvider(
                      create: (BuildContext context) => ModelAuth(),
                      child: MyIconButton(),
                    )
                  ],
                ),
                backgroundColor: Colors.blue,
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: modelTask.selectedPage,
                onTap: modelTask.onSelect,
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
                index: modelTask.selectedPage,
                children: const <TasksWithStatus>[
                  TasksWithStatus(status: 'ready'),
                  TasksWithStatus(status: 'done'),
                  TasksWithStatus(status: 'close'),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class MyIconButton extends StatelessWidget {
  const MyIconButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ModelAuth modelAuth = context.read<ModelAuth>();
    return IconButton(
      onPressed: modelAuth.signOut,
      icon: const Icon(Icons.logout),
    );
  }
}
