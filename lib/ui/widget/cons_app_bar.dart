import 'package:flutter/material.dart';
import 'package:taskmanger_no_getx/controller/auth_controller.dart';
import 'package:taskmanger_no_getx/ui/screens/add_new_task_screen.dart';
import 'package:taskmanger_no_getx/ui/screens/edit_profile_screen.dart';
import 'package:taskmanger_no_getx/ui/screens/login_screen.dart';

class ConstAppBar extends StatefulWidget {
  const ConstAppBar({super.key});

  @override
  State<ConstAppBar> createState() => _ConstAppBarState();
}

class _ConstAppBarState extends State<ConstAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green,
      title: Row(
        children: [
          GestureDetector(
            onTap: () => _editProfileButton(context),
            child: CircleAvatar(radius: 26),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AuthController.userModel!.firstName,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.white),
              ),
              Text(
                AuthController.userModel!.email,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
      actions: [
        (ModalRoute.of(context)!.settings.name == EditProfileScreen.name) ||
                (ModalRoute.of(context)!.settings.name == AddNewTaskScreen.name)
            ? const SizedBox()
            : IconButton(
                onPressed: () => _logoutButton(context),
                icon: const Icon(Icons.logout_rounded),
              ),
      ],
    );
  }

  void _logoutButton(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout?'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                AuthController.clearUserData();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  LoginScreen.name,
                  (predicate) => false,
                );
              },
              child: const Text(
                'Proceed',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  void _editProfileButton(BuildContext context) {
    if (ModalRoute.of(context)!.settings.name != EditProfileScreen.name) {
      Navigator.pushNamed(context, EditProfileScreen.name);
    }
  }

  @override
  void initState() {
    super.initState();
  }
}
