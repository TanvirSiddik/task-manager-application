import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:taskmanger_no_getx/data/network/network_caller.dart';
import 'package:taskmanger_no_getx/data/utils/api_config.dart';
import 'package:taskmanger_no_getx/ui/screens/set_new_password_screen.dart';
import 'package:taskmanger_no_getx/ui/utils/validator.dart';
import 'package:taskmanger_no_getx/ui/widget/have_account.dart';

class PinValidationScreen extends StatefulWidget {
  const PinValidationScreen({super.key, required this.userEmail});
  static const String name = 'pin-verification-screen';
  final String userEmail;

  @override
  State<PinValidationScreen> createState() => _PinValidationScreenState();
}

class _PinValidationScreenState extends State<PinValidationScreen> {
  final TextEditingController _pinValidationController =
      TextEditingController();
  final GlobalKey<FormState> _pinValidationFormKey = GlobalKey<FormState>();
  int _counter = 0;
  // Routing
  @override
  Widget build(BuildContext context) {
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
                onPressed: () => _nextScreenButton(),
                child: const Text('Verify'),
              ),
              const SizedBox(height: 30),
              HaveAccount(),
              const SizedBox(height: 30),
              TextButton(
                onPressed: _counter == 1 ? null : _getOtpAgain,
                child: const Text('didn\'t receive code?'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _nextScreenButton() async {
    if (!mounted) return;
    FocusScope.of(context).unfocus();
    if (_pinValidationFormKey.currentState!.validate()) {
      final otp = _pinValidationController.text.trim();
      final userEmail = widget.userEmail;
      NetworkResponse response = await NetworkCaller.getRequest(
        url: ApiConfig.recoverVerifyOtp(userEmail, otp),
      );
      if (response.isSuccess) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(response.body['data'])));
        Navigator.push(context, MaterialPageRoute(builder: (context) => SetNewPasswordScreen(userEmail: userEmail, otp: otp)));
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(response.body['data'])));
      }
    }
  }

  _validatePin(String? value) {
    if (value == null || value.trim().isEmpty) {
    } else if (Validator.pinValidator(value)) {
      return null;
    }
  }

  void _getOtpAgain() async {
    if (!mounted) return;
    FocusScope.of(context).unfocus();
    NetworkResponse response = await NetworkCaller.getRequest(
      url: ApiConfig.recoverVerifyEmail(widget.userEmail),
    );
    if (response.isSuccess) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('otp was sent again to ${widget.userEmail}')),
      );
      if (!mounted) return;
      _counter++;
      setState(() {});
    }
  }
}
