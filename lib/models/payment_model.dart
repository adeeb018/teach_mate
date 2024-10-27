import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentInfo {
  String id;
  String paymentId = "";
  String programId;
  Timestamp paymentDate;
  double amountPaid;
  double amountBalance;
  String user;
  String? remarks;

  PaymentInfo(
      {required this.id,
        required this.paymentDate,
        required this.programId,
        required this.amountPaid,
        required this.user,
        required this.amountBalance,
        this.remarks});

  factory PaymentInfo.fromRawJson(String str) =>
      PaymentInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  setPaymentId(String pId)=> paymentId = pId;

  factory PaymentInfo.fromJson(Map<String, dynamic> json) => PaymentInfo(
      id: json["id"],
      programId: json["programId"],
      paymentDate: json["paymentDate"],
      amountPaid: json["amountPaid"],
      amountBalance: json["amountBalance"],
      user: json['user'] ?? "",
      remarks: json["remarks"]);

  Map<String, dynamic> toJson() => {
    "id": id,
    "programId":programId,
    "paymentDate": paymentDate,
    "amountPaid": amountPaid,
    "amountBalance": amountBalance,
    "user": user,
    "remarks": remarks
  };
}


class Expense{
  String id;
  Timestamp paymentDate;
  double amountPaid;
  String? user;
  String? remarks;

  Expense(
      {required this.id,
        required this.paymentDate,
        required this.amountPaid,
        required this.user,
        this.remarks});

  factory Expense.fromRawJson(String str) =>
      Expense.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
      id: json["id"],
      paymentDate: json["paymentDate"],
      amountPaid: json["amountPaid"],
      user: json["user"] ?? "",
      remarks: json["remarks"]);

  Map<String, dynamic> toJson() => {
    "id": id,
    "paymentDate": paymentDate,
    "amountPaid": amountPaid,
    "user": user,
    "remarks": remarks
  };
}