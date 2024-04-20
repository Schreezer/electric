import "package:electric/models/billData.dart";
import "package:flutter/material.dart";

class User {
  String? userName;
  String email;
  String? consumerType;
  String? houseNumber;
  String userType;
  List<BillData>? data;
  String? otp;
  DateTime? otpExpiry;
  String id;

  User({
    this.userName,
    required this.id,
    required this.email,
    this.houseNumber,
    required this.userType,
    this.data,
    this.otp,
    this.otpExpiry,
    this.consumerType,
  });

  // void addBillData(BillData newBillData) {
  //   data.add(newBillData);
  // }
  // factory User.fromSnap(DocumentSnapshot snap) {
  //   return User(
  //     id: snap['uid'],
  //     email: snap['mailId'],
  //     userType: snap['name'],
  //     houseNumber: snap['houseId'],
  //   );
  // }
}
