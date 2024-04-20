import 'package:electric/resources/changingDatabase.dart';
import 'package:electric/screens/usersData.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HouseCard extends StatefulWidget {
  final int indexNumber;
  final String houseNumber;
  final String? consumerType;
  final String email;
  final String userId;
  final String? lastAdded;
  final String? userName;
  final String? meterNumber;

  const HouseCard({
    Key? key,
    this.meterNumber,
    required this.indexNumber,
    this.consumerType,
    required this.houseNumber,
    required this.email,
    required this.userId,
    this.userName,
    this.lastAdded,
  }) : super(key: key);

  @override
  State<HouseCard> createState() => _HouseCardState();
}

class _HouseCardState extends State<HouseCard> {
  void addUserData(BuildContext context) async {
    final result =
        await Navigator.pushNamed(context, '/admin/addBill', arguments: {
      'id': widget.userId,
      'houseNumber': widget.houseNumber,
      'userName': widget.userName ?? '',
      'consumerType': widget.consumerType ?? '',
      'meterNumber': widget.meterNumber ?? '',
    });
    if (result == true) {
      Navigator.pushReplacementNamed(context, '/admin');
    }
  }

  void previousBills(BuildContext context) async {
    final result = await Navigator.pushNamed(context, '/admin/bills',
        arguments: {'id': widget.userId});
    if (result == true) {
      Navigator.pushReplacementNamed(context, '/admin');
    }
  }

  void editUserData(BuildContext context) async {
    final result = await Navigator.pushNamed(context, '/admin/editUser',
        arguments: {'id': widget.userId});
    if (result == true) {
      Navigator.pushReplacementNamed(context, '/admin');
    }
  }

  // String formatDate(String? date) {
  //   if (date == null) return 'No data';
  //   final dateTime = DateTime.parse(date);
  //   return DateFormat('MMM dd, yyyy').format(dateTime);
  // }
  String formatDate(String? date) {
    if (date == null) return 'No data';
    final dateTime = DateTime.parse(date).toLocal(); // Convert to local time
    final indianDateFormat = DateFormat('MMM dd, yyyy').format(dateTime);
    return indianDateFormat;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'House Number: ${widget.houseNumber}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple, // Adjust to your color theme
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[100], // Light purple background
                      borderRadius: BorderRadius.circular(10.0),
                    ),

                    // ...

                    child: Text(
                      widget.lastAdded != null
                          ? 'Last Added: ${formatDate(widget.lastAdded)}'
                          : 'No data',
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.deepPurple, // Text color
                      ),
                    ),

                    // ...
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Index: ${widget.indexNumber}',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 6),
              Text(
                'Email: ${widget.email}',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 6),
              Text(
                widget.lastAdded != null
                    ? 'Last Added: ${formatDate(widget.lastAdded)}'
                    : 'No data',
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => previousBills(context),
                    icon: Icon(Icons.history, size: 20),
                    label: Text('Previous Bills'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.purple,
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => editUserData(context),
                    icon: Icon(Icons.edit, size: 20),
                    label: Text('Edit User Data'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.deepPurple,
                      side:
                          BorderSide(color: Colors.deepPurple), // Border color
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => addUserData(context),
                    icon: Icon(Icons.add, size: 20),
                    label: Text('Add New Data'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
