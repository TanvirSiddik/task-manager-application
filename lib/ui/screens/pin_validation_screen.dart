import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:taskmanger_no_getx/ui/screens/forget_password_screen.dart';
import 'package:taskmanger_no_getx/ui/screens/login_screen.dart';
import 'package:taskmanger_no_getx/ui/screens/set_new_password_screen.dart';
import 'package:taskmanger_no_getx/ui/screens/signup_screen.dart';
import 'package:taskmanger_no_getx/ui/utils/validator.dart';
import 'package:taskmanger_no_getx/ui/widget/have_account.dart';

class PinValidationScreen extends StatefulWidget {
  const PinValidationScreen({super.key});
  static const String name = 'pin-verification-screen';

  @override
  State<PinValidationScreen> createState() => _PinValidationScreenState();
}

class _PinValidationScreenState extends State<PinValidationScreen> {
  final TextEditingController _pinValidationController =
      TextEditingController();
  final GlobalKey<FormState> _pinValidationFormKey = GlobalKey<FormState>();

  // Routing
  @override
  Widget build(BuildContext context) {
    final Map<String, String> args =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    final String flow =
        args['flow'] ?? SignupScreen.name; // default to signup-screen

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Pin Verification',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Text(
                'A 6 digit verification pin has been sent to your email address',
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 30),
              Form(
                key: _pinValidationFormKey,
                child: Pinput(
                  controller: _pinValidationController,
                  validator: (value) => _validatePin(value),

                  length: 6,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _nextScreenButton(flow),
                child: const Text('Verify'),
              ),
              const SizedBox(height: 30),
              HaveAccount(),
            ],
          ),
        ),
      ),
    );
  }

  void _nextScreenButton(String flow) {
    if (_pinValidationFormKey.currentState!.validate()) {
      if (flow == SignupScreen.name) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          LoginScreen.name,
          (predicate) => false,
        );
      } else if (flow == ForgetPasswordScreen.name) {
        Navigator.pushNamed(context, SetNewPasswordScreen.name);
      }
    }
  }

  _validatePin(String? value) {
    if (value == null || value.trim().isEmpty) {
    } else if (Validator.pinValidator(value)) {
      return null;
    }
  }
}
