import 'package:flutter/material.dart';
import 'package:taskmanger_no_getx/controller/auth_controller.dart';
import 'package:taskmanger_no_getx/data/models/user_model.dart';
import 'package:taskmanger_no_getx/data/network/network_caller.dart';
import 'package:taskmanger_no_getx/data/utils/api_config.dart';
import 'package:taskmanger_no_getx/ui/screens/add_new_task_screen.dart';
import 'package:taskmanger_no_getx/ui/screens/edit_profile_screen.dart';
import 'package:taskmanger_no_getx/ui/screens/login_screen.dart';

class ConstAppBar extends StatefulWidget {
  final VoidCallback? voidCallback;
  static String name = '/const-app-bar';
  const ConstAppBar({super.key, this.voidCallback});

  @override
  State<ConstAppBar> createState() => _ConstAppBarState();
}

class _ConstAppBarState extends State<ConstAppBar> {
  UserModel? userDetails;
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
                userDetails?.fullName ?? AuthController.userModel!.fullName,
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              EditProfileScreen(voidCallback: _loadProfileDetails),
          settings: const RouteSettings(name: EditProfileScreen.name),
        ),
      );
    }
  }

  void _loadProfileDetails() async {
    if (!context.mounted) return;
    FocusScope.of(context).unfocus();
    NetworkResponse response = await NetworkCaller.getRequest(
      url: ApiConfig.profileDetails,
    );

    if (response.isSuccess && response.body['data'] != null) {
      final userJson = response.body['data'];

      if (userJson != null && userJson is List && userJson.first != null) {
        if (!mounted) return;
        setState(() {
          userDetails = UserModel.fromJson(userJson.first);
        });
      } else {
        userDetails = AuthController.userModel;
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }
}
