import 'package:flutter/material.dart';
import 'package:taskmanger_no_getx/ui/screens/add_new_task_screen.dart';
import 'package:taskmanger_no_getx/ui/screens/edit_profile_screen.dart';
import 'package:taskmanger_no_getx/ui/screens/forget_password_screen.dart';
import 'package:taskmanger_no_getx/ui/screens/login_screen.dart';
import 'package:taskmanger_no_getx/ui/screens/main_nav_bar_screen.dart';
import 'package:taskmanger_no_getx/ui/screens/pin_validation_screen.dart';
import 'package:taskmanger_no_getx/ui/screens/set_new_password_screen.dart';
import 'package:taskmanger_no_getx/ui/screens/signup_screen.dart';
import 'package:taskmanger_no_getx/ui/screens/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        textTheme: TextTheme(
          titleLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
        ),
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          hintStyle: TextStyle(color: Colors.grey),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            fixedSize: Size.fromWidth(double.maxFinite),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(10),
            ),
          ),
        ),
      ),
      initialRoute: SplashScreen.name,
      routes: {
        SplashScreen.name: (context) => SplashScreen(),
        LoginScreen.name: (context) => LoginScreen(),
        ForgetPasswordScreen.name: (context) => ForgetPasswordScreen(),
        PinValidationScreen.name: (context) => PinValidationScreen(),
        SetNewPasswordScreen.name: (context) => SetNewPasswordScreen(),
        SignupScreen.name: (context) => SignupScreen(),
        MainNavBarScreen.name: (context) => MainNavBarScreen(),
        AddNewTaskScreen.name: (context) => AddNewTaskScreen(),
        EditProfileScreen.name: (context) => EditProfileScreen(),
      },
    );
  }
}
