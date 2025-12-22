import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../domain/service/auth_service.dart';
import '../../../domain/service/firestore_service.dart';
import '../../../entity/family.dart';
import '../../../entity/task.dart';
import '../../../entity/user_bd.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final FirestoreService firestoreService;
  final AuthService authService;
  StreamSubscription<List<Task>>? _tasksSubscription;
  User? get currentUser => authService.currentUser;
  TasksBloc({
    required this.firestoreService,
    required this.authService,
  }) : super(TasksLoadingState()) {
    on<ChangeTasksStatusEvent>(_changeTasksStatusPage);
    on<LoadUserTasksEvent>(_loadUserTasks);
    on<TasksUpdatedEvent>(_tasksUpdated);
    on<AddTaskEvent>(_addTasks);
    on<ChangeStatusTaskEvent>(_updateStatusTasks);
    on<LoadUsersEvent>(_getUsers);
    on<TasksFailureEvent>(_failure);
  }

  void _failure(
    TasksFailureEvent event,
    Emitter<TasksState> emit,
  ) {
    emit(TasksFailureState());
  }

  void _changeTasksStatusPage(
    ChangeTasksStatusEvent event,
    Emitter<TasksState> emit,
  ) {
    if (state is TasksLoadedState) {
      final currentState = state as TasksLoadedState;
      emit(
        TasksLoadedState(
          selectedIndex: event.index,
          tasks: currentState.tasks,
          currentUser: currentUser,
          allUsers: currentState.allUsers,
        ),
      );
    }
  }

  void _getUsers(
    LoadUsersEvent event,
    Emitter<TasksState> emit,
  ) async {
    try {
      final user = authService.currentUser;
      final Family family = await firestoreService.getFamily(userId: user!.uid);
      final users =
          await firestoreService.getMembersFamily(familyId: family.id);
      if (state is TasksLoadedState) {
        final currentState = state as TasksLoadedState;
        emit(
          TasksLoadedState(
            selectedIndex: currentState.selectedIndex,
            tasks: currentState.tasks,
            currentUser: currentState.currentUser,
            allUsers: users,
          ),
        );
      }
    } catch (error) {
      emit(TasksFailureState());
    }
  }

  void _loadUserTasks(
    LoadUserTasksEvent event,
    Emitter<TasksState> emit,
  ) async {
    try {
      await _tasksSubscription?.cancel();
      _tasksSubscription =
          firestoreService.getUserTasks(userId: event.userId).listen((tasks) {
        add(TasksUpdatedEvent(tasks));
      });
    } catch (error) {
      emit(TasksFailureState());
    }
  }

  void _tasksUpdated(
    TasksUpdatedEvent event,
    Emitter<TasksState> emit,
  ) {
    if (state is TasksLoadedState) {
      final currentState = state as TasksLoadedState;
      emit(
        TasksLoadedState(
          selectedIndex: currentState.selectedIndex,
          tasks: event.tasks,
          currentUser: currentUser,
          allUsers: currentState.allUsers,
        ),
      );
    } else {
      emit(
        TasksLoadedState(
          tasks: event.tasks,
          currentUser: currentUser,
        ),
      );
    }
  }

  void _addTasks(
    AddTaskEvent event,
    Emitter<TasksState> emit,
  ) async {
    final name =
        (event.name.trim().isNotEmpty) ? event.name.trim() : 'Без названия';
    final description = (event.description.trim().isNotEmpty)
        ? event.description.trim()
        : 'Без описания';
    try {
      await firestoreService.addTask(
        name: name,
        description: description,
        author: event.author,
        responsibleID: event.responsibleID,
      );
    } catch (error) {
      emit(TasksFailureState());
    }
  }

  void _updateStatusTasks(
    ChangeStatusTaskEvent event,
    Emitter<TasksState> emit,
  ) async {
    try {
      await firestoreService.updateStatusTask(
        idDoc: event.idDoc,
        status: event.status,
      );
    } catch (error) {
      emit(TasksFailureState());
    }
  }

  @override
  Future<void> close() {
    _tasksSubscription?.cancel();
    return super.close();
  }
}
