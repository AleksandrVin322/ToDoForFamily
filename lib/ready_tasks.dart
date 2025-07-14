import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'entity/task.dart';
import 'models/model_task.dart';

class Tasks extends StatelessWidget {
  final String status;
  const Tasks({required this.status, super.key});

  @override
  Widget build(BuildContext context) {
    final ModelTask model = context.watch<ModelTask>();
    final List<Task> filteredTask =
        model.tasks.where((task) => task.status == status).toList();
    return GridView.count(
      crossAxisSpacing: 2,
      mainAxisSpacing: 2,
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      children: List.generate(filteredTask.length, (index) {
        return Container(
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
          child: Column(
            children: [
              Text(filteredTask[index].id!),
              Text(filteredTask[index].createTime!),
              Text(filteredTask[index].name!),
              Text(filteredTask[index].status!),
              Text(filteredTask[index].description!),
            ],
          ),
        );
      }),
    );
  }
}
