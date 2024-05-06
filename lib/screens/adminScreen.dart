import "dart:convert";

import "package:electric/resources/changingDatabase.dart";
import "package:electric/widgets/houseCard.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";

class AdminScreen extends StatefulWidget {
  AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List<dynamic> userData = [];
  bool isLoading = true;
  String errorMessage = '';
  String? meterRent;
  String? unitRate;
  String? gst;
  bool changedGst = false;
  bool changedMeterRent = false;
  bool changedUnitRate = false;
  TextEditingController meterRentController = TextEditingController();
  TextEditingController unitRateController = TextEditingController();
  TextEditingController gstController = TextEditingController();

  List<dynamic> filteredData = []; // To store the filtered data
  TextEditingController searchController =
      TextEditingController(); // For the search bar

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchConstants();
  }

  Future<void> fetchConstants() async {
    List<dynamic> constants = await fetchDefaultValues();
    Map<String, dynamic> constantsMap = {
      for (var item in constants) item['key']: item['value']
    };
    setState(() {
      meterRent = constantsMap['meterRent'];
      unitRate = constantsMap['unitRate'];
      gst = constantsMap['gst'];
      meterRentController.text = constantsMap['meterRent'].toString();
      unitRateController.text = constantsMap['unitRate'].toString();
      gstController.text = constantsMap['gst'].toString();
    });
  }

  Future<void> fetchUserData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? jwtToken = prefs.getString('jwt');

      final response = await http.get(
        Uri.parse('http://localhost:3000/api/users/Users'),
        headers: {
          'Authorization': 'Bearer $jwtToken',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          userData = data;
          filteredData = data;
        });
      } else {
        setState(() {
          errorMessage =
              'Failed to fetch user data. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to fetch user data: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<dynamic> dummyListData = [];
      userData.forEach((item) {
        if (item['houseNumber']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            item['email']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        filteredData = dummyListData;
      });
      return;
    } else {
      setState(() {
        filteredData = userData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Data', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize:
              Size.fromHeight(kToolbarHeight), // Standard toolbar height
          child: Container(
            color: Colors
                .white, // Container with white color to separate it from the AppBar
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  filterSearchResults(value);
                },
                decoration: InputDecoration(
                  labelText: "Search",
                  hintText: "Search by house number or email",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : filteredData.isNotEmpty
              ? Column(
                  children: [
                    Container(
                        height: 80,
                        child: Row(
                          children: [
                            SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    changedMeterRent = true;
                                  });
                                },
                                controller: meterRentController,
                                decoration: InputDecoration(
                                  labelText: 'Meter Rent',
                                  border: OutlineInputBorder(),
                                  errorText:
                                      _validateDouble(meterRentController.text)
                                          ? null
                                          : "Enter a valid number",
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    changedUnitRate = true;
                                  });
                                },
                                controller: unitRateController,
                                decoration: InputDecoration(
                                  labelText: 'Unit Rate',
                                  border: OutlineInputBorder(),
                                  errorText:
                                      _validateInteger(unitRateController.text)
                                          ? null
                                          : "Enter a valid integer",
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: gstController,
                                onChanged: (value) {
                                  setState(() {
                                    changedGst = true;
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: 'GST',
                                  border: OutlineInputBorder(),
                                  errorText: _validateDouble(gstController.text)
                                      ? null
                                      : "Enter a valid number",
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                                onPressed: () {
                                  if (_validateDouble(gstController.text) &&
                                      _validateDouble(
                                          meterRentController.text) &&
                                      _validateInteger(
                                          unitRateController.text)) {
                                    if (changedGst) {
                                      if (gst != null) {
                                        updateConstant(
                                            'gst', gstController.text);
                                      } else {
                                        addConstants('gst', gstController.text);
                                      }
                                    }
                                    if (changedMeterRent) {
                                      if (meterRent != null) {
                                        updateConstant('meterRent',
                                            meterRentController.text);
                                      } else {
                                        addConstants('meterRent',
                                            meterRentController.text);
                                      }
                                    }
                                    if (changedUnitRate) {
                                      if (unitRate != null) {
                                        updateConstant('unitRate',
                                            unitRateController.text);
                                      } else {
                                        addConstants('unitRate',
                                            unitRateController.text);
                                      }
                                    }
                                  } else {
                                    setState(() {
                                      errorMessage =
                                          "Please correct errors before submitting.";
                                    });
                                  }
                                },
                                child: Text('Update Constants'))
                          ],
                        )),
                    if (errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(errorMessage,
                            style: TextStyle(color: Colors.red, fontSize: 14)),
                      ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredData.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> user = filteredData[index];
                          return HouseCard(
                            indexNumber: index,
                            houseNumber: user['houseNumber'],
                            email: user['email'],
                            userId: user['_id'],
                            lastAdded: user['lastAddition'],
                            userName: user['userName'],
                            consumerType: user['consumerType'] ?? '',
                            meterNumber: user['meterNumber'] ?? '',
                          );
                        },
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Text(errorMessage.isNotEmpty
                      ? errorMessage
                      : 'No user data available')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/admin/new');
        },
        icon: Icon(Icons.add),
        label: Text(
          'Add User',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  bool _validateDouble(String value) {
    return double.tryParse(value) != null;
  }

  bool _validateInteger(String value) {
    return int.tryParse(value) != null;
  }
}
