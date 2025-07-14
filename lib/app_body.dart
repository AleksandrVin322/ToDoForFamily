import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/model_task.dart';
import 'ready_tasks.dart';

class AppBody extends StatefulWidget {
  const AppBody({super.key});

  @override
  State<AppBody> createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  late final Future<void> _initFuture;

  @override
  void initState() {
    _initFuture = context.read<ModelTask>().initProjects();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ModelTask model = context.watch<ModelTask>();
    return FutureBuilder(
      future: _initFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () => model.addTask(context),
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add, color: Colors.black),
            ),
            appBar: AppBar(
              title: const Center(child: Text('Tasks')),
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
              children: const <Widget>[
                Tasks(status: 'ready'),
                Tasks(status: 'done'),
                Tasks(status: 'close'),
              ],
            ),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
