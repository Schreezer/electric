import 'dart:convert';
import 'dart:core';
import 'dart:core';

import 'package:electric/models/billData.dart';
import 'package:electric/widgets/snackBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future createUser(String email, String houseNumber, String userType,
    String? userName, String? consumerType, String? meterNumber) async {
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
        'userName': userName ?? '',
        'email': email,
        'houseNumber': houseNumber,
        'userType': userType,
        'consumerType': consumerType ?? '',
        'meterNumber': meterNumber ?? '',
      }),
    );
    print(response.statusCode);
    // Map<String, dynamic> responseData = jsonDecode(response);
    // print("the response data is as follows: ");
    print(response);

    return response.statusCode.toString();
  } catch (e) {
    print("Error creating user: $e");
    throw e;
  }
}

Future deleteUser(String id) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? currentJwt = prefs.getString('jwt');

    final response = await http.post(
      Uri.parse('http://localhost:3000/api/users/deleteUser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $currentJwt',
      },
      body: jsonEncode(<String, String>{
        'id': id,
      }),
    );

    Map<String, dynamic> responseData = jsonDecode(response.body);
    return responseData;
  } catch (e) {
    print("Error deleting user: $e");
    throw e;
  }
}

Future deleteBill(String id, String billId) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? currentJwt = prefs.getString('jwt');

    final response = await http.post(
      Uri.parse('http://localhost:3000/api/users/deleteBill'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $currentJwt',
      },
      body: jsonEncode(<String, String>{
        'userId': id,
        'billId': billId,
      }),
    );

    Map<String, dynamic> responseData = jsonDecode(response.body);
    return responseData;
  } catch (e) {
    print("Error deleting bill: $e");
    throw e;
  }
}

// a function to retrieve a particular user's data based on their id
Future<Map<String, dynamic>> getUserData(String id) async {
  try {
    print(" ia m geaswe");
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

    print("the user's data is as follows: ");
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
    print(
        "checking whether this is json or not: ${jsonEncode(data.toJson(data))}");
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

Future updateUser(String id, String email, String houseNumber, String userType,
    String userName, String consumerType, String? meterNumber) async {
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
        'userName': userName,
        'consumerType': consumerType,
        'meterNumber': meterNumber ?? '',
      }),
    );

    Map<String, dynamic> responseData = jsonDecode(response.body);
    return responseData;
  } catch (e) {
    print("Error updating user: $e");
    throw e;
  }
}

Future updateLastAddition(String id, DateTime date) async {
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
        'lastAddition': date.toIso8601String(),
      }),
    );
    Map<String, dynamic> responseData = jsonDecode(response.body);
    return responseData;
  } catch (e) {
    throw e;
  }
}

Future fetchDefaultValues() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? currentJwt = prefs.getString('jwt');

    final response = await http.post(
      Uri.parse('http://localhost:3000/api/users/getConstants'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $currentJwt',
      },
    );

    List<dynamic> responseData = jsonDecode(response.body);
    print("the response data is as follows: ");
    print(responseData);
    return responseData;
  } catch (e) {
    print("Error fetching default values: $e");
    throw e;
  }
}

Future addConstants(String key, String value) async {
  print("addition of constants called");
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? currentJwt = prefs.getString('jwt');

    final response = await http.post(
      Uri.parse('http://localhost:3000/api/users/createConstant'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $currentJwt',
      },
      body: jsonEncode(<String, String>{
        'key': key,
        'value': value,
      }),
    );
    print(jsonDecode(response.statusCode.toString()));
    print(jsonDecode(response.body));
    Map<String, dynamic> responseData = jsonDecode(response.body);
    return responseData;
  } catch (e) {
    print("Error adding Constants: $e");
    throw e;
  }
}

Future updateConstant(String key, String value) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? currentJwt = prefs.getString('jwt');
    print(" the constant is ");
    print(key);

    final response = await http.post(
      Uri.parse('http://localhost:3000/api/users/updateConstant'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $currentJwt',
      },
      body: jsonEncode(<String, String>{
        'key': key,
        'value': value,
      }),
    );
    print(jsonDecode(response.statusCode.toString()));

    Map<String, dynamic> responseData = jsonDecode(response.body);
    print("the response data is as follows: ");
    print(responseData);
    return response.statusCode.toString();
  } catch (e) {
    print("Error updating Constants: $e");
    throw e;
  }
}

Future addComment(String billId, String comment) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? currentJwt = prefs.getString('jwt');
    String? userType = prefs.getString('userType');

    final response = await http.post(
      Uri.parse('http://localhost:3000/api/users/addComment'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $currentJwt',
      },
      body: jsonEncode(<String, String>{
        'userId': prefs.getString('id')!,
        'billId': billId,
        'comment': comment,
        'writer': userType ?? "user",
      }),
    );

    Map<String, dynamic> responseData = jsonDecode(response.body);
    return responseData;
  } catch (e) {
    print("Error adding comment: $e");
    throw e;
  }
}

Future fetchComments(String billId, String userId) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? currentJwt = prefs.getString('jwt');

    final response = await http.post(
      Uri.parse('http://localhost:3000/api/users/getComments'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $currentJwt',
      },
      body: jsonEncode(<String, String>{
        'userId': userId,
        'billId': billId,
      }),
    );

    List<dynamic> responseData = jsonDecode(response.body);
    return responseData;
  } catch (e) {
    print("Error fetching comments: $e");
    throw e;
  }
}

Future fetchBillsbyType(String type, String month, String year) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? currentJwt = prefs.getString('jwt');

    final response = await http.post(
      Uri.parse('http://localhost:3000/api/users/getBillsByType'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $currentJwt',
      },
      body: jsonEncode(<String, String>{
        'type': type,
        'month': month,
        'year': year,
      }),
    );
    // now this dataArray is the list of mapping of the data totalAmount, startDate, endDate, houseNumber, userName
    // now we convert it to a list of map<string, dynamic>:
    List<Map<String, dynamic>> data = [];
    for (var item in jsonDecode(response.body)['dataArray']) {
      data.add({
        'totalAmount': item['totalAmount'],
        'startDate': item['startDate'],
        'endDate': item['endDate'],
        'houseNumber': item['houseNumber'],
        'userName': item['userName'],
        'id': item['_id'],
      });
    }
    print("the data is as follows: ");
    print(data);
    return data;
  } catch (e) {
    print("Error fetching bills by type: $e");
    throw e;
  }
}
