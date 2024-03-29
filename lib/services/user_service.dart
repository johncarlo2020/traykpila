import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traykpila/constant.dart';
import 'package:traykpila/models/api.response.dart';
import 'package:traykpila/constant.dart';
import 'package:http/http.dart' as http;
import 'package:traykpila/models/terminal.dart';
import 'dart:convert';

import '../models/user.dart';
import '../models/booking.dart';


Future<ApiResponse> TerminalAdd(String name,String address,String lat,String lng, String? image) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(Uri.parse(terminalCreateNew),
    headers: {
      'Accept': 'application/json',
    }, body:  {
      'name': name,
      'address': address,
      'lat': lat,
      'lng': lng,
      'image': image
    } );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch (e){
    apiResponse.error = serverError;
  }
  return apiResponse;
}

Future<ApiResponse> addTricycle(String name,String plate_number,String body_number,String max_passenger,String user_id, String? image) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(Uri.parse(tricycleCreateNew),
    headers: {
      'Accept': 'application/json',
    }, body:  {
      'name': name,
      'plate_number': plate_number,
      'body_number': body_number,
      'max_passenger': max_passenger,
      'user_id': user_id,
      'image': image
    } );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch (e){
    apiResponse.error = serverError;
  }
  return apiResponse;
}

String? getStringImage(File? file) {
  if (file == null) return null ;
  return base64Encode(file.readAsBytesSync());
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
        case 429:
        apiResponse.error ='Too MAny Request';
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

Future<ApiResponse> active_driver(String user_id, String terminal_id, String tricycle_id, String active) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.post(Uri.parse(activeDriver),
        headers: {'Accept': 'application/json'},
        body: {
          'user_id': user_id, 
          'terminal_id': terminal_id,
          'tricycle_id': tricycle_id,
          'active': active
          });

    switch (response.statusCode) {
      case 200:
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 429:;
        apiResponse.error = 'Too Many Request';
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    print(e.toString());
    apiResponse.error = serverError;
  }
  return apiResponse;
}

Future<ApiResponse> passengerBooking(String passenger_id, String lat, String lng, String passenger_count, String terminal_id, String status,String passenger_location) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.post(Uri.parse(passenger_booking),
        headers: {'Accept': 'application/json'},
        body: {
          'passenger_id': passenger_id, 
          'terminal_id': terminal_id,
          'passenger_lat': lat,
          'passenger_lng': lng,
          'passenger_count': passenger_count,
          'passenger_location': passenger_location,
          'status': status
          });

    switch (response.statusCode) {
      case 200:
      
        final data = jsonDecode(response.body)['booking']['id'];
        apiResponse.data= data;
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 429:
        apiResponse.error ='Too MAny Request';
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
  print(apiResponse.data);
  return apiResponse;
}

Future<ApiResponse> approve_Booking(String id, String lat, String lng,  String tricycle_id, String status,String driver_id) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.post(Uri.parse(bookingApproved),
        headers: {'Accept': 'application/json'},
        body: {
          'id': id, 
          'tricycle_id': tricycle_id,
          'driver_lat': lat,
          'driver_lng': lng,
          'driver_id': driver_id,
          'status': status
          });

    switch (response.statusCode) {
      case 200:
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 429:
        apiResponse.error ='Too MAny Request';
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
    print(e.toString());
  }
  return apiResponse;
}

Future<ApiResponse> booking_details(String id) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.post(Uri.parse(bookingDetails),
        headers: {'Accept': 'application/json'},
        body: {
          'id': id, 
          });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['booking'];
        print(apiResponse.data);
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 429:
        apiResponse.error ='Too MAny Request';
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
    print(e.toString());
  }
  return apiResponse;
}

Future<ApiResponse> DriverBookingList(String terminal_id) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    final response = await http.post(Uri.parse(driverBookingList),
        headers: {'Accept': 'application/json'},
        body: {
          'terminal_id': terminal_id,
          });

    switch (response.statusCode) {
      case 200:
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
