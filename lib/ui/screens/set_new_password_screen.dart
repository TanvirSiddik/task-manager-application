import 'package:flutter/material.dart';
import 'package:taskmanger_no_getx/data/network/network_caller.dart';
import 'package:taskmanger_no_getx/data/utils/api_config.dart';
import 'package:taskmanger_no_getx/ui/screens/login_screen.dart';
import 'package:taskmanger_no_getx/ui/utils/validator.dart';
import 'package:taskmanger_no_getx/ui/widget/have_account.dart';

class SetNewPasswordScreen extends StatefulWidget {
  final String userEmail;
  final String otp;
  const SetNewPasswordScreen({
    super.key,
    required this.userEmail,
    required this.otp,
  });
  static const String name = 'set-new-password-screen';
  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _setPasswordFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Form(
            key: _setPasswordFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Set New Password',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Minimum password lenght 8 character with latter and number combination',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _passwordController,
                  textInputAction: TextInputAction.next,
                  validator: (value) => _validatePassword(value),
                  decoration: InputDecoration(hintText: 'Password'),
                ),

                const SizedBox(height: 20),
                TextFormField(
                  controller: _confirmPasswordController,
                  validator: (value) => _validateSecondPassword(value),
                  decoration: InputDecoration(hintText: 'Confirm Password'),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _backToLoginScreenButton,
                  child: const Text('Confirm'),
                ),
                const SizedBox(height: 30),
                HaveAccount(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _backToLoginScreenButton() async {
    if (!mounted) return;
    FocusScope.of(context).unfocus();

    if (_setPasswordFormKey.currentState!.validate()) {
      final String userEmail = widget.userEmail;
      final String otp = widget.otp;
      final String password = _confirmPasswordController.text;
      Map<String, String> jsonBody = {
        "email": userEmail,
        "OTP": otp,
        "password": password,
      };

      NetworkResponse response = await NetworkCaller.postRequest(
        url: ApiConfig.recoverResetPassword,
        jsonBody: jsonBody,
      );
      if (response.isSuccess) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              response.body['data'],
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        );
        Navigator.pushNamedAndRemoveUntil(
          context,
          LoginScreen.name,
          (predicate) => false,
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(response.body['data'])));
      }
    }
  }

  String? _validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    } else if (Validator.passValidator(value)) {
      return 'Password Must be at least 6 character';
    }
    return null;
  }

  String? _validateSecondPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    } else if (Validator.passValidator(value)) {
      return 'Password Must be at least 6 character';
    } else if (value != _passwordController.text) {
      return 'Password does not match';
    }
    return null;
  }
}
