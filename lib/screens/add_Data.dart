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
  final String? userName;
  final String? consumerType;
  final String? meterNumber;
  const AddDataScreen(
      {Key? key,
      required this.userId,
      required this.houseNumber,
      this.userName,
      this.consumerType,
      this.meterNumber})
      : super(key: key);

  @override
  State<AddDataScreen> createState() => _AddDataScreenState();
}

Widget TextF(String hintText, TextEditingController controller, bool editable,
    {TextInputType keyboardType = TextInputType.text,
    bool isValid = true,
    String errorMessage = "Please enter a valid integer",
    void Function(String)? onChanged}) {
  // Corrected to include onChanged
  return TextField(
    enabled: editable,
    controller: controller,
    keyboardType: keyboardType,
    onChanged: onChanged, // Correct usage of onChanged within TextField
    decoration: InputDecoration(
      errorText: isValid ? null : errorMessage,
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
  DateTime _startDate =
      DateTime(DateTime.now().year, DateTime.now().month - 1, 16);
  bool selectedStart = true;
  bool selectedEnd = true;
  DateTime _endDate = DateTime(DateTime.now().year, DateTime.now().month, 15);

  bool selectedIssue = false;
  late DateTime _issueDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
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
  // TextEditingController _energyChargesPerUnitController =
  //     TextEditingController();

  bool _isValidMeterNumber = true;
  bool _isValidPreviousReading = true;
  bool _isValidCurrentReading = true;
  // Add validation methods
  void validateMeterNumber() {
    setState(() {
      _isValidMeterNumber = _validateInteger(_meterNumberController.text);
    });
  }

  void validatePreviousReading() {
    setState(() {
      _isValidPreviousReading =
          _validateInteger(_previousReadingController.text);
    });
  }

  void validateCurrentReading() {
    setState(() {
      _isValidCurrentReading = _validateInteger(_currentReadingController.text);
    });
  }

  bool _validateInteger(String value) {
    return int.tryParse(value) != null;
  }

  TextEditingController _totalEnergyChargeController = TextEditingController();

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

  void calculateTotalUnitsConsumed() {
    if (_currentReadingController.text.isNotEmpty &&
        _previousReadingController.text.isNotEmpty) {
      setState(() {
        totalConsumed = double.parse(_currentReadingController.text) -
            double.parse(_previousReadingController.text);
        _totalUnitsConsumedController.text = totalConsumed.toString();
      });
    }
  }

  void calculateEnergy() {
    if (_energyChargeController.text.isNotEmpty &&
        _totalUnitsConsumedController.text.isNotEmpty) {
      print("calculateEnergy was called");
      setState(() {
        _totalEnergyChargeController.text =
            (int.tryParse(_totalUnitsConsumedController.text)! *
                    int.tryParse(_energyChargeController.text)!)
                .toString();
        // _totalEnergyChargeController.text = '31';
      });
      print(" the val is ${_totalEnergyChargeController.text}");
    }
  }

  void calculateTotalAmount() {
    if (_totalEnergyChargeController.text.isNotEmpty &&
        _meterRentController.text.isNotEmpty &&
        _gstController.text.isNotEmpty) {
      setState(() {
        _totalAmountController.text =
            (int.tryParse(_totalEnergyChargeController.text)! +
                    (double.tryParse(_meterRentController.text)! *
                        (1 + 0.01 * double.tryParse(_gstController.text)!)))
                .toString();
        _netPayableController.text =
            double.tryParse(_totalAmountController.text)!.round().toString();
      });
    }
  }

  void calcAll() {
    print("i was called");
    calculateTotalUnitsConsumed();
    calculateEnergy();
    calculateTotalAmount();
  }

  Future addData(BuildContext contxt) async {
    try {
      // Add data to the database
      print("the total amount is as follows: ");
      print(double.tryParse(_totalAmountController.text));

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
    setState(() {
      _houseNumberController = TextEditingController(text: widget.houseNumber);
      _consumerNameController = TextEditingController(text: widget.userName);
      _typeController = TextEditingController(text: widget.consumerType);
      _meterNumberController = TextEditingController(text: widget.meterNumber);
      _numberOfDaysController = TextEditingController(
          text: (_endDate.difference(_startDate).inDays).toString());
    });

    fetchConstants();
  }

  Future<void> fetchConstants() async {
    List<dynamic> constants = await fetchDefaultValues();
    Map<String, dynamic> constantsMap = {
      for (var item in constants) item['key']: item['value']
    };
    setState(() {
      _meterRentController.text = constantsMap['meterRent'].toString();
      _energyChargeController.text = constantsMap['unitRate'].toString();
      _gstController.text = constantsMap['gst'].toString();
    });
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
            TextF('Consumer Name', _consumerNameController, false),
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
              false,
              keyboardType: TextInputType.number,
              isValid: _isValidMeterNumber,
              errorMessage: "Please enter a valid integer",
              onChanged: (value) {
                validateMeterNumber();
              },
            ),
            SizedBox(
              height: 10,
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Type',
              ),
              value:
                  _typeController.text.isNotEmpty ? _typeController.text : null,
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
              onChanged: null,
              // onChanged: (value) {
              //   setState(() {
              //     _typeController.text = value!;
              //   });
              // },
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
                    _startDate = pickedDate;
                    selectedStart = true;
                    if (_endDate != null) {
                      _numberOfDaysController.text =
                          (_endDate.difference(_startDate).inDays + 1)
                              .toString();
                      calcAll();
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
                      calcAll();
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
              isValid: _isValidPreviousReading,
              errorMessage: "Please enter a valid integer",
              onChanged: (value) {
                validatePreviousReading();
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
              isValid: _isValidCurrentReading,
              errorMessage: "Please enter a valid integer",
              onChanged: (value) {
                validateCurrentReading();
                calcAll();
              },
            ),
            SizedBox(height: 10),
            TextF("Energy Charges Per Unit", _energyChargeController, false,
                keyboardType: TextInputType.number, onChanged: (value) {
              calcAll();
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
              _totalEnergyChargeController,
              false,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                calcAll();
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextF('Meter Rent', _meterRentController, false,
                keyboardType: TextInputType.number, onChanged: (va) {
              calcAll();
            }),
            SizedBox(
              height: 10,
            ),
            TextF(
              'GST (%)',
              _gstController,
              false,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                calcAll();
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
                  // ElevatedButton(
                  //     onPressed: () {
                  //       if (_gstController.text.isNotEmpty &&
                  //           _meterRentController.text.isNotEmpty &&
                  //           _energyChargesPerUnitController.text.isNotEmpty &&
                  //           _currentReadingController.text.isNotEmpty &&
                  //           _previousReadingController.text.isNotEmpty) {
                  //         double energyCharge = double.parse(
                  //                 _energyChargesPerUnitController.text) *
                  //             totalConsumed;
                  //         _energyChargeController.text =
                  //             energyCharge.toString();
                  //         double totalAmount = energyCharge +
                  //             double.parse(_meterRentController.text) +
                  //             double.parse(_gstController.text) *
                  //                 0.01 *
                  //                 double.parse(_meterRentController.text);
                  //         setState(() {
                  //           _totalAmountController.text =
                  //               totalAmount.toString();
                  //           double netPayable = totalAmount.roundToDouble();
                  //           _netPayableController.text = netPayable.toString();
                  //         });
                  //       }
                  //     },
                  //     child: Text("Re-Calculate All")),
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

                        showAutoDismissDialog(
                            context, "Data added successfully");
                        Future.delayed(Duration(seconds: 2), () {
                          Navigator.pushReplacementNamed(context, '/admin');
                        });
                      }

                      // Add data to the database
                    },
                    style: ElevatedButton.styleFrom(
                      // primary: Colors.blue, // Make the button more vibrant
                      padding: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 30), // Make the button bigger
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