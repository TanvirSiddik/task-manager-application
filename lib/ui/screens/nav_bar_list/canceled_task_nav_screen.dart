import 'package:flutter/material.dart';
import 'package:taskmanger_no_getx/ui/widget/task_card.dart';

class CanceledTaskNavScreen extends StatefulWidget {
  const CanceledTaskNavScreen({super.key});

  @override
  State<CanceledTaskNavScreen> createState() => _CanceledTaskNavScreenState();
}

class _CanceledTaskNavScreenState extends State<CanceledTaskNavScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return TaskCard(
                taskType: TaskType.canceled,
                
              );
            },
          ),
        ),
      ],
    );
  }
}
