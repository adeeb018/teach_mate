import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  double feeDue = 0.0;
  double feeTotal = 0.0;
  double feePaid = 0.0;
  String contact;
  String name;
  String remarks;
  String batch;
  String branch;
  String streamId;
  String status;
  Map<String, Programme> programmes;
  Timestamp? joiningDate;
  Timestamp? disconDate;
  String id = "";

  setId({required String id})=>this.id = id;

  Student({
    this.feeDue = 0.0,
    this.feeTotal = 0.0,
    this.feePaid = 0.0,
    required this.programmes,
    required this.contact,
    required this.name,
    required this.batch,
    required this.branch,
    this.streamId = "-1",
    required this.joiningDate,
    this.status = 'A',
    this.remarks= '',
    this.disconDate
  });

  factory Student.fromRawJson(String str) => Student.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Student.fromJson(Map<String, dynamic> json) => Student(
      feeDue: double.tryParse(json["feeDue"].toString()) ?? 0,
      feeTotal: double.tryParse(json["feeTotal"].toString()) ?? 0,
      programmes: Map.from(json["programmes"]).map(
              (k, v) => MapEntry<String, Programme>(k, Programme.fromJson(v))),
      contact: json["contact"],
      name: json["name"],
      feePaid: json["feePaid"],
      batch: json["batch"],
      branch: json["branch"],
      status: json["status"],
      remarks: json["remarks"] ?? "",
      joiningDate: json["joiningDate"],
      streamId: json["streamId"],
      disconDate: json["disconDate"]
  );

  Map<String, dynamic> toJson() => {
    "feeDue": feeDue,
    "feeTotal": feeTotal,
    "programmes": Map.from(programmes)
        .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    "contact": contact,
    "name": name,
    "feePaid": feePaid,
    "batch": batch,
    "branch": branch,
    "status": status,
    "remarks": remarks,
    "joiningDate": joiningDate,
    "streamId": streamId,
    "disconDate": disconDate
  };

  updatePaymentInfo() {
    feeTotal = 0;
    feePaid = 0;
    feeDue = 0;
    for (var element in programmes.values) {
      feeTotal += element.feeTotal;
      feePaid += element.feePaid;
      feeDue += element.feeDue;
    }
  }

  markDiscontinued() {
    status = "D";
    disconDate = Timestamp.now();
  }
}

class Programme {
  double feeDue;
  double feeTotal;
  double feePaid;

  Programme({
    required this.feeDue,
    required this.feeTotal,
    required this.feePaid,
  });

  factory Programme.fromRawJson(String str) =>
      Programme.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Programme.fromJson(Map<String, dynamic> json) => Programme(
    feeDue: double.tryParse(json["feeDue"].toString()) ?? 0,
    feeTotal: double.tryParse(json["feeTotal"].toString()) ?? 0,
    feePaid: double.tryParse(json["feePaid"].toString()) ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "feeDue": feeDue,
    "feeTotal": feeTotal,
    "feePaid": feePaid,
  };
}