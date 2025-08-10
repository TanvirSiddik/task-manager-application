import 'package:flutter/material.dart';
import 'package:taskmanger_no_getx/data/models/task_model.dart';
import 'package:taskmanger_no_getx/data/network/network_caller.dart';
import 'package:taskmanger_no_getx/data/utils/api_config.dart';
import 'package:taskmanger_no_getx/ui/widget/task_card.dart';

class CompletedTaskNavScreen extends StatefulWidget {
  const CompletedTaskNavScreen({super.key});

  @override
  State<CompletedTaskNavScreen> createState() => _CompletedTaskNavScreenState();
}

class _CompletedTaskNavScreenState extends State<CompletedTaskNavScreen> {
  List<TaskModel> completedTaskList = [];
  bool _isloading = false;
  @override
  Widget build(BuildContext context) {
    return _isloading
        ? Center(child: CircularProgressIndicator())
        : 
        completedTaskList.isEmpty
                  ? Center(
                      child: Text(
                        'List is empty',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    )
                  : 
        Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: completedTaskList.length,
                  itemBuilder: (context, index) {
                    final task = completedTaskList[index];
                    return TaskCard(
                      context: context,
                      taskType: TaskType.Completed,
                      tasks: task,
                      voidCallback: _loadTask,
                    );
                  },
                ),
              ),
            ],
          );
  }

  void _loadTask() async {
    _isloading = true;
    setState(() {});
    NetworkResponse response = await NetworkCaller.getRequest(
      url: ApiConfig.getCompletedTask,
    );
    if (response.isSuccess) {
      final List decodedTaskList = response.body['data'];
      if (!mounted) return;
      completedTaskList = decodedTaskList
          .map((toElement) => TaskModel.fromJson(toElement))
          .toList();
      _isloading = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    _loadTask();
    super.initState();
  }
}
