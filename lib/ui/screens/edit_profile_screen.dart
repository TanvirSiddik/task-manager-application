import 'package:flutter/material.dart';
import 'package:taskmanger_no_getx/controller/auth_controller.dart';
import 'package:taskmanger_no_getx/data/models/user_model.dart';
import 'package:taskmanger_no_getx/data/network/network_caller.dart';
import 'package:taskmanger_no_getx/data/utils/api_config.dart';
import 'package:taskmanger_no_getx/ui/utils/validator.dart';
import 'package:taskmanger_no_getx/ui/widget/cons_app_bar.dart';

class EditProfileScreen extends StatefulWidget {
  final VoidCallback? voidCallback;
  const EditProfileScreen({super.key, this.voidCallback});
  static const String name = '/edit-profile-screen';

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _emailController = TextEditingController(
    text: AuthController.userModel!.email,
  );
  final TextEditingController _firsNameController = TextEditingController(
    text: AuthController.userModel!.firstName,
  );
  final TextEditingController _lastNameController = TextEditingController(
    text: AuthController.userModel!.lastName,
  );
  final TextEditingController _phoneNumberController = TextEditingController(
    text: AuthController.userModel!.mobile,
  );
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _profileUpdateFormKey = GlobalKey<FormState>();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: ConstAppBar(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _profileUpdateFormKey,
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Update Profile',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    enabled: false,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    decoration: InputDecoration(hintText: 'Email'),
                    validator: (value) => _validateEmail(value),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _firsNameController,
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
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submitEditButton,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.arrow_forward_ios_rounded),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitEditButton() async {
    if (mounted) {
      _isLoading = true;
      setState(() {});
    }

    FocusScope.of(context).unfocus();
    if (_profileUpdateFormKey.currentState!.validate()) {
      final jsonBody = UserModel(
        email: _emailController.text.trim(),
        firstName: _firsNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        mobile: _phoneNumberController.text.trim(),
        password: _passwordController.text.isEmpty
            ? AuthController.userModel!.password
            : _passwordController.text,
      );

      NetworkResponse response = await NetworkCaller.postRequest(
        url: ApiConfig.update,
        jsonBody: jsonBody.toJson(),
      );
      if (response.isSuccess) {
        AuthController.setUserDetails(jsonBody);
        if (!mounted) return;
        _isLoading = false;
        setState(() {});
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(response.statusCode.toString())));
        Navigator.pop(context);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(response.statusCode.toString())));
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
