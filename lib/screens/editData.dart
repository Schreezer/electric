import "package:electric/models/billData.dart";
import "package:flutter/material.dart";
import "package:electric/widgets/stflTextF.dart";

// Widget TextF(String hintText, TextEditingController controller, bool editable,
//     {TextInputType keyboardType = TextInputType.text,
//     void Function(String)? onChanged}) {
//   return TextField(
//     enabled: editable,
//     controller: controller,
//     keyboardType: keyboardType,
//     onChanged: onChanged,
//     decoration: InputDecoration(
//       labelText: hintText,
//       hintText: hintText,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//     ),
//   );
// }

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
  // Future editData(BuildContext contxt) async{
  //   try{
  //     String value = await
  //   }
  // }
class EditScreen extends StatefulWidget {
  final Map<String,dynamic> data;
  const EditScreen(
      {Key? key, required this.data})
      : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {

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
    _totalUnitsConsumedController.text = widget.data['totalUnitsConsumed'].toString();
    _energyChargeController.text = widget.data['energyCharge'].toString();
    _meterRentController.text = widget.data['meterRent'].toString();
    _gstController.text = widget.data['gst'].toString();
    _totalAmountController.text = widget.data['totalAmount'].toString();
    _netPayableController.text = widget.data['netPayable'].toString();
    _dateOfIssueController.text = widget.data['dateOfIssue'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
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
              controller: _typeController,
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
                    _endDate = pickedDate;
                    selectedEnd = true;
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
            ),
            TextF(
              hintText: 'Previous Reading',
              controller: _previousReadingController,
              keyboardType: TextInputType.number,
            ),
            TextF(
              hintText: 'Current Reading',
              controller: _currentReadingController,
              keyboardType: TextInputType.number,
            ),
            TextF(
              hintText: 'Total Units Consumed',
              controller: _totalUnitsConsumedController,
              keyboardType: TextInputType.number,
            ),
            TextF(
              hintText: 'Energy Charge',
              controller: _energyChargeController,
              keyboardType: TextInputType.number,
            ),
            TextF(
              hintText: 'Meter Rent',
              controller: _meterRentController,
              keyboardType: TextInputType.number,
            ),
            TextF(
              hintText: 'GST',
              controller: _gstController,
              keyboardType: TextInputType.number,
            ),
            TextF(
              hintText: 'Total Amount',
              controller: _totalAmountController,
              keyboardType: TextInputType.number,
            ),
            TextF(controller: _netPayableController, hintText: 'Net Payable', keyboardType: TextInputType.number),
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

            ElevatedButton(onPressed: (){
              
            }, child: Text('Save Data')),
          ],
        ),
      ),
    );
  }
}