import 'package:flutter/material.dart';
import 'package:taskmanger_no_getx/data/network/network_caller.dart';
import 'package:taskmanger_no_getx/data/utils/api_config.dart';
import 'package:taskmanger_no_getx/ui/screens/pin_validation_screen.dart';
import 'package:taskmanger_no_getx/ui/utils/validator.dart';
import 'package:taskmanger_no_getx/ui/widget/have_account.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});
  static const String name = 'forget-password-screen';
  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _emailSubmissionFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _emailSubmissionFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Your Email Address',

                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'A 6 digit verification code will be sent to your email address',
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(hintText: 'Email'),
                  validator: (value) => _validateEmail(value),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _pinVerificationScreenButton,
                  child: Icon(Icons.arrow_forward_ios_rounded, size: 27),
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

  void _pinVerificationScreenButton() async {
    if (!mounted) return;
    FocusScope.of(context).unfocus();
    if (_emailSubmissionFormKey.currentState!.validate()) {
      final userEmail = _emailController.text.trim();
      NetworkResponse response = await NetworkCaller.getRequest(
        url: ApiConfig.recoverVerifyEmail(userEmail),
      );
      if (response.isSuccess) {
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PinValidationScreen(userEmail: userEmail),
          ),
        );
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(response.body['data'])));
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    } else if (Validator.validateMail(value)) {
      return 'Enter a valid mail';
    } else {
      return null;
    }
  }
}
