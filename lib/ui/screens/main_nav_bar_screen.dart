import 'package:flutter/material.dart';
import 'package:taskmanger_no_getx/data/models/task_status_count_model.dart';
import 'package:taskmanger_no_getx/data/network/network_caller.dart';
import 'package:taskmanger_no_getx/data/utils/api_config.dart';
import 'package:taskmanger_no_getx/ui/screens/add_new_task_screen.dart';
import 'package:taskmanger_no_getx/ui/screens/nav_bar_list/canceled_task_nav_screen.dart';
import 'package:taskmanger_no_getx/ui/screens/nav_bar_list/completed_task_nav_screen.dart';
import 'package:taskmanger_no_getx/ui/screens/nav_bar_list/in_progress_task_nav_screen.dart';
import 'package:taskmanger_no_getx/ui/screens/nav_bar_list/new_task_nav_screen.dart';
import 'package:taskmanger_no_getx/ui/widget/cons_app_bar.dart';

class MainNavBarScreen extends StatefulWidget {
  const MainNavBarScreen({super.key});
  static const String name = '/main-nav-bar-screen';
  @override
  State<MainNavBarScreen> createState() => _MainNavBarScreenState();
}

class _MainNavBarScreenState extends State<MainNavBarScreen> {
  final List<Widget> _naviList = [
    NewTaskNavScreen(),
    CompletedTaskNavScreen(),
    CanceledTaskNavScreen(),
    InProgressTaskNavScreen(),
  ];
  int _selectedIndex = 0;
  List<TaskStatusCountModel> taskCount = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: ConstAppBar(),
      ),
      body: _naviList[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.add_task_rounded),
            label: 'New Task',
          ),
          NavigationDestination(icon: Icon(Icons.task_alt), label: 'Completed'),
          NavigationDestination(
            icon: Icon(Icons.cancel_outlined),
            label: 'Canceled',
          ),
          NavigationDestination(
            icon: Icon(Icons.access_time),
            label: 'Progress',
          ),
        ],
        selectedIndex: _selectedIndex,
        onDestinationSelected: (value) {
          _selectedIndex = value;
          setState(() {});
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewTaskButtton,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addNewTaskButtton() {
    Navigator.pushNamed(context, AddNewTaskScreen.name);
  }

  void _loadTaskCount() async {
    NetworkResponse response = await NetworkCaller.getRequest(
      url: ApiConfig.taskStatusCount,
    );
    if (response.isSuccess) {
      final List decodedBody = response.body['data'];
      taskCount = decodedBody
          .map((toElement) => TaskStatusCountModel.fromJson(toElement))
          .toList();
      setState(() {});
    }
  }

  @override
  void initState() {
    _loadTaskCount();
    super.initState();
  }
}
