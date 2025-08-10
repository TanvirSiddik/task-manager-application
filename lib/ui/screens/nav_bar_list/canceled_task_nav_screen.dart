import 'package:flutter/material.dart';
import 'package:taskmanger_no_getx/data/models/task_model.dart';
import 'package:taskmanger_no_getx/data/network/network_caller.dart';
import 'package:taskmanger_no_getx/data/utils/api_config.dart';
import 'package:taskmanger_no_getx/ui/widget/task_card.dart';

class CanceledTaskNavScreen extends StatefulWidget {
  const CanceledTaskNavScreen({super.key});

  @override
  State<CanceledTaskNavScreen> createState() => _CanceledTaskNavScreenState();
}

class _CanceledTaskNavScreenState extends State<CanceledTaskNavScreen> {
  bool _isloading = false;
  List<TaskModel> canceledTaskList = [];
  @override
  Widget build(BuildContext context) {
    return _isloading
        ? Center(child: CircularProgressIndicator())
        : canceledTaskList.isEmpty
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
                  itemCount: canceledTaskList.length,
                  itemBuilder: (context, index) {
                    final task = canceledTaskList[index];
                    return TaskCard(
                      context: context,
                      taskType: TaskType.Canceled,
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
    setState(() {
      _isloading = true;
    });
    NetworkResponse response = await NetworkCaller.getRequest(
      url: ApiConfig.getCanceledTask,
    );
    if (response.isSuccess) {
      if (!context.mounted) return;

      setState(() {
        final List decodedTaskList = response.body['data'];
        canceledTaskList = decodedTaskList
            .map((toElement) => TaskModel.fromJson(toElement))
            .toList();
        _isloading = false;
      });
    }
  }

  @override
  void initState() {
    _loadTask();
    super.initState();
  }
}
