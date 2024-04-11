

import 'dart:convert';

import 'package:electric/models/billData.dart';
import 'package:electric/widgets/snackBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


Future<Map<String, dynamic>> createUser(String email, String houseNumber, String userType) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? currentJwt = prefs.getString('jwt');
    
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/users/create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $currentJwt',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'houseNumber': houseNumber,
        'userType': userType,
      }),
    );
    
    Map<String, dynamic> responseData = jsonDecode(response.body);
    return responseData;
  } catch (e) {
    print("Error creating user: $e");
    throw e;
  }
}

// a function to retrieve a particular user's data based on their id
Future<Map<String, dynamic>> getUserData(String id) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? currentJwt = prefs.getString('jwt');
    
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/users/'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $currentJwt',
      },
      body: jsonEncode(<String, String>{
        'id': id,
      }),
    );
    
    Map<String, dynamic> responseData = jsonDecode(response.body);
    print("the response data is as follows: ");
    print(responseData);
    return responseData;
  } catch (e) {
    print("Error getting user data: $e");
    throw e;
  }
}

Future addUserData(String id, BillData data) async {

  print("the data is as follows: ");
  print(data.toJson(data));
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? currentJwt = prefs.getString('jwt');
    
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/users/addbill'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $currentJwt',
      },
      body: jsonEncode(<String, dynamic>{
        'id': id,
        'data': data.toJson(data),
      }),
    );
    
    Map<String, dynamic> responseData = jsonDecode(response.body);
    print("the response data is as follows: ");
    print(responseData);
    print(response.statusCode);
    return response.statusCode.toString();
  } catch (e) {
    print("Error adding user data: $e");
    return e;
    // throw e;

  }
}

Future updateUserData(String userId, BillData data, String billId) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? currentJwt = prefs.getString('jwt');
    Map<String, dynamic> jsonData = {
      'userId': userId,
      'billId': billId,
      'data': data.toJson(data),
    };
    String jsonString = jsonEncode(jsonData);
    print("the data is json or not: $jsonString");
    // print(jsonEncode(data.toJson(data)));
    print("checking whether this is json or not: ${jsonEncode(data.toJson(data))}");
    print(" we are here");
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/users/updateBill'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $currentJwt',
      },
      body: jsonEncode(<String, dynamic>{
        'userId': userId,
        'billId': billId,
        'data': data.toJson(data),
      }),
    );
    
    Map<String, dynamic> responseData = jsonDecode(response.body);
    print("the response data is as follows: ");
    print(responseData);
    print("the reponse code is as follows: ");
    print(response.statusCode);
    return response.statusCode.toString();
  } catch (e) {
    print("Error updating user data: $e");
    throw e;
  }
}

Future updateUser(String id, String email, String houseNumber, String userType) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? currentJwt = prefs.getString('jwt');
    
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/users/updateUser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $currentJwt',
      },
      body: jsonEncode(<String, String>{
        'id': id,
        'email': email,
        'houseNumber': houseNumber,
        'userType': userType,
      }),
    );
    
    Map<String, dynamic> responseData = jsonDecode(response.body);
    return responseData;
  } catch (e) {
    print("Error updating user: $e");
    throw e;
  }
}

