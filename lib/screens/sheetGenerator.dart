import "package:electric/resources/changingDatabase.dart";
import "package:flutter/material.dart";
import 'dart:js' as js;
import 'dart:convert';
import 'dart:html' as html;
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';

class CSVGeneratorScreen extends StatefulWidget {
  const CSVGeneratorScreen({super.key});

  @override
  State<CSVGeneratorScreen> createState() => _CSVGeneratorScreenState();
}

class _CSVGeneratorScreenState extends State<CSVGeneratorScreen> {
  String? selectedType;
  String? selectedMonth;
  String? selectedYear;
  final List<String> types = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    'Domestic',
    'Shopkeeper',
    'Director'
  ];
  final List<String> months = [
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
  final List<String> years =
      List<String>.generate(30, (int index) => (2015 + index).toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Generate CSV'),
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Type',
                  ),
                  value: selectedType,
                  items: types
                      .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                      .toList(),
                  onChanged: (String? value) {
                    setState(() {
                      selectedType = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Starting Month',
                  ),
                  value: selectedMonth,
                  items: months
                      .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                      .toList(),
                  onChanged: (String? value) {
                    setState(() {
                      selectedMonth = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Year',
                  ),
                  value: selectedYear,
                  items: years
                      .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                      .toList(),
                  onChanged: (String? value) {
                    setState(() {
                      selectedYear = value;
                    });
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  Future<void> downloadCSV() async {
                    try {
                      var data = await fetchBillsbyType(
                          selectedType!, selectedMonth!, selectedYear!);
                      if (data != null && data is List<Map<String, dynamic>>) {
                        generateExcel(data);
                      } else {
                        // Handle the case where data is not in the expected format or is null
                        print(
                            "Received data is not in the expected format or is null.");
                      }
                    } catch (e) {
                      // Handle any errors that might occur during fetching or casting
                      print("An error occurred: $e");
                    }
                  }

                  print('Generating CSV');
                  if (selectedType == null ||
                      selectedMonth == null ||
                      selectedYear == null) {
                    showAboutDialog(
                        context: context,
                        applicationName: 'Error',
                        children: [Text('Please select all fields')]);
                  } else {
                    print(fetchBillsbyType(
                        selectedType!, selectedMonth!, selectedYear!));
                    downloadCSV();
                  }
                },
                child: Text('Generate CSV'),
              ),
            ]));
  }

//   void generateCSV(data) {
//     // data is List<Map<String, dynamic>>
//     // now create a csv file from that data and give a prompt to user to download it
//     String csv = 'Name,Amount,Date\n';
//     for (var i = 0; i < data.length; i++) {
//       csv += data[i]['name'] +
//           ',' +
//           data[i]['amount'].toString() +
//           ',' +
//           data[i]['date'] +
//           '\n';
//     }
//     final blob = Blob([csv]);
//     final url = Url.createObjectUrlFromBlob(blob);
//     js.context.callMethod('open', [url]);

// }

  // void generateExcel(List<Map<String, dynamic>> data) {
  //   var excel = Excel.createExcel(); // Create a new Excel document
  //   // Add or modify a sheet named 'Sheet1'
  //   var sheetObject = excel['Sheet1'];

  //   // Define a cell style for headers
  //   // Convert RGB color to ExcelColor
  //   DateTime parseStartDate = DateTime.parse(data[0]['startDate'])
  //       .toUtc()
  //       .add(Duration(hours: 5, minutes: 30));
  //   DateTime parseEndDate = DateTime.parse(data[0]['endDate'])
  //       .toUtc()
  //       .add(Duration(hours: 5, minutes: 30));

  //   DateFormat formatter = DateFormat(
  //       'dd-MM-yyyy'); // This is to format the date in Year-Month-Day format
  //   String formattedStartDate = formatter.format(parseStartDate);
  //   String formattedEndDate = formatter.format(parseEndDate);

  //   CellStyle headerStyle = CellStyle(
  //     fontFamily: getFontFamily(FontFamily.Calibri),
  //     bold: true,
  //     verticalAlign: VerticalAlign.Center,
  //     horizontalAlign: HorizontalAlign.Center,
  //   );

  //   // Add titles and headers
  //   var headers = [
  //     'S.No',
  //     'Name of Consumer',
  //     'Type ${selectedType} Qtr. No',
  //     'Amount (Rs)'
  //   ];
  //   List<CellValue> titles = [
  //     TextCellValue('Indian Institute of Technology, Ropar'),
  //     TextCellValue(
  //         'Electricity Bills for the Period of ${formattedStartDate} to ${formattedEndDate}')
  //   ];

  //   for (int i = 0; i < titles.length; i++) {
  //     sheetObject.updateCell(
  //         CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i),
  //         TextCellValue(titles[i].toString()),
  //         cellStyle: headerStyle);
  //     sheetObject.merge(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i),
  //         CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: i));
  //   }

  //   // Populate header row
  //   for (int i = 0; i < headers.length; i++) {
  //     sheetObject.updateCell(
  //         CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 2),
  //         TextCellValue(headers[i]),
  //         cellStyle: headerStyle);
  //   }
  //   print("Header row populated successfully!");

  //   // Populate data rows
  //   int rowIndex = 3;
  //   for (var row in data) {
  //     String serialNo = (rowIndex - 2).toString();

  //     sheetObject.updateCell(
  //         CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex),
  //         TextCellValue(serialNo));
  //     sheetObject.updateCell(
  //         CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex),
  //         TextCellValue(row['userName'].toString()));
  //     sheetObject.updateCell(
  //         CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex),
  //         TextCellValue((row['houseNumber'].toString())));
  //     sheetObject.updateCell(
  //         CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex),
  //         TextCellValue("₹ " +row['totalAmount'].toString()));
  //     rowIndex++;
  //   }

  //   // Save the file
  //   var fileBytes = excel.save();

  //   print("Excel generated successfully!");
  // }

  // void generateCSV(List<Map<String, dynamic>> data) {
  //   DateTime parseStartDate = DateTime.parse(data[0]['startDate'])
  //       .toUtc()
  //       .add(Duration(hours: 5, minutes: 30));
  //   DateTime parseEndDate = DateTime.parse(data[0]['endDate'])
  //       .toUtc()
  //       .add(Duration(hours: 5, minutes: 30));

  //   DateFormat formatter = DateFormat(
  //       'dd-MM-yyyy'); // This is to format the date in Year-Month-Day format
  //   String formattedStartDate = formatter.format(parseStartDate);
  //   String formattedEndDate = formatter.format(parseEndDate);

  //   String csvFile = 'Indian Institute of Technology\, Ropar\n';
  //   csvFile +=
  //       'Electricity Bills for the period of ${formattedStartDate} to ${formattedEndDate}\n';
  //   // String csv = 'S.No,Name of Consumer,Type $selectedType Qtr No.,Amount\n';
  //   csvFile += 'S.No,Name of Consumer,Type $selectedType Qtr No.,Amount\n';
  //   for (var i = 0; i < data.length; i++) {
  //     csvFile +=
  //         '${i + 1},${data[i]['userName']},${data[i]['houseNumber']},${data[i]['totalAmount']}\n';
  //   }
  //   // Encode the csv string to UTF-8 bytes
  //   List<int> bytes = utf8.encode(csvFile);
  //   // Create a Blob from the bytes
  //   final blob = html.Blob([bytes]);
  //   // Create an URL from the Blob
  //   final url = html.Url.createObjectUrlFromBlob(blob);
  //   // Use the dart:html library to create a link element and download the file
  //   html.AnchorElement(href: url)
  //     ..setAttribute("download", "data.csv")
  //     ..click();
  //   // Cleanup the URL object
  //   html.Url.revokeObjectUrl(url);
  // }
