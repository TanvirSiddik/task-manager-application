import 'package:flutter/material.dart';

enum TaskType { newTask, completed, canceled, progress }

class TaskCard extends StatelessWidget {
  final TaskType taskType;
  const TaskCard({required this.taskType, super.key});

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
              'This is were the short description',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Text(
              'this is where i\'ll describe the problem in details and might give some advice for me ',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Date: 20/12/12',
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
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.edit, color: Colors.blue),
                ),
                IconButton(
                  onPressed: () {},
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
      case TaskType.newTask:
        return Colors.purple;

      case TaskType.completed:
        return Colors.green;

      case TaskType.canceled:
        return Colors.red;

      case TaskType.progress:
        return Colors.blue;
    }
  }

  String _getChipLabelName() {
    switch (taskType) {
      case TaskType.newTask:
        return 'New Task';
      case TaskType.completed:
        return 'Completed';
      case TaskType.canceled:
        return 'Canceled';
      case TaskType.progress:
        return 'Canceled';
    }
  }
}
