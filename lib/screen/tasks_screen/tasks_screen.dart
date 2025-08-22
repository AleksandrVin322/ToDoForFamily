import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repository/auth_service.dart';
import '../../domain/repository/firestore_service.dart';
import '../../entity/user_bd.dart';
import 'bloc/tasks_bloc.dart';
import 'tasks_with_status.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => FirestoreService(),
        ),
        RepositoryProvider(
          create: (context) => AuthService(),
        ),
      ],
      child: BlocProvider(
        create: (context) => TasksBloc(
          firestoreService: context.read<FirestoreService>(),
          authService: context.read<AuthService>(),
        )
          ..add(
            LoadUserTasksEvent(context.read<AuthService>().currentUser!.uid),
          )
          ..add(LoadUsersEvent()),
        child: const TasksBody(),
      ),
    );
  }
}

class TasksBody extends StatelessWidget {
  const TasksBody({super.key});

  @override
  Widget build(BuildContext context) {
    const boxDecoration = BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xFF0077B6),
          Color.fromARGB(255, 255, 255, 255),
        ],
        stops: [
          0.0,
          1,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
    const bottomNavigationBarItems = <BottomNavigationBarItem>[
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
    ];

    return BlocBuilder<TasksBloc, TasksState>(
      builder: (context, state) {
        if (state is TasksLoadedState) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.blue,
              onPressed: () async {
                _addTask(context, state);
              },
              child: const Icon(Icons.add),
            ),
            appBar: AppBar(
              backgroundColor: Colors.blue,
              title: Text(
                state.currentUser?.displayName ?? 'Имя пользователя не найдено',
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.lightBlue,
              selectedItemColor: Colors.white,
              currentIndex: state.selectedIndex,
              onTap: (index) {
                context.read<TasksBloc>().add(ChangeTasksStatusEvent(index));
              },
              items: bottomNavigationBarItems,
            ),
            body: DecoratedBox(
              decoration: boxDecoration,
              child: Center(
                child: IndexedStack(
                  index: state.selectedIndex,
                  children: [
                    TasksWithStatus(status: 'ready', tasks: state.tasks),
                    TasksWithStatus(status: 'done', tasks: state.tasks),
                    TasksWithStatus(status: 'close', tasks: state.tasks),
                  ],
                ),
              ),
            ),
          );
        } else if (state is TasksFailureState) {
          return Scaffold(
            appBar: AppBar(),
            body: const Text('Произошла ошибка на сервере. Попробуйте позже'),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Загрузка...'),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

void _addTask(BuildContext context, TasksLoadedState state) async {
  const inputDecoration = InputDecoration(border: OutlineInputBorder());
  final TasksBloc tasksBloc = context.read<TasksBloc>();
  final name = TextEditingController();
  final description = TextEditingController();
  final id = TextEditingController();
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Center(child: Text('Создание задачи')),
      content: SizedBox(
        width: 1000,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              const Text('Введите название новой задачи'),
              TextField(
                controller: name,
                decoration: inputDecoration,
              ),
              const SizedBox(height: 10),
              const Text('Введите описание новой задачи'),
              TextField(
                controller: description,
                maxLines: 4,
                decoration: inputDecoration,
              ),
              const SizedBox(height: 10),
              const Text('Выбери ответственного за задачу'),
              AutoCompleteForUsers(state: state, id: id),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                tasksBloc.add(
                  AddTaskEvent(
                    author: state.currentUser!.displayName!,
                    description: description.text,
                    name: name.text,
                    responsibleID: id.text,
                  ),
                );
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.save,
                size: 50,
                color: Colors.blue,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.cancel,
                size: 50,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class AutoCompleteForUsers extends StatelessWidget {
  final TasksLoadedState state;
  final TextEditingController id;
  const AutoCompleteForUsers({
    required this.state,
    required this.id,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<UserBD>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<UserBD>.empty();
        }
        return state.allUsers.where((UserBD user) {
          return user.name
                  .toLowerCase()
                  .contains(textEditingValue.text.toLowerCase()) ||
              user.email
                  .toLowerCase()
                  .contains(textEditingValue.text.toLowerCase());
        });
      },
      displayStringForOption: (UserBD option) => option.id,
      onSelected: (UserBD selection) {
        id.text = selection.id;
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            child: SizedBox(
              width: double.infinity,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final UserBD user = options.elementAt(index);
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(user.name[0]),
                    ),
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    onTap: () => onSelected(user),
                  );
                },
              ),
            ),
          ),
        );
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: const InputDecoration(
            labelText: 'ID пользователя',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person),
            hintText: 'Начните вводить имя...',
          ),
          onChanged: (value) {
            id.text = value;
          },
          onSubmitted: (value) => onFieldSubmitted(),
        );
      },
    );
  }
}
