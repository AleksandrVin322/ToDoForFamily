import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../entity/task.dart';
import 'bloc/tasks_bloc.dart';

class TasksWithStatus extends StatelessWidget {
  final String status;
  final List<Task> tasks;

  const TasksWithStatus({
    required this.status,
    required this.tasks,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<Task> filteredTask =
        tasks.where((task) => task.status == status).toList();
    if (filteredTask.isEmpty) {
      return const Center(
        child: Text(
          'Нет задач',
          style: TextStyle(fontSize: 50),
        ),
      );
    } else {
      return GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        children: List.generate(filteredTask.length, (index) {
          return Padding(
            padding: const EdgeInsetsGeometry.all(5),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(color: Colors.black.withValues(alpha: 0.2)),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Padding(
                padding: const EdgeInsetsGeometry.all(10),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            filteredTask[index].name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Время создания: ${filteredTask[index].createTime}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Автор: ${filteredTask[index].author}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            filteredTask[index].description,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    (filteredTask[index].status == 'ready')
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () => context.read<TasksBloc>().add(
                                      ChangeStatusTaskEvent(
                                        status: 'done',
                                        idDoc: filteredTask[index].id,
                                      ),
                                    ),
                                icon: const Icon(Icons.done),
                              ),
                              IconButton(
                                onPressed: () => context.read<TasksBloc>().add(
                                      ChangeStatusTaskEvent(
                                        status: 'close',
                                        idDoc: filteredTask[index].id,
                                      ),
                                    ),
                                icon: const Icon(Icons.close),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          );
        }),
      );
    }
  }
}
