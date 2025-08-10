import 'package:flutter/material.dart';
import 'package:taskmanger_no_getx/data/models/task_model.dart';
import 'package:taskmanger_no_getx/data/network/network_caller.dart';
import 'package:taskmanger_no_getx/data/utils/api_config.dart';

// ignore: constant_identifier_names
enum TaskType { New, Completed, Canceled, Progress }

class TaskCard extends StatelessWidget {
  final TaskType taskType;

  final TaskModel tasks;
  final VoidCallback voidCallback;
  final BuildContext context;
  const TaskCard({
    required this.context,
    required this.taskType,
    required this.tasks,
    required this.voidCallback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tasks.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Text(
              tasks.description,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              tasks.createdDate,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Chip(
                  backgroundColor: _getChipColor(),

                  shape: RoundedRectangleBorder(
                    side: BorderSide.none,
                    borderRadius: BorderRadiusGeometry.circular(10),
                  ),
                  label: Text(
                    _getChipLabelName(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const Spacer(),
                (tasks.status == 'Completed' || tasks.status == 'Canceled')
                    ? const SizedBox()
                    : PopupMenuButton(
                        onSelected: (value) => _changeTaskStatus(value),
                        itemBuilder: (context) {
                          if (tasks.status == 'New') {
                            return [
                              PopupMenuItem(
                                value: 'Canceled',
                                child: const Text('Canceled'),
                              ),
                              PopupMenuItem(
                                value: 'Progress',
                                child: const Text('Progress'),
                              ),
                            ];
                          }
                          if (tasks.status == 'Progress') {
                            return [
                              PopupMenuItem(
                                value: 'Completed',
                                child: const Text('Completed'),
                              ),
                              PopupMenuItem(
                                value: 'Canceled',
                                child: const Text('Canceled'),
                              ),
                            ];
                          }
                          return [];
                        },
                      ),
                IconButton(
                  onPressed: () => _deleteTask(tasks.id, context),
                  icon: const Icon(
                    Icons.delete_forever_rounded,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getChipColor() {
    switch (taskType) {
      case TaskType.New:
        return Colors.purple;

      case TaskType.Completed:
        return Colors.green;

      case TaskType.Canceled:
        return Colors.red;

      case TaskType.Progress:
        return Colors.blue;
    }
  }

  String _getChipLabelName() {
    switch (taskType) {
      case TaskType.New:
        return 'New Task';
      case TaskType.Completed:
        return 'Completed';
      case TaskType.Canceled:
        return 'Canceled';
      case TaskType.Progress:
        return 'Progress';
    }
  }

  void _deleteTask(String id, BuildContext context) async {
    NetworkResponse response = await NetworkCaller.getRequest(
      url: ApiConfig.deleteTask(id),
    );
    if (response.isSuccess) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response.body['status'])));
      voidCallback.call();
    }
  }

  void _changeTaskStatus(Object? newStatus) async {
    final taskId = tasks.id;
    debugPrint(taskId);
    debugPrint(newStatus.toString());
    NetworkResponse response = await NetworkCaller.getRequest(
      url: ApiConfig.updateTaskStatus(taskId, newStatus!.toString()),
    );
    if (response.isSuccess) {
      voidCallback.call();
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Something went wrong')));
    }
  }
}
