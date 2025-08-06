import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:taskmanger_no_getx/controller/auth_controller.dart';
import 'package:taskmanger_no_getx/data/models/user_model.dart';
import 'package:taskmanger_no_getx/data/network/network_caller.dart';
import 'package:taskmanger_no_getx/data/utils/api_config.dart';
import 'package:taskmanger_no_getx/ui/screens/forget_password_screen.dart';
import 'package:taskmanger_no_getx/ui/screens/main_nav_bar_screen.dart';
import 'package:taskmanger_no_getx/ui/screens/signup_screen.dart';
import 'package:taskmanger_no_getx/ui/utils/validator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String name = 'login-screen';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _loginFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Get Started With',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 28),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: _emailController,
                  decoration: InputDecoration(hintText: 'Email'),
                  validator: (value) => _validateEmail(value!),
                ),

                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(hintText: 'Password'),
                  validator: (value) => _validatePassword(value),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () => _onSubmitButton(
                          _emailController.text.trim(),
                          _passwordController.text,
                        ),
                  child: isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Icon(Icons.arrow_forward_ios_rounded, size: 27),
                ),
                const SizedBox(height: 40),
                TextButton(
                  onPressed: _onTapForgetPasswordButton,
                  child: const Text('Forgot password?'),
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    text: 'Don\'t have account? ',
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: ' Sign up',
                        style: TextStyle(color: Colors.green),
                        recognizer: TapGestureRecognizer()
                          ..onTap = _signupScreenButton,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTapForgetPasswordButton() {
    Navigator.pushNamed(context, ForgetPasswordScreen.name);
  }

  void _signupScreenButton() {
    Navigator.pushNamed(context, SignupScreen.name);
  }

  void _onSubmitButton(String email, String password) async {
    if (!mounted) return;
    FocusScope.of(context).unfocus();
    if (_loginFormKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      final Map<String, dynamic> body = {"email": email, "password": password};
      final NetworkResponse response = await NetworkCaller.postRequest(
        url: ApiConfig.login,
        jsonBody: body,
      );
      try {
        if (response.isSuccess) {
          String token = response.body['token'];
          final userModel = UserModel.fromJson(response.body['data']);

          AuthController.saveUserData(token, userModel);
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, MainNavBarScreen.name);
          if (!mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(response.body['status'])));
        } else {
          if (!mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(response.body['data'])));
        }
      } catch (e) {
        debugPrint(e.toString());
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';

    if (Validator.validateMail(value)) {
      return 'Enter a valid mail';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'enter you\'re password';
    } else if (Validator.passValidator(value)) {
      return "Password lenght must be over 7";
    }
    return null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
