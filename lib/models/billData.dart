
import 'dart:convert';

import 'package:electric/models/comment.dart';

class BillData {
  String consumerName;
  String houseNumber;
  int meterNumber;
  String type;
  DateTime startDate;
  DateTime endDate;
  int numberOfDays;
  int previousReading;
  int currentReading;
  int totalUnitsConsumed;
  int energyCharge;
  int meterRent;
  int gst;
  double totalAmount;
  int netPayable;
  DateTime dateOfIssue;
  List<Comment>? comments;


  BillData({
    required this.consumerName,
    required this.houseNumber,
    required this.meterNumber,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.numberOfDays,
    required this.previousReading,
    required this.currentReading,
    required this.totalUnitsConsumed,
    required this.energyCharge,
    required this.meterRent,
    required this.gst,
    required this.totalAmount,
    required this.netPayable,
    required this.dateOfIssue,
    this.comments,
  });

  Map<String,dynamic> toJson(BillData data){
    return {
        'consumerName': data.consumerName,
        'houseNumber': data.houseNumber,
        'meterNumber': data.meterNumber,
        'type': data.type,
        'startDate': data.startDate.toLocal().toIso8601String(),
        'endDate': data.endDate.toLocal().toIso8601String(),
        'numberOfDays': data.numberOfDays,
        'previousReading': data.previousReading,
        'currentReading': data.currentReading,
        'totalUnitsConsumed': data.totalUnitsConsumed,
        'energyCharge': data.energyCharge,
        'meterRent': data.meterRent,
        'gst': data.gst,
        'totalAmount': data.totalAmount,
        'netPayable': data.netPayable,
        'dateOfIssue': data.dateOfIssue.toLocal().toIso8601String(),
        'comments': data.comments,
    };
}
factory BillData.fromJson(Map<String, dynamic> json) {

  String? consumerName = json['consumerName'];
  String? houseNumber = json['houseNumber'];
  int? meterNumber = json['meterNumber'];
  String? type = json['type'];
  DateTime? startDate = json['startDate'] != null ? DateTime.parse(json['startDate']) : null;
  DateTime? endDate = json['endDate'] != null ? DateTime.parse(json['endDate']) : null;
  int? numberOfDays = json['numberOfDays'];
  int? previousReading = json['previousReading'];
  int? currentReading = json['currentReading'];
  int? totalUnitsConsumed = json['totalUnitsConsumed'];
  int? energyCharge = json['energyCharge'];
  int? meterRent = json['meterRent'];
  int? gst = json['gst'];
  double? totalAmount = json['totalAmount'];
  int? netPayable = json['netPayable'];
  DateTime? dateOfIssue = json['dateOfIssue'] != null ? DateTime.parse(json['dateOfIssue']) : null;
  List<Comment>? comments = json['comments'] != null ? (json['comments'] as List).map((i) => Comment.fromJson(i)).toList() : null;

  if (consumerName == null) {
    print('consumerName is null');
  }
  if (houseNumber == null) {
    print('houseNumber is null');
  }
  if (meterNumber == null) {
    print('meterNumber is null');
  }
  if (type == null) {
    print('type is null');
  }
  if (startDate == null) {
    print('startDate is null');
  }
  if (endDate == null) {
    print('endDate is null');
  }
  if (numberOfDays == null) {
    print('numberOfDays is null');
  }
  if (previousReading == null) {
    print('previousReading is null');
  }
  if (currentReading == null) {
    print('currentReading is null');
  }
  if (totalUnitsConsumed == null) {
    print('totalUnitsConsumed is null');
  }
  if (energyCharge == null) {
    print('energyCharge is null');
  }
  if (meterRent == null) {
    print('meterRent is null');
  }
  if (gst == null) {
    print('gst is null');
  }
  if (totalAmount == null) {
    print('totalAmount is null');
  }
  if (netPayable == null) {
    print('netPayable is null');
  }
  if (dateOfIssue == null) {
    print('dateOfIssue is null');
  }
  if (comments == null) {
    print('comments is null');
  }

  return BillData(
    consumerName: consumerName!,
    houseNumber: houseNumber!,
    meterNumber: meterNumber!,
    type: type!,
    startDate: startDate!,
    endDate: endDate!,
    numberOfDays: numberOfDays!,
    previousReading: previousReading!,
    currentReading: currentReading!,
    totalUnitsConsumed: totalUnitsConsumed!,
    energyCharge: energyCharge!,
    meterRent: meterRent!,
    gst: gst!,
    totalAmount: totalAmount!,
    netPayable: netPayable!,
    dateOfIssue: dateOfIssue!,
    comments: comments,
  );
}
}
