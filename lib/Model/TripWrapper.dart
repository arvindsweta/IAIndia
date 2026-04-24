import 'dart:convert';

class TripWrapper {
  // We keep the raw 'd' if you need it for the "Valid" check,
  // but we primarily use the 'trips' list.
  final String? rawStatus;
  final List<TripData> trips;

  TripWrapper({this.rawStatus, required this.trips});

  factory TripWrapper.fromJson(Map<String, dynamic> json) {
    var dValue = json['d'];
    List<TripData> tripList = [];
    String? status;

    if (dValue is String) {
      status = dValue; // Holds "Valid" or the JSON string
      try {
        // Try to decode d as a list of trips
        var decoded = jsonDecode(dValue);
        if (decoded is List) {
          tripList = decoded.map((item) => TripData.fromJson(item)).toList();
        }
      } catch (e) {
        // If it's just a string like "Valid", jsonDecode might fail or not be a list
        print("Note: 'd' is a simple string, not a trip list.");
      }
    }

    return TripWrapper(rawStatus: status, trips: tripList);
  }
}

class TripData {
  final int id;
  final String bookingID;
  final String dateRange;
  final String tripStatus;
  final List<TripMember> members;

  TripData({required this.id, required this.bookingID, required this.dateRange, required this.tripStatus, required this.members});

  factory TripData.fromJson(Map<String, dynamic> json) {
    return TripData(
      id: json['ID'] ?? 0,
      bookingID: json['bookingID'] ?? '',
      dateRange: json['dateRange'] ?? '',
      tripStatus: json['TripStatus'] ?? '',
      members: (json['members'] as List?)?.map((m) => TripMember.fromJson(m)).toList() ?? [],
    );
  }
}

class TripMember {
  final String name;
  final String FamilyName;
  final String email;
  final String reportTo;
  final String MemberID;
  final String FromCity;
  final String ToCity;
  final String Remarks;



  TripMember({required this.name, required this.email,required this.FamilyName,required this.reportTo,required this.MemberID,
    required this.FromCity,required this.ToCity,required this.Remarks});

  factory TripMember.fromJson(Map<String, dynamic> json) {
    return TripMember(
      name: json['name'] ?? '',
      FamilyName: json['FamilyName'] ?? '',
      email: json['Email'] ?? '',
      reportTo: json['ReportTo'] ?? '',
      MemberID: json['MemberID'] ?? '',
      FromCity: json['FromCity'] ?? '',
      ToCity: json['ToCity'] ?? '',
      Remarks: json['Remarks'] ?? '',
    );
  }
}
