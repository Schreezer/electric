import "dart:convert";

import 'package:electric/models/billData.dart';
import 'package:electric/models/user.dart';
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import '../models/user.dart' as model;
import 'package:shared_preferences/shared_preferences.dart';

class AuthMethods {
  Future<model.User?> getUserDetails() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? currentJwt = prefs.getString('jwt');
      String? email = prefs.getString('email');
      String? id = prefs.getString('id');
      String? userType = prefs.getString('userType');
      if (currentJwt == null) {
        // print("user is null");
        return null;
      } else {
        final response = await http.post(
          Uri.parse('http://localhost:3000/api/users'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $currentJwt',
          },
          body: jsonEncode(<String, String>{
            'email': email!,
            'id': id!,
          }),
        );
        Map<String, dynamic> responseData = jsonDecode(response.body);
        print(responseData['data'].runtimeType);
        List<BillData> billDataList = responseData['data'].map<BillData>((data) => BillData.fromJson(data)).toList();
        print(billDataList.runtimeType);
        print(billDataList);
        model.User user = model.User(
          email: responseData['email'],
          houseNumber: responseData['houseNumber'],
          userType: responseData['userType'],
          data: billDataList,
          id: responseData['_id'],
        );

        return user;
        // return model.User(email: email!, id: id!, userType: userType!, data: []);
      }
    } catch (e) {
      print("the error caught at getting user details" + e.toString());
      throw e;
    }
  }

  Future<String> requestOtp(String email) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/auth/request-otp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "email": email,
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {

      return "code sent";
    } else {
      return jsonDecode(response.body)['message'];
    }
  }

  Future<void> simpleGetRequest() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000'));
      if (response.statusCode == 200) {
        print('GET request successful');
      } else {
        throw Exception('Failed to make GET request');
      }
    } catch (e) {
      print('Error during GET request: $e');
      throw e;
    }
  }

  Future<Map<String, dynamic>> submitOtp(String email, String otp) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/auth/verify-otp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'otp': otp,
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      print(responseData);

      return responseData;
    } else {
      // return "error as ${response.statusCode} and ${response.body}";
      throw Exception('Failed to verify OTP');

    }
  }
}
