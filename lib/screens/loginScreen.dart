import 'dart:async';

import "package:electric/providers/userProvider.dart";
import 'package:electric/resources/AuthMethods.dart';
import 'package:electric/widgets/snackBar.dart';
import 'package:electric/widgets/text_Field.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:floating_bubbles/floating_bubbles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  bool _isLoading1 = false;
  bool _isLoading2 = false;
  bool otpSent = false;
  Timer? _timer;
  int _start = 900;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer?.cancel(); // Cancel any previous timer
    setState(() {
      _start = 590; // Reset the timer to 60 seconds
    });
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void resetTimer() {
    setState(() {
      _timer?.cancel();
      _start = 590; // Reset the timer to 60 seconds
    });
  }

  Future<bool> sendOtp() async {
    // should work on the logic of sending otp TODO: Test this function
    print(_emailController.text);
    setState(() {
      _isLoading1 = true;
    });
    String res = await AuthMethods().requestOtp(_emailController.text);

    print(res);
    if (res == 'code sent') {
      showSnackBar(context, res);
      setState(() {
        _isLoading1 = false;
      });
      return true;
    } else {
      showSnackBar(context, res);
      setState(() {
        _isLoading1 = false;
      });
      print("the otp could not be sent");
      return false;
    }
  }

bool emailValid() {
    String email = _emailController.text;
    RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    bool isValid = emailRegex.hasMatch(email);
    return isValid;
}
  
  Future<void> next(Provider) async {
    // should work on the logic of sending otp TODO: Test this function
    setState(() {
      _isLoading2 = true;
    });
    try {
      Map<String, dynamic> responseData = await AuthMethods()
          .submitOtp(_emailController.text, _otpController.text);
      // store in shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print("we are at the login screen printing: ");
      print(responseData['token']);
      print(responseData['email']);
      print(responseData['userId']);
      print(responseData['userType']);
       
      await prefs.setString('jwt', responseData['token']);
      await prefs.setString('email', responseData['email']);
      await prefs.setString('id', responseData['userId']);
      await prefs.setString('userType', responseData['userType']);
      await Provider.refreshUser(false);
      // get the string jwt stored and print it to check:
    Navigator.pushNamed(context, responseData['userType']=='admin'?'/choice':'/home');
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    setState(() {
      _isLoading2 = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: Divider.createBorderSide(context),
    );
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/log.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.36,
            height: MediaQuery.of(context).size.height * 0.8,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.7),
                  blurRadius: 10.0,
                  spreadRadius: 2.0,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  const Text(
                    'Login',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 30),
                  FractionallySizedBox(
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: "Enter Email",
                        prefixIcon: const Icon(Icons.email),
                        border: inputBorder,
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading1
                        ? null
                        : () async {
                            setState(() {
                              _isLoading1 = true;
                            });
                            if (emailValid()) {
                              bool otpResult = await sendOtp();
                              if (otpResult) {
                                setState(() {
                                  otpSent = true;
                                });
                                resetTimer();
                                startTimer();
                                showSnackBar(context,
                                    "OTP sent to ${_emailController.text}");
                              } else {
                                // showSnackBar(context,
                                //     "$otpResult");
                              }
                            } else {
                              showSnackBar(context,
                                  "Please enter a valid email address");
                            }
                            setState(() {
                              _isLoading1 = false;
                            });
                          },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black,
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: _isLoading1
                        ? CircularProgressIndicator()
                        : Text("Request OTP"),
                  ),
                  const SizedBox(height: 10),
                  if (otpSent) ...[
                    SizedBox(height: 20),
                    Text(
                      "OTP will expire in $_start seconds",
                      style: TextStyle(color: Colors.red[900]),
                    ),
                  ],
                  if (otpSent) ...[
                    SizedBox(height: 20),
                    TField(
                      hText: "Enter OTP",
                      controller: _otpController,
                      preIcon: Icon(Icons.lock_outline),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isLoading2
                          ? null
                          : () {
                              next(userProvider);
                            },
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: _isLoading2
                          ? CircularProgressIndicator()
                          : Text("Submit OTP"),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
