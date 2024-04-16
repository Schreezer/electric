import "dart:convert";

import "package:electric/widgets/houseCard.dart";
import "package:flutter/material.dart";
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


  List<dynamic> filteredData = []; // To store the filtered data
  TextEditingController searchController =
      TextEditingController(); // For the search bar

  @override
  void initState() {
    super.initState();
    fetchUserData();
    
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
          errorMessage = 'Failed to fetch user data. Status code: ${response.statusCode}';
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
        preferredSize: Size.fromHeight(kToolbarHeight), // Standard toolbar height
        child: Container(
          color: Colors.white, // Container with white color to separate it from the AppBar
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
              ? ListView.builder(
                  itemCount: filteredData.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> user = filteredData[index];
                    return HouseCard(
                      indexNumber: index,
                      houseNumber: user['houseNumber'],
                      email: user['email'],
                      userId: user['_id'],
                      lastAdded: user['lastAddition'],
                    );
                  },
                )
              : Center(child: Text(errorMessage.isNotEmpty ? errorMessage : 'No user data available')),
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
}
