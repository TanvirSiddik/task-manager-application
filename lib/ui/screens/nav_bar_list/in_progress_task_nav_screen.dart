import 'package:flutter/material.dart';
import 'package:taskmanger_no_getx/ui/widget/task_card.dart';

class InProgressTaskNavScreen extends StatefulWidget {
  const InProgressTaskNavScreen({super.key});

  @override
  State<InProgressTaskNavScreen> createState() =>
      _InProgressTaskNavScreenState();
}

class _InProgressTaskNavScreenState extends State<InProgressTaskNavScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, indext) {
              return TaskCard(taskType: TaskType.progress);
            },
          ),
        ),
      ],
    );
  }
}
