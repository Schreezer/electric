import "package:electric/resources/changingDatabase.dart";
import "package:flutter/material.dart";

class EditUserScreen extends StatefulWidget {
  final userId;
  const EditUserScreen({required this.userId ,Key? key}) : super(key: key);

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

  void showAutoDismissDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          content: Text(message),
        );
      },
    );
  }

class _EditUserScreenState extends State<EditUserScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController houseNumberController = TextEditingController();
  final TextEditingController consumerTypeController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController meterNumberController = TextEditingController();
  String userType = 'Consumer';
  Future<Map<String, dynamic>> user = Future.value({});

  String update(){
    
    try {
      updateUser(widget.userId, emailController.text, houseNumberController.text, userType, userNameController.text, consumerTypeController.text, meterNumberController.text).then((value) => 
      showAutoDismissDialog(context, "User Successfully Updated"));
      return 'User updated';
    } catch (e) {
      print('Error updating user: $e');
      return 'Error updating user';
    }

  }
  
  
  @override
  void initState() {
    super.initState();
    // Fetch user details using widget.userId
    user = getUserData(widget.userId);
    user.then((userData) {
      print("the current user type is ${userData['consumerType']}");
      setState(() {
        meterNumberController.text = userData['meterNumber']??'';
        consumerTypeController.text = userData['consumerType']??'';
        userNameController.text = userData['userName']?? '';
      emailController.text = userData['email'];
      houseNumberController.text = userData['houseNumber'];
      userType = userData['userType'].toLowerCase() == 'admin' ? 'Admin' : 'Consumer';
      });
      
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User'),
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
              value: consumerTypeController.text.isNotEmpty ? consumerTypeController.text.toString() : null,
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
                      title: Text('Confirm User Edit'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Are you sure you want to edit the following user?'),
                          Text('User Name: ${userNameController.text}'),
                          Text('Email: ${emailController.text}'),
                          Text('House Number: ${houseNumberController.text}'),
                          Text('User Type: $userType'),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (update() == 'User updated') {
                              Navigator.pop(context);
                              Navigator.pop(context, true);
                            }
                            else{
                              showAutoDismissDialog(context, "Error updating user");

                            }
                          },
                          child: Text('Confirm'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Edit User'),
            ),
          ],
        ),
      ),
    );
  }
}