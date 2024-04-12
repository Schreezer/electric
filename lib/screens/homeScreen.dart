import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String _selectedMonth;
  late String _selectedYear;

  final List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  final List<String> _years = [
    '2022', '2023', '2024', '2025' // Add more years if needed
  ];

  final String _houseNumber = '999'; // Example house number
  final String _consumerName = 'CONGMEN 224'; // Example consumer name

  final double _previousReading = 60.00;
  final double _currentReading = 100.00;

  final double _perUnitCharge = 5.50;
  final double _totalEnergyCharge = 220.00;
  final double _meterRent = 50.00;
  final double _gstPercentage = 18.00; // Represented as a percentage
  final double _totalAmount = 270.00;

  @override
  void initState() {
    super.initState();
    _selectedMonth = _months[DateTime.now().month - 1];
    _selectedYear = DateTime.now().year.toString();
  }

  @override
  Widget build(BuildContext context) {
    double netReading = _currentReading - _previousReading;
    double gstAmount = _meterRent * (_gstPercentage / 100);
    double total = _totalEnergyCharge + gstAmount;
    double totalAmountPayable = total.roundToDouble();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.teal,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 8),
              _buildHeaderSection(context),
              const SizedBox(height: 24),
              _buildInformationCard(
                title: 'HOUSE NUMBER',
                value: _houseNumber,
                iconData: Icons.home,
                color: Colors.blue,
              ),
              const SizedBox(height: 16),
              _buildInformationCard(
                title: 'CONSUMER NAME',
                value: _consumerName,
                iconData: Icons.person,
                color: Colors.teal,
              ),
              const SizedBox(height: 16),
              ReadingSection(
                previousReading: _previousReading,
                currentReading: _currentReading,
                netReading: netReading,
              ),
              const SizedBox(height: 16),
              billSummarySection(
                perUnitCharge: _perUnitCharge,
                totalEnergyCharge: _totalEnergyCharge,
                meterRent: _meterRent,
                gstPercentage: _gstPercentage,
                totalAmount: _totalAmount,
                totalAmountPayable: totalAmountPayable,
              ),
              const SizedBox(height: 30),
              settingsButton(), // Added method for settings button
              const SizedBox(height: 40), // Additional space at the bottom
            ],
          ),
        ),
      ),
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

  Widget _buildHeaderSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildMonthYearDropdown(_selectedMonth, _months, (String? newValue) {
          setState(() {
            _selectedMonth = newValue!;
          });
        }),
        _buildMonthYearDropdown(_selectedYear, _years, (String? newValue) {
          setState(() {
            _selectedYear = newValue!;
          });
        }),
      ],
    );
  }

  Widget _buildMonthYearDropdown(String selectedValue, List<String> items,
      ValueChanged<String?> onChanged) {
    return DropdownButton<String>(
      value: selectedValue,
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      underline: Container(height: 2, color: Colors.teal),
    );
  }

  Widget ReadingSection({
    required double previousReading,
    required double currentReading,
    required double netReading,
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

  Widget settingsButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        // Add functionality for settings button
      },
      icon: const Icon(Icons.settings),
      label: const Text('Settings'),
      backgroundColor: Colors.teal,
    );
  }
}
