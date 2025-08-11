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
    
    userModel = user;
    accessToken = token;
    await sharedPreferences.setString(_userDetails, jsonEncode(user.toJson()));
    await sharedPreferences.setString(_token, token);

  }

  static Future<void> setUserDetails(UserModel user) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    userModel = user;
    await sharedPreferences.setString(_userDetails, jsonEncode(user.toJson()));
  }

  // Get user data
  static Future<void> getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    final userJson = sharedPreferences.getString(_userDetails);
    final userToken = sharedPreferences.getString(_token);

    if (userJson != null && userToken != null) {
      accessToken = userToken;
      userModel = UserModel.fromJson(jsonDecode((userJson)));
    }
  }

  static Future<bool> isUserLoggedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(_token);
    String? userJson = sharedPreferences.getString(_userDetails);
    if (token != null && userJson != null) {
      accessToken = token;
      userModel = UserModel.fromJson(jsonDecode(userJson));
      return true;
    } else {
      return false;
    }
  }

  static Future<void> clearUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    userModel = null;
    accessToken = null;
  }
}
