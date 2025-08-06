import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/user_model.dart';

class AuthController {
  static const String _userDetails = 'user-details';
  static const String _token = 'token';

  static UserModel? userModel;
  static String? accessToken;

  static Future<void> saveUserData(String token, UserModel user) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_token, token);
    await sharedPreferences.setString(_userDetails, jsonEncode(user.toJson()));

    userModel = user;
    accessToken = token;
  }

  // Get user data
  static Future<void> getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    accessToken = sharedPreferences.getString(_token);
    userModel = UserModel.fromJson(
      jsonDecode((sharedPreferences.getString(_userDetails))!),
    );
  }

  static Future<bool> isUserLoggedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(_token);
    if (token != null) {
      await getUserData();
      return true;
    } else {
      return false;
    }
  }
  // clear user data

  static Future<void> clearUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
    accessToken = null;
    userModel = null;
  }
}
