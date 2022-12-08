import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traykpila/constant.dart';
import 'package:traykpila/models/api.response.dart';
import 'package:traykpila/constant.dart';
import 'package:http/http.dart' as http;
import 'package:traykpila/models/terminal.dart';
import 'dart:convert';

import '../models/user.dart';

Future<bool> addImage(Map<String, String> body, String filepath) async {
  Map<String, String> headers = {
    'Content-Type': 'multipart/form-data',
  };
  var request = http.MultipartRequest('POST', Uri.parse(terminalCreate))
    ..fields.addAll(body)
    ..headers.addAll(headers)
    ..files.add(await http.MultipartFile.fromPath('image', filepath));
  var response = await request.send();
  if (response.statusCode == 201) {
    return true;
  } else {
    return false;
  }
}

Future<bool> addTricycle(Map<String, String> body, String filepath) async {
  Map<String, String> headers = {
    'Content-Type': 'multipart/form-data',
  };
  var request = http.MultipartRequest('POST', Uri.parse(tricycleCreate))
    ..fields.addAll(body)
    ..headers.addAll(headers)
    ..files.add(await http.MultipartFile.fromPath('image', filepath));
  var response = await request.send();
  print(response.statusCode);
  if (response.statusCode == 201) {
    return true;
  } else {
    return false;
  }
}

Future<ApiResponse> login(String email, String password) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.post(Uri.parse(loginUrl),
        headers: {'Accept': 'application/json'},
        body: {'email': email, 'password': password});
    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}


// ignore: non_constant_identifier_names
Future<ApiResponse> register(String name, String email, String password,
    String role, String address) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.post(Uri.parse(registerUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      'email': email,
      'name': name,
      'address': address,
      'password': password,
      'password_confirmation': password,
      'role': role
    });
    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      default:
        final errors = jsonDecode(response.body);
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}

Future<ApiResponse> getUserDetail() async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();
    final response = await http.post(Uri.parse(userUrl), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}

Future<int> getTerminalCount() async {
  String token = await getToken();
  final response = await http.post(Uri.parse(terminalCount), headers: {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  });
  Map<String, dynamic> data =
      Map<String, dynamic>.from(json.decode(response.body));

  return data['count'];
}

Future<int> getUserCount() async {
  String token = await getToken();
  final response = await http.post(Uri.parse(userCount), headers: {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  });
  Map<String, dynamic> data =
      Map<String, dynamic>.from(json.decode(response.body));

  return data['count'];
}

Future<int> getDriverCount() async {
  String token = await getToken();
  final response = await http.post(Uri.parse(driverCount), headers: {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  });
  Map<String, dynamic> data =
      Map<String, dynamic>.from(json.decode(response.body));

  return data['count'];
}

Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}

Future<String> getRoleLogin() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('role') ?? '';
}

Future<int> getUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('userId') ?? 0;
}

Future<bool> logout() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return await pref.remove('token');
}

Future<String> getRole() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return await pref.getString('userRole') ?? '';
}
