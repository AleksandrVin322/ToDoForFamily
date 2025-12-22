part of 'tasks_bloc.dart';

@immutable
abstract class TasksEvent {}

class ChangeTasksStatusEvent extends TasksEvent {
  final int index;
  ChangeTasksStatusEvent(this.index);
}

class LoadingStateEvent extends TasksEvent {}

class LoadUserTasksEvent extends TasksEvent {
  final String userId;
  LoadUserTasksEvent(this.userId);
}

class TasksUpdatedEvent extends TasksEvent {
  final List<Task> tasks;
  TasksUpdatedEvent(this.tasks);
}

class AddTaskEvent extends TasksEvent {
  final String name;
  final String description;
  final String author;
  final String responsibleID;

  AddTaskEvent({
    required this.name,
    required this.description,
    required this.author,
    required this.responsibleID,
  });
}

class ChangeStatusTaskEvent extends TasksEvent {
  final String status;
  final String idDoc;
  ChangeStatusTaskEvent({
    required this.status,
    required this.idDoc,
  });
}

class LoadUsersEvent extends TasksEvent {}

class TasksFailureEvent extends TasksEvent {}