void generateExcel(List<Map<String, dynamic>> data) {
  var excel = Excel.createExcel(); // Create a new Excel document
  // Modify a sheet named 'Sheet1'
  var sheetObject = excel['Sheet1'];

  // Define styles
  CellStyle headerStyle = CellStyle(
    fontFamily: getFontFamily(FontFamily.Calibri),
    bold: true,
    verticalAlign: VerticalAlign.Center,
    horizontalAlign: HorizontalAlign.Center,
    fontSize: 16,
    // backgroundColorHex: "#CCCCCC",  // Light gray background for headers
  );

  CellStyle titleStyle = CellStyle(
    fontFamily: getFontFamily(FontFamily.Calibri),
    bold: true,
    fontSize: 14,
    verticalAlign: VerticalAlign.Center,
    horizontalAlign: HorizontalAlign.Center,
  );

  // Formatting dates
  DateTime parseStartDate = DateTime.parse(data[0]['startDate'])
      .toUtc()
      .add(Duration(hours: 5, minutes: 30));
  DateTime parseEndDate = DateTime.parse(data[0]['endDate'])
      .toUtc()
      .add(Duration(hours: 5, minutes: 30));

  DateFormat formatter = DateFormat('dd-MM-yyyy');
  String formattedStartDate = formatter.format(parseStartDate);
  String formattedEndDate = formatter.format(parseEndDate);

  // Set titles
  List<CellValue> titles = [
    TextCellValue('Indian Institute of Technology, Ropar'),
    TextCellValue('Electricity Bills for the Period of $formattedStartDate to $formattedEndDate')
  ];

  // Title rows
  for (int i = 0; i < titles.length; i++) {
    sheetObject.updateCell(
      CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i),
      (titles[i]),
      cellStyle: titleStyle
    );
    sheetObject.merge(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i),
        CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: i));
  }

  // Headers
  List<CellValue> headers = [
    TextCellValue('S.No'),
    TextCellValue('Name of Consumer'),
    TextCellValue('Type $selectedType Qtr. No'),
    TextCellValue('Amount (Rs)')
  ];
  for (int i = 0; i < headers.length; i++) {
    sheetObject.updateCell(
      CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 2),
      headers[i],
      cellStyle: headerStyle
    );
    // sheetObject.col(i).autoFit();
    sheetObject.setColumnAutoFit(i);
  }

  // Data rows
  int rowIndex = 3;
  for (var row in data) {
    sheetObject.updateCell(
      CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex),
      TextCellValue((rowIndex - 2).toString()));
    sheetObject.updateCell(
      CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex),
      TextCellValue(row['userName']));
    sheetObject.updateCell(
      CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex),
      TextCellValue(row['houseNumber']));
    sheetObject.updateCell(
      CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex),
      TextCellValue("₹ ${row['totalAmount'].toStringAsFixed(2)}"));
    rowIndex++;
  }

  // Adjust column widths based on content
  sheetObject.setColumnWidth(0, 10);
  sheetObject.setColumnWidth(1, 25);
  sheetObject.setColumnWidth(2, 20);
  sheetObject.setColumnWidth(3, 15);

  // Save the file
  var fileBytes = excel.save();

  print("Excel generated successfully!");
}

}
