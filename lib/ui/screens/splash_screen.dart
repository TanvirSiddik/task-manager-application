import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:taskmanger_no_getx/controller/auth_controller.dart';
import 'package:taskmanger_no_getx/data/network/network_caller.dart';
import 'package:taskmanger_no_getx/data/utils/api_config.dart';
import 'package:taskmanger_no_getx/ui/screens/login_screen.dart';
import 'package:taskmanger_no_getx/ui/screens/main_nav_bar_screen.dart';

import 'package:taskmanger_no_getx/ui/utils/asset_paths.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String name = '/splash-screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _leaveSplashScreen() async {
    await Future.delayed(Duration(seconds: 2));
    if (!mounted) return;
    if (await AuthController.isUserLoggedIn() && await _userAuthStatus()) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, MainNavBarScreen.name);
    } else {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, LoginScreen.name);
    }
  }

  Future<bool> _userAuthStatus() async {
    NetworkResponse response = await NetworkCaller.getRequest(
      url: ApiConfig.profileDetails,
    );
    if (response.body['status'] == 'unauthorized') {
      await AuthController.clearUserData();
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    _leaveSplashScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(child: SvgPicture.asset(AssetPaths.logoPath)),
      ),
    );
  }
}
