import 'package:electric/resources/changingDatabase.dart';
import 'package:flutter/material.dart';
import 'package:electric/screens/editData.dart';
import 'package:intl/intl.dart';

class BillCardAdmin extends StatefulWidget {
  final Map<String, dynamic> jsonData;
  final String userId;

  const BillCardAdmin({
    Key? key,
    required this.userId,
    required this.jsonData,
  }) : super(key: key);

  @override
  State<BillCardAdmin> createState() => _BillCardAdminState();
}

class _BillCardAdminState extends State<BillCardAdmin> {
  void edit(BuildContext context) async {
    final result = await Navigator.pushNamed(context, '/admin/bills/editBill',
        arguments: {'data': widget.jsonData, 'userId': widget.userId});
    if (result == true) {
      print("result is true");
      Navigator.pushReplacementNamed(context, '/admin/bills',
          arguments: {'id': widget.userId});
    }
  }

  void comments(BuildContext context) async {
    final result = await Navigator.pushNamed(context, '/admin/bills/comments',
        arguments: {'userId': widget.userId, 'billId': widget.jsonData['_id']});
    if (result == true) {
      print("result is true");
      Navigator.pushReplacementNamed(context, '/admin/bills',
          arguments: {'id': widget.userId});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(16), // Optimized padding
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.blueGrey.shade100),
            boxShadow: [
              BoxShadow(
                color: Colors.blueGrey.shade50,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
            borderRadius: BorderRadius.circular(12), // Smoothed corners
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Date of Issue: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.jsonData['dateOfIssue']))}',

                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold), // Enhanced style
                  ),
                  Expanded(
                      child: Row(
                    children: [
                      Expanded(
                        child: Container(),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Confirmation'),
                                content: Text(
                                    'Are you sure you want to delete this Bill?'),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                      await deleteBill(widget.userId, widget.jsonData['_id']);
                                      // reload the page
                                      Navigator.pushReplacementNamed(
                                          context, '/admin/bills', arguments: {'id': widget.userId});
                                    },
                                    child: Text('Yes'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                    child: Text('No'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        tooltip: 'Delete User',
                        splashRadius: 20,
                        color: Colors.red,
                        constraints: BoxConstraints(),
                        padding: EdgeInsets.zero,
                        alignment: Alignment.center,
                        visualDensity: VisualDensity(),
                        iconSize: 20,
                        splashColor: Colors.red[100],
                        icon: Icon(
                          Icons.delete,
                          size: 20,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  )),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Consumer Name: ${widget.jsonData['consumerName']}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'Net Payable: ${widget.jsonData['netPayable']}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                'End Date: ${widget.jsonData['endDate']}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context)
                            .primaryColor, // Use the theme's primary color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () => edit(context),
                      // MaterialPageRoute(builder: (context) => EditScreen(data: widget.jsonData, userId: widget.userId,))),
                      // Navigator.pushNamed(context, '/admin/bills/editBill', arguments: {'data': widget.jsonData , 'userId': widget.userId}),
                      child: Text('Edit',
                          style: TextStyle(
                              color: Colors
                                  .white)), // Corrected fontColor to color
                    ),
                    Expanded(child: Container()),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context)
                            .primaryColor, // Use the theme's primary color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () => comments(context),
                      child: Text('Comments',
                          style: TextStyle(
                              color: Colors
                                  .white)), // Corrected fontColor to color
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
