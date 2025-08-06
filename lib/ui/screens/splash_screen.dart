import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:taskmanger_no_getx/controller/auth_controller.dart';
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
    if (await AuthController.isUserLoggedIn()) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, MainNavBarScreen.name);
    } else {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, LoginScreen.name);
    }
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
