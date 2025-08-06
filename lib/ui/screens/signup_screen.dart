import 'package:flutter/material.dart';
import 'package:taskmanger_no_getx/data/network/network_caller.dart';
import 'package:taskmanger_no_getx/data/utils/api_config.dart';
import 'package:taskmanger_no_getx/ui/utils/validator.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  static const String name = '/signup-screen';

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firsNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _signUpFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Join With Us',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _emailController,

                      validator: (value) => _validateEmail(value),
                      decoration: InputDecoration(hintText: 'Email'),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _firsNameController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(hintText: 'First Name'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter you\'re first name';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _lastNameController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(hintText: 'Last Name'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter you\'re last name';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _phoneNumberController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(hintText: 'Mobile No.'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Phone number is required';
                        } else if (value.length < 10 || value.length > 11) {
                          return 'Valid phone number';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(hintText: 'Password'),
                      textInputAction: TextInputAction.done,
                      validator: (value) => _validatePassword(value),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _userSubmissionButton,
                      child: const Icon(Icons.arrow_forward_ios_rounded),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _userSubmissionButton() async {
    FocusScope.of(context).unfocus();
    if (_signUpFormKey.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      Map<String, dynamic> jsonBody = {
        "email": _emailController.text.trim(),
        "firstName": _firsNameController.text.trim(),
        "lastName": _lastNameController.text.trim(),
        "mobile": _phoneNumberController.text.trim(),
        "password": _passwordController.text,
      };
      NetworkResponse response = await NetworkCaller.postRequest(
        url: ApiConfig.registration,
        jsonBody: jsonBody,
      );

      try {
        if (response.statusCode == 200) {
          if (!mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(response.body['status'])));
          Navigator.pop(context);
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(response.body['data'])));
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.errorMessage.toString())),
        );
      } finally {
        isLoading = false;
      }
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    } else if (Validator.validateMail(value)) {
      return 'Enter a valid email';
    } else {
      return null;
    }
  }

  String? _validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password is required';
    } else if (Validator.passValidator(value)) {
      return 'Password lenght must be over 6';
    } else {
      return null;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firsNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
