import 'dart:convert';
import 'package:http/http.dart';
import 'package:taskmanger_no_getx/controller/auth_controller.dart';

class NetworkResponse {
  final int statusCode;
  final bool isSuccess;
  final Map<String, dynamic> body;
  final String? errorMessage;

  NetworkResponse({
    required this.statusCode,
    required this.isSuccess,
    required this.body,
    this.errorMessage,
  });
}

class NetworkCaller {
  static Future<NetworkResponse> postRequest({
    required String url,
    required Map<String, dynamic> jsonBody,
  }) async {
    final Response response = await post(
      Uri.parse(url),
      body: jsonEncode(jsonBody),
      headers: {
        'token': AuthController.accessToken ?? '',
        'Content-Type': 'Application/Json',
      },
    );
    try {
      if (response.statusCode == 200) {
        final decodedBody = jsonDecode(response.body);
        return NetworkResponse(
          statusCode: 200,
          isSuccess: true,
          body: decodedBody,
        );
      } else {
        final Map<String, dynamic> errorBody = jsonDecode(response.body);
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
          body: errorBody,
          errorMessage: errorBody['status'],
        );
      }
    } catch (e) {
      return NetworkResponse(
        statusCode: -1,
        isSuccess: false,
        body: {'status': 'error', 'data': e.toString()},
      );
    }
  }

  static Future<NetworkResponse> getRequest({required String url}) async {
    final Uri uri = Uri.parse(url);
    final Response response = await get(
      uri,
      headers: {'Content-Type': 'Application/Json'},
    );
    if (response.statusCode == 200) {
      return NetworkResponse(
        statusCode: response.statusCode,
        isSuccess: true,
        body: jsonDecode(response.body),
      );
    } else {
      return NetworkResponse(
        statusCode: response.statusCode,
        isSuccess: false,
        body: jsonDecode(response.body),
      );
    }
  }
}
