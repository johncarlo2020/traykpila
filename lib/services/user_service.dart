import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traykpila/constant.dart';
import 'package:traykpila/models/api.response.dart';
import 'package:traykpila/constant.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';

Future<ApiResponse> login (String email, String password) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.post(
      Uri.parse(loginUrl),
      headers: {'Accept': 'application/json'},
      body: {'email':email,'password':password}
    );
    switch(response.statusCode){
      case 200:
          apiResponse.data=User.fromJson(jsonDecode(response.body));
          break;
      case 422:
          final errors = jsonDecode(response.body)['errors'];
          apiResponse.error=errors[errors.keys.elementAt(0)][0];
          break;
      case 403:
          apiResponse.error=jsonDecode(response.body)['message'];
          break;
      default:
           apiResponse.error = somethingWentWrong;
           break;
    }
  } 
  catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}

Future<ApiResponse> register (String name,String email, String password) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.post(
      Uri.parse(registerUrl),
      headers: {'Accept': 'application/json'},
      body: {
        'email':email,
        'name':name,
        'password':password,
        'password_confirmation':password
        }
    );
    switch(response.statusCode){
      case 200:
          apiResponse.data=User.fromJson(jsonDecode(response.body));
          break;
      case 422:
          final errors = jsonDecode(response.body)['errors'];
          apiResponse.error=errors[errors.keys.elementAt(0)][0];
          break;
      default:
           apiResponse.error = somethingWentWrong;
           break;
    }
  } 
  catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}


Future<ApiResponse> getUserDetail () async {
  ApiResponse apiResponse = ApiResponse();

  try {
    String token = await getToken();
    final response = await http.post(
      Uri.parse(userUrl),
      headers: {
        'Accept': 'application/json',
        'Authorization':'Bearer $token'
        });

    switch(response.statusCode){
      case 200:
          apiResponse.data=User.fromJson(jsonDecode(response.body));
          break;
      case 401:
          apiResponse.error=unauthorized;
          break;
      default:
           apiResponse.error = somethingWentWrong;
           break;
    }
  } 
  catch (e) {
    apiResponse.error = serverError;
  }

  return apiResponse;
}

Future<String> getToken() async {
  SharedPreferences pref =  await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}

Future<int> getUserId() async {
  SharedPreferences pref =  await SharedPreferences.getInstance();
  return pref.getInt('userId') ?? 0;
}

Future<bool> logout() async {
  SharedPreferences pref =  await SharedPreferences.getInstance();
  return await pref.remove('token');
}


