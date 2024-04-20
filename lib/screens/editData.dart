import "package:electric/models/billData.dart";
import "package:electric/resources/changingDatabase.dart";
import "package:flutter/material.dart";
import "package:electric/widgets/stflTextF.dart";

void showAutoDismissDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop(true);
      });
      return AlertDialog(
        content: Text(message),
      );
    },
  );
}

class EditScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final String userId;
  const EditScreen({Key? key, required this.data, required this.userId})
      : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController _consumerNameController = TextEditingController();
  TextEditingController _houseNumberController = TextEditingController();
  TextEditingController _meterNumberController = TextEditingController();
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
  TextEditingController _totalEnergyChargeController = TextEditingController();
  TextEditingController _consumerTypeController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _consumerNameController.text = widget.data['consumerName'];
    _houseNumberController.text = widget.data['houseNumber'];
    _meterNumberController.text = widget.data['meterNumber'].toString();
    // _typeController.text = widget.data['type'];
    _startDate = DateTime.parse(widget.data['startDate']);
    _endDate = DateTime.parse(widget.data['endDate']);
    _issueDate = DateTime.parse(widget.data['dateOfIssue']);
    _startDateController.text = widget.data['startDate'];
    _endDateController.text = widget.data['endDate'];
    _numberOfDaysController.text = widget.data['numberOfDays'].toString();
    _previousReadingController.text = widget.data['previousReading'].toString();
    _currentReadingController.text = widget.data['currentReading'].toString();
    _totalUnitsConsumedController.text =
        widget.data['totalUnitsConsumed'].toString();
    _energyChargeController.text = widget.data['energyCharge'].toString();
    _meterRentController.text = widget.data['meterRent'].toString();
    _gstController.text = widget.data['gst'].toString();
    _totalAmountController.text = widget.data['totalAmount'].toString();
    _netPayableController.text = widget.data['netPayable'].toString();
    _dateOfIssueController.text = widget.data['dateOfIssue'];
    _consumerTypeController.text = widget.data['type'];
    double? totalUnits = double.tryParse(_totalUnitsConsumedController.text);
    double? energyCharge = double.tryParse(_energyChargeController.text);
    if (totalUnits != null && energyCharge != null) {
      _totalEnergyChargeController.text =
          (totalUnits * energyCharge).toString();
    } else {
      _totalEnergyChargeController.text =
          '0'; // or handle this case appropriately
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      calculateEnergy();
      calculateTotalAmount();
    }

    Future saveData(BuildContext contxt) async {
      try {
        BillData data = BillData.fromJson({
          'consumerName': _consumerNameController.text,
          'houseNumber': _houseNumberController.text,
          'meterNumber': int.tryParse(_meterNumberController.text),
          'type': _consumerTypeController.text,
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
          'totalAmount': int.tryParse(_totalAmountController.text),
          'netPayable': int.tryParse(_netPayableController.text),
          'dateOfIssue': _issueDate.toLocal().toString().split(' ')[0],
        });

        updateUserData(widget.userId, data, widget.data['_id']).then(
            (value) => showAutoDismissDialog(contxt, "Update Successful"));
        return 'success';
      } catch (e) {
        showAutoDismissDialog(contxt, e.toString());
      }
    }

    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Bill'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              TextF(
                hintText: 'Consumer Name',
                controller: _consumerNameController,
                keyboardType: TextInputType.text,
              ),
              TextF(
                hintText: 'House Number',
                controller: _houseNumberController,
              ),
              TextF(
                hintText: 'Meter Number',
                controller: _meterNumberController,
                keyboardType: TextInputType.number,
              ),
              TextF(
                hintText: 'Type',
                controller: _consumerTypeController,
                keyboardType: TextInputType.text,
              ),
              ElevatedButton(
                onPressed: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _startDate,
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
                        calcAll();
                        _numberOfDaysController.text =
                            (_endDate.difference(_startDate).inDays + 1)
                                .toString();
                      }
                    });
                  }
                },
                child: Text(_startDate != null
                    ? "${_startDate.toLocal().toString().split(' ')[0]}"
                    : 'Select Start Date'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _endDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    print('Selected date: $pickedDate');
                    // Here you can assign pickedDate to your variable
                    setState(() {
                      calcAll();
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
                child: Text(_endDate != null
                    ? "${_endDate.toLocal().toString().split(' ')[0]}"
                    : 'Select End Date'),
              ),
              TextF(
                hintText: 'Number of Days',
                controller: _numberOfDaysController,
                keyboardType: TextInputType.number,
                onChanged: (str) {
                  calcAll();
                },
              ),
              TextF(
                hintText: 'Previous Reading',
                controller: _previousReadingController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (_currentReadingController.text.isNotEmpty) {
                    calcAll();
                    _totalUnitsConsumedController.text =
                        (int.tryParse(_currentReadingController.text)! -
                                int.tryParse(_previousReadingController.text)!)
                            .toString();
                  }
                },
              ),
              TextF(
                hintText: 'Current Reading',
                controller: _currentReadingController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (_previousReadingController.text.isNotEmpty) {
                    calcAll();
                    _totalUnitsConsumedController.text =
                        (int.tryParse(_currentReadingController.text)! -
                                int.tryParse(_previousReadingController.text)!)
                            .toString();
                  }
                },
              ),
              TextF(
                hintText: 'Total Units Consumed',
                controller: _totalUnitsConsumedController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  calcAll();
                },
              ),
              TextF(
                hintText: 'Per Unit Energy Charge',
                controller: _energyChargeController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  calcAll();
                },
              ),
              TextF(
                hintText: 'Total Energy Charge',
                controller: _totalEnergyChargeController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  calcAll();
                },
              ),
              TextF(
                hintText: 'Meter Rent',
                controller: _meterRentController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  calcAll();
                },
              ),
              TextF(
                hintText: 'GST',
                controller: _gstController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  calcAll();
                },
              ),
              TextF(
                hintText: 'Total Amount',
                controller: _totalAmountController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  calcAll();
                },
              ),
              TextF(
                controller: _netPayableController,
                hintText: 'Net Payable',
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  calcAll();
                },
              ),

              // issue date elevated button
              ElevatedButton(
                onPressed: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _issueDate,
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
                child: Text(_issueDate != null
                    ? "${_issueDate.toLocal().toString().split(' ')[0]}"
                    : 'Select Issue Date'),
              ),

              ElevatedButton(
                  onPressed: () async {
                    if (await saveData(context) == 'success') {
                      print("success");
                      Navigator.pop(context, true);
                    } else {
                      showAutoDismissDialog(context, "Error updating user");
                    }
                  },
                  child: Text('Save Data')),
            ],
          ),
        ),
      ),
    );
  }
}
