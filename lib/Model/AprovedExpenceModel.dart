/*
class AprovedExpenceModel {
  List<AprovedItem>? d;

  AprovedExpenceModel({this.d});

  AprovedExpenceModel.fromJson(Map<String, dynamic> json) {
    if (json['d'] != null) {
      d = <AprovedItem>[];
      json['d'].forEach((v) {
        d!.add(new AprovedItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.d != null) {
      data['d'] = this.d!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
*/
import 'dart:convert';

class AprovedExpenceModel {
  // We keep the raw 'd' if you need it for the "Valid" check,
  // but we primarily use the 'trips' list.

  final List<AprovedItem> trips;

  AprovedExpenceModel({ required this.trips});

  factory AprovedExpenceModel.fromJson(Map<String, dynamic> json) {
    var dValue = json['d'];
    List<AprovedItem> tripList = [];
    String? status;

    if (dValue is String) {
      status = dValue; // Holds "Valid" or the JSON string
      try {
        // Try to decode d as a list of trips
        var decoded = jsonDecode(dValue);
        if (decoded is List) {
          tripList = decoded.map((item) => AprovedItem.fromJson(item)).toList();
        }
      } catch (e) {
        // If it's just a string like "Valid", jsonDecode might fail or not be a list
        print("Note: 'd' is a simple string, not a trip list.");
      }
    }

    return AprovedExpenceModel( trips: tripList);
  }
}

class AprovedItem {
  int? iD;
  int? tripID;
  int? expenceID;
  String? remarks;
  String? expenceDate;
  int? expenceAmount;
  int? createdBy;
  String? createdDate;
  String? status;
  String? firstName;
  String? familyName;
  String? emailID;
  int? reportTo;

  AprovedItem(
      {this.iD,
        this.tripID,
        this.expenceID,
        this.remarks,
        this.expenceDate,
        this.expenceAmount,
        this.createdBy,
        this.createdDate,
        this.status,
        this.firstName,
        this.familyName,
        this.emailID,
        this.reportTo});

  AprovedItem.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    tripID = json['TripID'];
    expenceID = json['ExpenceID'];
    remarks = json['Remarks'];
    expenceDate = json['ExpenceDate'];
    expenceAmount = json['ExpenceAmount'];
    createdBy = json['CreatedBy'];
    createdDate = json['CreatedDate'];
    status = json['Status'];
    firstName = json['FirstName'];
    familyName = json['FamilyName'];
    emailID = json['EmailID'];
    reportTo = json['ReportTo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['TripID'] = this.tripID;
    data['ExpenceID'] = this.expenceID;
    data['Remarks'] = this.remarks;
    data['ExpenceDate'] = this.expenceDate;
    data['ExpenceAmount'] = this.expenceAmount;
    data['CreatedBy'] = this.createdBy;
    data['CreatedDate'] = this.createdDate;
    data['Status'] = this.status;
    data['FirstName'] = this.firstName;
    data['FamilyName'] = this.familyName;
    data['EmailID'] = this.emailID;
    data['ReportTo'] = this.reportTo;
    return data;
  }
}
