import 'dart:async';

import 'package:electric/models/billData.dart';
import 'package:electric/resources/changingDatabase.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<BillData> bills = [];
  BillData? selectedBill;
   List<String> billIds = [];
  late String selectedBillId;

  Future<void> getBills() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('id');
    print("the id is :");
    print(id);
    var fetchedBills = await getUserData(id!) ;
    List<BillData> loadedBills = [];
    List<String> loadedIds = [];
    for (var bill in fetchedBills['data']) {
      print("we are ade");
      loadedBills.add(BillData.fromJson(bill));
      print("the bill id is :");
      print(bill['_id']);
      loadedIds.add(bill['_id']);
    }
    for (id in loadedIds) {
      print("the all bill ids are :");
      print(id);
    }
    setState(() {
      bills = loadedBills;
      billIds = loadedIds;
      selectedBill = bills.isNotEmpty ? bills[0] : null;
      selectedBillId = billIds.isNotEmpty ? billIds[0] : '';
    });
  }

  @override
  void initState() {
    super.initState();
    getBills();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        leading: 
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Confirm Logout'),
                    content: Text('Are you sure you want to logout?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          // Add logout functionality here
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.remove('jwt');
                          prefs.remove('userType');
                          prefs.remove('id');
                          prefs.remove('email');
                          print("the token si :");
                          print(prefs.getString('token'));
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Text('Logout'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        
        backgroundColor: Colors.teal,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 8),
              _buildHeaderSection(),
              const SizedBox(height: 24),
              _buildInformationCard(
                title: 'HOUSE NUMBER',
                value: selectedBill?.houseNumber ?? '',
                iconData: Icons.home,
                color: Colors.blue,
              ),
              const SizedBox(height: 16),
              _buildInformationCard(
                title: 'CONSUMER NAME',
                value: selectedBill?.consumerName ?? '',
                iconData: Icons.person,
                color: Colors.teal,
              ),
              const SizedBox(height: 16),
              ReadingSection(
                previousReading: selectedBill?.previousReading.toDouble() ?? 0,
                currentReading: selectedBill?.currentReading.toDouble() ?? 0,
                netReading: selectedBill?.totalUnitsConsumed.toDouble() ?? 0,
                context: context,
              ),
              const SizedBox(height: 16),
              billSummarySection(
                perUnitCharge: selectedBill!.energyCharge.toDouble() ,
                totalEnergyCharge: selectedBill?.totalAmount.toDouble() ?? 0,
                meterRent: selectedBill?.meterRent.toDouble() ?? 0,
                gstPercentage: selectedBill?.gst.toDouble() ?? 0,
                totalAmount: selectedBill?.totalAmount ?? 0,
                totalAmountPayable: selectedBill?.netPayable.toDouble() ?? 0,
              ),
              const SizedBox(height: 30),
              // a button to route to comments screen
              
              ElevatedButton(
                onPressed: ()async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  // get bill id from the index of the selectedBill from the Bills list
                  selectedBillId = billIds[bills.indexOf(selectedBill!)];
                  print("the selected bill id is :$selectedBillId");
                  Navigator.pushNamed(context, '/comments', arguments: {
                    'userId': prefs.getString('id') ,
                    'billId': selectedBillId,
                  });
                },
                child: const Text('Comments'),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return DropdownButton<BillData>(
      value: selectedBill,
      onChanged: (BillData? newValue) {
        setState(() {
          selectedBill = newValue!;
          // seelctedBillId = billIds[bills.indexOf(newValue)];
        });
      },
      items: bills.map<DropdownMenuItem<BillData>>((BillData bill) {
        return DropdownMenuItem<BillData>(
          value: bill,
          child: Text("${DateTime.parse(bill.dateOfIssue.toString()).toUtc().add(Duration(hours: 5, minutes: 30)).toString().split(' ')[0]}"),
        );
      }).toList(),
      underline: Container(height: 2, color: Colors.teal),
    );
  }

  Widget _buildBillDetails(BillData bill) {
    return Column(
      children: [
        _buildInformationCard(
          title: 'HOUSE NUMBER',
          value: bill.houseNumber,
          iconData: Icons.home,
          color: Colors.blue,
        ),
        const SizedBox(height: 16),
        _buildInformationCard(
          title: 'CONSUMER NAME',
          value: bill.consumerName,
          iconData: Icons.person,
          color: Colors.teal,
        ),
        const SizedBox(height: 16),
        _buildInformationCard(
          title: 'METER NUMBER',
          value: bill.meterNumber.toString(),
          iconData: Icons.numbers,
          color: Colors.green,
        ),
        const SizedBox(height: 16),
        _buildInformationCard(
          title: 'NET PAYABLE',
          value: '\$${bill.netPayable.toStringAsFixed(2)}',
          iconData: Icons.money_off,
          color: Colors.red,
        ),
      ],
    );
  }

  Widget _buildInformationCard({
    required String title,
    required String value,
    required IconData iconData,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(iconData, color: color),
        title: Text(title),
        subtitle: Text(
          value,
          style: Theme.of(context).textTheme.headline6?.copyWith(color: color),
        ),
      ),
    );
  }
}

  Widget billSummarySection({
    required double perUnitCharge,
    required double totalEnergyCharge,
    required double meterRent,
    required double gstPercentage,
    required double totalAmount,
    required double totalAmountPayable,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(top: 20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildBillRow('Per Unit Charge', '$perUnitCharge per kWh'),
            buildBillRow('Total Energy Charge', '$totalEnergyCharge kWh'),
            buildBillRow('Meter Rent', '$meterRent'),
            buildBillRow('GST ($gstPercentage%)',
                '${(gstPercentage / 100) * meterRent}'),
            const Divider(),
            buildBillRow('Total Amount', '$totalAmount', isTotal: true),
            const Divider(),
            buildBillRow('Total Amount Payable', '$totalAmountPayable',
                isTotal: true),
          ],
        ),
      ),
    );
  }

    Widget buildBillRow(String title, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.teal : null,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.teal : null,
            ),
          ),
        ],
      ),
    );
  }


  Widget ReadingSection({
    required double previousReading,
    required double currentReading,
    required double netReading,
    required BuildContext context,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      margin: const EdgeInsets.only(top: 20.0),
      decoration: BoxDecoration(
        color: Colors.blue[100], // Change as per your design
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'READINGS',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          const SizedBox(height: 24),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildReadingIndicator('PREVIOUS', previousReading, context),
                VerticalDivider(
                    color: Colors.teal[300], thickness: 1, width: 30),
                _buildReadingIndicator('CURRENT', currentReading, context),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Total units consumed: ${netReading.toStringAsFixed(2)} units',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.teal[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadingIndicator(
      String title, double reading, BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            reading.toStringAsFixed(2),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

