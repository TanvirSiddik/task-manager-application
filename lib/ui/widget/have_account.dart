import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:taskmanger_no_getx/ui/screens/login_screen.dart';

class HaveAccount extends StatefulWidget {
  const HaveAccount({super.key});

  @override
  State<HaveAccount> createState() => _HaveAccountState();
}

class _HaveAccountState extends State<HaveAccount> {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'Have acount? ',
        style: const TextStyle(color: Colors.black),
        children: [
          TextSpan(
            text: ' Sign in',
            style: const TextStyle(color: Colors.green),
            recognizer: TapGestureRecognizer()..onTap = _redirectToLoginScreen,
          ),
        ],
      ),
    );
  }

  void _redirectToLoginScreen() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      LoginScreen.name,
      (predicate) => false,
    );
  }
}
