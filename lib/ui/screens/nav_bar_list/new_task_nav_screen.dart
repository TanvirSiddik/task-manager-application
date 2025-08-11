import 'package:flutter/material.dart';
import 'package:taskmanger_no_getx/data/models/task_model.dart';
import 'package:taskmanger_no_getx/data/network/network_caller.dart';
import 'package:taskmanger_no_getx/data/utils/api_config.dart';
import 'package:taskmanger_no_getx/ui/widget/task_card.dart';

class NewTaskNavScreen extends StatefulWidget {
  const NewTaskNavScreen({super.key});

  @override
  State<NewTaskNavScreen> createState() => _NewTaskNavScreenState();
}

class _NewTaskNavScreenState extends State<NewTaskNavScreen> {
  List<TaskModel> newTaskList = [];
  bool _isloading = false;

  @override
  void initState() {
    _loadTask();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (_isloading && newTaskList.isEmpty)
        ? Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: _loadTask,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: newTaskList.length,
                    itemBuilder: (context, index) {
                      final task = newTaskList[index];
                      return TaskCard(
                        context: context,
                        taskType: TaskType.New,
                        tasks: task,
                        voidCallback: _loadTask,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }

  Future<void> _loadTask() async {
    _isloading = true;
    if (!mounted) return;
    setState(() {});
    NetworkResponse response = await NetworkCaller.getRequest(
      url: ApiConfig.getNewTask,
    );
    if (response.isSuccess) {
      final List decodedTaskList = response.body['data'];
      if (!mounted) return;
      setState(() {});
      newTaskList = decodedTaskList
          .map((toElement) => TaskModel.fromJson(toElement))
          .toList();
      _isloading = false;
      if (!context.mounted) return;
      setState(() {});
    }
  }
}
