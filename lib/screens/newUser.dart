import 'package:electric/resources/changingDatabase.dart';
import 'package:electric/widgets/snackBar.dart';
import 'package:flutter/material.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({Key? key}) : super(key: key);

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController houseNumberController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController consumerTypeController = TextEditingController();
  final TextEditingController meterNumberController = TextEditingController();
  String userType = 'Consumer';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: userNameController,
              decoration: InputDecoration(labelText: 'User Name'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: houseNumberController,
              decoration: InputDecoration(labelText: 'House Number'),
            ),
            TextField(
              controller: meterNumberController,
              decoration: InputDecoration(labelText: 'Meter Number'),
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Type',
              ),
              value: consumerTypeController.text.isNotEmpty ? consumerTypeController.text : null,
              items: [
                DropdownMenuItem<String>(
                  value: 'Domestic',
                  child: Text('Domestic'),
                ),
                DropdownMenuItem<String>(
                  value: 'ShopKeeper',
                  child: Text('ShopKeeper'),
                ),
                DropdownMenuItem<String>(
                  value: 'Director',
                  child: Text('Director'),
                ),
                DropdownMenuItem(child: Text("1"), value: "1"),
                DropdownMenuItem(child: Text("2"), value: "2"),
                DropdownMenuItem(child: Text("3"), value: "3"),
                DropdownMenuItem(child: Text("4"), value: "4"),
                DropdownMenuItem(child: Text("5"), value: "5"),
                DropdownMenuItem(child: Text("6"), value: "6"),
              ],
              onChanged: (value) {
                setState(() {
                  consumerTypeController.text = value!;
                });
              },
            ),
            DropdownButton<String>(
              value: userType,
              onChanged: (String? value) {
                setState(() {
                  userType = value!;
                });
              },
              items: <String>['Consumer', 'Admin'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Confirm User Creation'),
                      content:
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Are you sure you want to create the following user?'),
                              Text('User Name: ${userNameController.text}'),
                              Text('Email: ${emailController.text}'),
                              Text('House Number: ${houseNumberController.text}'),
                              Text('Consumer Type: ${consumerTypeController.text}'),
                              Text('User Type: $userType'),
                            ],
                          ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            createUser(
                              emailController.text,
                              houseNumberController.text,
                              userType.toLowerCase(),
                              userNameController.text,
                              consumerTypeController.text,
                              meterNumberController.text.toString(),
                            ).then((responseData) {
                              if (responseData == '201') {
                                showSnackBar(
                                    context, "User created successfully!");
                                Navigator.pushNamed(context, '/home');
                              }
                              else if (responseData == '400') {
                                showSnackBar(context, "Some error occured");
                              }
                              else {
                                showSnackBar(context, "Error creating user! $responseData");
                              }
                            }).catchError((error) {
                              // Handle error
                              showSnackBar(context, error.toString());
                            });
                            Navigator.of(context).pop();
                          },
                          child: Text('Confirm'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Create User'),
            ),
          ],
        ),
      ),
    );
  }
}
