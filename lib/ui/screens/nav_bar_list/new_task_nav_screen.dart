import 'package:flutter/material.dart';
import 'package:taskmanger_no_getx/ui/widget/task_card.dart';

class NewTaskNavScreen extends StatefulWidget {
  const NewTaskNavScreen({super.key});

  @override
  State<NewTaskNavScreen> createState() => _NewTaskNavScreenState();
}

class _NewTaskNavScreenState extends State<NewTaskNavScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return TaskCard(taskType: TaskType.newTask);
            },
          ),
        ),
      ],
    );
  }
}
