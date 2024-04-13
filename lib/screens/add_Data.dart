
import "dart:async";
import "dart:core";

import "package:electric/models/billData.dart";
import "package:electric/models/user.dart";
import "package:electric/resources/AuthMethods.dart";
import "package:electric/resources/changingDatabase.dart";
import "package:electric/widgets/snackBar.dart";
import "package:electric/widgets/text_Field.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import 'package:fluttertoast/fluttertoast.dart';

class AddDataScreen extends StatefulWidget {
  final String userId;
  final String houseNumber;
  const AddDataScreen(
      {Key? key, required this.userId, required this.houseNumber})
      : super(key: key);

  @override
  State<AddDataScreen> createState() => _AddDataScreenState();
}

Widget TextF(String hintText, TextEditingController controller, bool editable,
    {TextInputType keyboardType = TextInputType.text,
    void Function(String)? onChanged}) {
  return TextField(
    enabled: editable,
    controller: controller,
    keyboardType: keyboardType,
    onChanged: onChanged,
    decoration: InputDecoration(
      labelText: hintText,
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  );
}

class _AddDataScreenState extends State<AddDataScreen> {
  TextEditingController _consumerNameController = TextEditingController();
  TextEditingController _houseNumberController = TextEditingController();
  TextEditingController _meterNumberController = TextEditingController();
  TextEditingController _typeController = TextEditingController();
  late DateTime _startDate;
  bool selectedStart = false;
  bool selectedEnd = false;
  late DateTime _endDate;
  bool selectedIssue = false;
  late DateTime _issueDate;
  double totalConsumed = 0;

  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController _numberOfDaysController = TextEditingController();
  TextEditingController _previousReadingController = TextEditingController();
  TextEditingController _currentReadingController = TextEditingController();
  TextEditingController _totalUnitsConsumedController = TextEditingController();
  TextEditingController _energyChargeController = TextEditingController();
  TextEditingController _meterRentController = TextEditingController();
  TextEditingController _gstController = TextEditingController();
  TextEditingController _totalAmountController = TextEditingController();
  TextEditingController _netPayableController = TextEditingController();
  TextEditingController _dateOfIssueController = TextEditingController();
  TextEditingController _energyChargesPerUnitController = TextEditingController();

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

  Future addData(BuildContext contxt) async {
    try {
      // Add data to the database
      print("the total amount is as follows: ");
      print( double.tryParse(_totalAmountController.text));

      String value = await addUserData(
          widget.userId,
          
          BillData.fromJson({
            'consumerName': _consumerNameController.text,
            'houseNumber': _houseNumberController.text,
            'meterNumber': int.tryParse(_meterNumberController.text),
            'type': _typeController.text,
            'startDate': _startDate.toLocal().toString().split(' ')[0],
            'endDate': _endDate.toLocal().toString().split(' ')[0],
            'numberOfDays': int.tryParse(_numberOfDaysController.text),
            'previousReading': int.tryParse(_previousReadingController.text),
            'currentReading': int.tryParse(_currentReadingController.text),
            'totalUnitsConsumed':
                int.tryParse(_totalUnitsConsumedController.text),
            'energyCharge': int.tryParse(_energyChargeController.text),
            'meterRent': int.tryParse(_meterRentController.text),
            'gst': int.tryParse(_gstController.text),
            'totalAmount': double.tryParse(_totalAmountController.text),
            'netPayable': int.tryParse(_netPayableController.text),
            'dateOfIssue': _issueDate.toLocal().toString().split(' ')[0],
          }));

      if (value == "201") {
        return true;
      } else {
        return false;
      }
    } catch (e) {

      print("Error adding data: $e");
      // throw e;
      showSnackBar(contxt, e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _houseNumberController = TextEditingController(text: widget.houseNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            SizedBox(
              height: 10,
            ),
            TextF('Consumer Name', _consumerNameController, true),
            SizedBox(
              height: 10,
            ),
            // TField(hText: "batman", controller: _consumerNameController),
            TextF(
              'House Number',
              _houseNumberController,
              false,
            ),
            SizedBox(
              height: 10,
            ),
            TextF(
              'Meter Number',
              _meterNumberController,
              true,
              // keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 10,
            ),
            TextF(
              'Type',
              _typeController,
              true,
            ),
            SizedBox(
              height: 10,
            ),
            // TextF(
            //   'Start Date',
            //   _startDateController,
            //   true,
            // ),
            ElevatedButton(
              onPressed: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  print('Selected date: $pickedDate');
                  // Here you can assign pickedDate to your variable
                  setState(() {
                    _startDate = pickedDate;
                    selectedStart = true;
                    if(_endDate != null){
                      _numberOfDaysController.text =
                          (_endDate.difference(_startDate).inDays + 1)
                              .toString();
                    }
                  });
                }
              },
              child: Text(selectedStart
                  ? "${_startDate.toLocal().toString().split(' ')[0]}"
                  : 'Select Start Date'),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  print('Selected date: $pickedDate');
                  // Here you can assign pickedDate to your variable
                  setState(() {
                    _endDate = pickedDate;
                    selectedEnd = true;
                    if (_startDate != null) {
                      _numberOfDaysController.text =
                          (_endDate.difference(_startDate).inDays + 1)
                              .toString();
                    }
                  });
                }
              },
              child: Text(selectedEnd
                  ? "${_endDate.toLocal().toString().split(' ')[0]}"
                  : 'Select End Date'),
           
            ),
            // TextF(
            //   'End Date',
            //   _endDateController,
            //   true,
            // ),
            SizedBox(
              height: 10,
            ),
            TextF(
              'Number of Days',
              _numberOfDaysController,
              false,
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 10,
            ),
            TextF(
              'Previous Reading',
              _previousReadingController,
              true,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if (_currentReadingController.text.isNotEmpty) {
                  setState(() {
                    totalConsumed =
                        double.parse(_currentReadingController.text) -
                            double.parse(value);
                    _totalUnitsConsumedController.text =
                        totalConsumed.toString();
                  });
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextF(
              'Current Reading',
              _currentReadingController,
              true,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if (_previousReadingController.text.isNotEmpty) {
                  setState(() {
                    totalConsumed = double.parse(value) -
                        double.parse(_previousReadingController.text);
                    _totalUnitsConsumedController.text =
                        totalConsumed.toString();
                  });
                }
              },
            ),
            SizedBox(height: 10),
            TextF("Energy Charges Per Unit", _energyChargesPerUnitController, true,
                keyboardType: TextInputType.number, onChanged: (value){
                  if (_totalUnitsConsumedController.text.isNotEmpty) {
                    setState(() {
                      double energyCharge = double.parse(value) * totalConsumed;
                      _energyChargeController.text = energyCharge.toString();
                      if (_gstController.text.isNotEmpty && _meterRentController.text.isNotEmpty) {
                        double totalAmount = energyCharge +
                            double.parse(_meterRentController.text) +
                            double.parse(_gstController.text);
                        _totalAmountController.text = totalAmount.toString();
                        double netPayable = totalAmount.roundToDouble();
                        _netPayableController.text = netPayable.toString();
                      }
                    });
                  }
                }),
            SizedBox(
              height: 10,
            ),
            TextF(
              'Total Units Consumed',
              _totalUnitsConsumedController,
              false,
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 10,
            ),
            TextF(
              'Total Energy Charge',
              _energyChargeController,
              false,
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 10,
            ),
            TextF(
              'Meter Rent',
              _meterRentController,
              true,
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 10,
            ),
            TextF(
              'GST (%)',
              _gstController,
              true,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if (_energyChargeController.text.isNotEmpty) {
                  setState(() {
                    double totalAmount = double.parse(_energyChargeController.text) +
                        double.parse(_meterRentController.text) +
                        double.parse(value)*0.01*double.parse(_meterRentController.text);
                    _totalAmountController.text = totalAmount.toString();
                    double netPayable = totalAmount;
                    _netPayableController.text = netPayable.round().toString();
                  });
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextF(
              'Total Amount',
              _totalAmountController,
              false,
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 10,
            ),
            TextF(
              'Net Payable',
              _netPayableController,
              false,
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  print('Selected date: $pickedDate');
                  // Here you can assign pickedDate to your variable
                  setState(() {
                    _issueDate = pickedDate;
                    selectedIssue = true;
                  });
                }
              },
              child: Text(selectedIssue
                  ? "${_issueDate.toLocal().toString().split(' ')[0]}"
                  : 'Select Issue Date'),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Column(
                children: [
                  ElevatedButton(onPressed: (){
                    if(_gstController.text.isNotEmpty && _meterRentController.text.isNotEmpty && _energyChargesPerUnitController.text.isNotEmpty && _currentReadingController.text.isNotEmpty && _previousReadingController.text.isNotEmpty){
                      double energyCharge = double.parse(_energyChargesPerUnitController.text) * totalConsumed;
                      _energyChargeController.text = energyCharge.toString();
                      double totalAmount = energyCharge +
                          double.parse(_meterRentController.text) +
                          double.parse(_gstController.text)*0.01*double.parse(_meterRentController.text);
                      setState(() {
                        _totalAmountController.text = totalAmount.toString();
                      double netPayable = totalAmount.roundToDouble();
                      _netPayableController.text = netPayable.toString();
                      });
                      
                    }
                  }, child: Text("Re-Calculate All")),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      bool valu = await addData(context);
                      if (valu == true) {
                        print("Data added successfully");
                        Map<String, dynamic> user =
                            await getUserData(widget.userId);
                  
                        if (user['lastAddition'] == null ||
                            DateTime.parse(user['lastAddition'])
                                .isBefore(_issueDate)) {
                          await updateLastAddition(widget.userId, _issueDate);
                        }
                  
                        showAutoDismissDialog(context, "Data added successfully");
                        Future.delayed(Duration(seconds: 2), () {
                          Navigator.pushReplacementNamed(context, '/admin');
                        });
                      }
                  
                      // Add data to the database
                    },
                    style: ElevatedButton.styleFrom(
                      // primary: Colors.blue, // Make the button more vibrant
                      padding: EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30), // Make the button bigger
                    ),
                    child: const Text('Add Data',
                        style: TextStyle(fontSize: 18)), // Increase font size
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
