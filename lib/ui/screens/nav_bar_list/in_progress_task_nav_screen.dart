import 'package:flutter/material.dart';
import 'package:taskmanger_no_getx/data/models/task_model.dart';
import 'package:taskmanger_no_getx/data/network/network_caller.dart';
import 'package:taskmanger_no_getx/data/utils/api_config.dart';
import 'package:taskmanger_no_getx/ui/widget/task_card.dart';

class InProgressTaskNavScreen extends StatefulWidget {
  const InProgressTaskNavScreen({super.key});

  @override
  State<InProgressTaskNavScreen> createState() =>
      _InProgressTaskNavScreenState();
}

class _InProgressTaskNavScreenState extends State<InProgressTaskNavScreen> {
  List<TaskModel> progressTaskList = [];
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : progressTaskList.isEmpty
        ? Center(
            child: Text(
              'List is empty',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          )
        : Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: progressTaskList.length,
                  itemBuilder: (context, indext) {
                    final task = progressTaskList[indext];
                    return TaskCard(
                      context: context,
                      taskType: TaskType.Progress,
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
    _isLoading = true;
    setState(() {});
    NetworkResponse response = await NetworkCaller.getRequest(
      url: ApiConfig.getProgressTask,
    );
    if (response.isSuccess) {
      final List decodedTaskList = response.body['data'];
      if (!mounted) return;
      progressTaskList = decodedTaskList
          .map((toElement) => TaskModel.fromJson(toElement))
          .toList();
      _isLoading = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    _loadTask();
    super.initState();
  }
}
