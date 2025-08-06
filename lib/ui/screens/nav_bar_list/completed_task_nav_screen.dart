import 'package:flutter/material.dart';
import 'package:taskmanger_no_getx/ui/widget/task_card.dart';

class CompletedTaskNavScreen extends StatefulWidget {
  const CompletedTaskNavScreen({super.key});

  @override
  State<CompletedTaskNavScreen> createState() => _CompletedTaskNavScreenState();
}

class _CompletedTaskNavScreenState extends State<CompletedTaskNavScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return TaskCard(
                taskType: TaskType.completed,
                
              );
            },
          ),
        ),
      ],
    );
  }
}
