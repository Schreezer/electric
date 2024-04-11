import 'package:electric/resources/changingDatabase.dart';
import 'package:electric/screens/usersData.dart';
import 'package:flutter/material.dart';

class HouseCard extends StatefulWidget {
  final int indexNumber;
  final String houseNumber;
  final String email;
  final String userId;
  final String? lastAdded;

  const HouseCard({
    Key? key,
    required this.indexNumber,
    required this.houseNumber,
    required this.email,
    required this.userId,
    this.lastAdded,
  }) : super(key: key);

  @override
  State<HouseCard> createState() => _HouseCardState();
}

class _HouseCardState extends State<HouseCard> {
  void addUserData(BuildContext context) async {
    final result = await Navigator.pushNamed(context, '/admin/addBill',
        arguments: {'id': widget.userId, 'houseNumber': widget.houseNumber});
    if (result == true) {
      Navigator.pushReplacementNamed(context, '/admin');
    }
  }

  void previousBills(BuildContext context) {
    Navigator.pushNamed(context, '/admin/bills',
        arguments: {'id': widget.userId});
  }

  void editUserData(BuildContext context) async{
    final result = await Navigator.pushNamed(context, '/admin/editUser',
        arguments: {'id': widget.userId});
    if (result == true){
      Navigator.pushReplacementNamed(context, '/admin');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
          elevation: 6, // Slightly stronger shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListTile(
              title: Row(
                children: [
                  Text(
                    'House Number: ${widget.houseNumber}',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  Expanded(child: Container()),
                  Text(
                    widget.lastAdded != null
                        ? 'Last Added: ${widget.lastAdded}'
                        : 'No data',
                    style: const TextStyle(fontSize: 16),
                  )
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'Index: ${widget.indexNumber}',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Email: ${widget.email}',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // ElevatedButton(
                      //     onPressed: () async {
                      //       print(widget.userId);
                      //       Map<String, dynamic> userData =
                      //           await getUserData(widget.userId);
                      //       print(userData);
                      //     },
                      //     child: Text('Test')),
                      ElevatedButton.icon(
                        onPressed: () {
                          // On pressed route it to '/User/bills
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => DataScreen(),
                          //     settings: RouteSettings(arguments: widget.userId),
                          //   ),
                          // );
                          previousBills(context);
                        },
                        icon: const Icon(Icons.more_horiz),
                        label: const Text('Previous Bills'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          editUserData(context);
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit User Data'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          addUserData(context);
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add New Data'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
