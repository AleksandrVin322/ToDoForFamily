part of 'tasks_bloc.dart';

@immutable
abstract class TasksState {}

class TasksLoadingState extends TasksState {}

class TasksLoadedState extends TasksState {
  final int selectedIndex;
  final List<Task> tasks;
  final User? currentUser;
  final List<UserBD> allUsers;
  TasksLoadedState({
    this.selectedIndex = 0,
    this.tasks = const [],
    this.allUsers = const [],
    required this.currentUser,
  });
}

class TasksFailureState extends TasksState {}
