import 'dart:convert';

class HotelPlaceModel {
  // We keep the raw 'd' if you need it for the "Valid" check,
  // but we primarily use the 'trips' list.
  final String? rawStatus;
  final List<HotelMapData> trips;

  HotelPlaceModel({this.rawStatus, required this.trips});

  factory HotelPlaceModel.fromJson(Map<String, dynamic> json) {
    var dValue = json['d'];
    List<HotelMapData> tripList = [];
    String? status;

    if (dValue is String) {
      status = dValue; // Holds "Valid" or the JSON string
      try {
        // Try to decode d as a list of trips
        var decoded = jsonDecode(dValue);
        if (decoded is List) {
          tripList = decoded.map((item) => HotelMapData.fromJson(item)).toList();
        }
      } catch (e) {
        // If it's just a string like "Valid", jsonDecode might fail or not be a list
        print("Note: 'd' is a simple string, not a trip list.");
      }
    }

    return HotelPlaceModel(rawStatus: status, trips: tripList);
  }
}

class HotelMapData {
  final int id;
  final String bookingID;
  final String dateRange;
  final String tripStatus;
  final List<HotelMember> members;

  HotelMapData({required this.id, required this.bookingID, required this.dateRange, required this.tripStatus, required this.members});

  factory HotelMapData.fromJson(Map<String, dynamic> json) {
    return HotelMapData(
      id: json['ID'] ?? 0,
      bookingID: json['bookingID'] ?? '',
      dateRange: json['dateRange'] ?? '',
      tripStatus: json['TripStatus'] ?? '',
      members: (json['members'] as List?)?.map((m) => HotelMember.fromJson(m)).toList() ?? [],
    );
  }
}

class HotelMember {
  final String name;
  final String FamilyName;
  final String email;
  final String reportTo;
  final String MemberID;
  final String Phone;
  final String hotel;
  final String HotelCityName;
  final String ChainName;
  final String HotelFromDate;
  final String HotelToDate;



  HotelMember( {required this.name,
    required this.FamilyName,
    required this.email,
    required this.Phone,
    required this.reportTo,
    required this.MemberID,
    required this.hotel,
    required this.HotelCityName,
    required this.HotelFromDate,
    required this.HotelToDate,
    required this.ChainName});

  factory HotelMember.fromJson(Map<String, dynamic> json) {
    return HotelMember(
      name: json['name'] ?? '',
      FamilyName: json['FamilyName'] ?? '',
      email: json['Email'] ?? '',
      Phone: json['Phone'] ?? '',
      reportTo: json['ReportTo'] ?? '',
      MemberID: json['MemberID'] ?? '',
      hotel: json['hotel'] ?? '',
      HotelCityName: json['HotelCityName'] ?? '',
      ChainName: json['ChainName'] ?? '',
      HotelFromDate: json['HotelFromDate'] ?? '',
      HotelToDate: json['HotelToDate'] ?? '',
    );
  }


}
