import 'package:flutter/material.dart';
import 'package:taskmanger_no_getx/data/network/network_caller.dart';
import 'package:taskmanger_no_getx/data/utils/api_config.dart';
import 'package:taskmanger_no_getx/ui/widget/cons_app_bar.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});
  static const String name = '/add-new-task-screen';
  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _taskSubjectController = TextEditingController();
  final TextEditingController _taskDescriptionController =
      TextEditingController();
  final GlobalKey<FormState> _newTaskFormKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: ConstAppBar(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _newTaskFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add New Task',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _taskSubjectController,
                decoration: InputDecoration(hintText: 'Subject'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Subject is required';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _taskDescriptionController,
                decoration: InputDecoration(hintText: 'Description'),
                maxLines: 7,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Description is required';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitNewTaskButton,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.arrow_forward_ios_rounded, size: 27),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitNewTaskButton() async {
    _isLoading = true;
    if (!mounted) return;
    setState(() {});
    FocusScope.of(context).unfocus();
    if (_newTaskFormKey.currentState!.validate()) {
      Map<String, dynamic> jsonBody = {
        "title": _taskSubjectController.text.trim(),
        "description": _taskDescriptionController.text.trim(),
        "status": "New",
      };
      NetworkResponse response = await NetworkCaller.postRequest(
        url: ApiConfig.createTask,
        jsonBody: jsonBody,
      );
      if (response.isSuccess) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(response.body['status'])));
        _isLoading = false;
        if (!mounted) return;
        setState(() {});
        Navigator.pop(context);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(response.body['status'])));
      }
    }
  }
}
