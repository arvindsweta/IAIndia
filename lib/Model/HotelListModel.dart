import 'dart:convert';

class HotelListModel {
  // We keep the raw 'd' if you need it for the "Valid" check,
  // but we primarily use the 'trips' list.
  final String? rawStatus;
  final List<HotelItem> trips;

  HotelListModel({this.rawStatus, required this.trips});

  factory HotelListModel.fromJson(Map<String, dynamic> json) {
    var dValue = json['d'];
    List<HotelItem> hotelList = [];
    String? status;

    if (dValue is String) {
      status = dValue; // Holds "Valid" or the JSON string
      try {
        // Try to decode d as a list of trips
        var decoded = jsonDecode(dValue);
        if (decoded is List) {
          hotelList = decoded.map((item) => HotelItem.fromJson(item)).toList();
        }
      } catch (e) {
        // If it's just a string like "Valid", jsonDecode might fail or not be a list
        print("Note: 'd' is a simple string, not a trip list.");
      }
    }

    return HotelListModel(rawStatus: status, trips: hotelList);
  }


}

class HotelItem {
  final int HotelID;
  final String HotelName;
  final String Place;
  final String ChainName;
  final bool isselect;


  HotelItem({required this.HotelID, required this.HotelName, required this.Place, required this.ChainName, required this.isselect,});

  factory HotelItem.fromJson(Map<String, dynamic> json) {
    return HotelItem(
      HotelID: json['HotelID'] ?? 0,
      HotelName: json['HotelName'] ?? '',
      Place: json['Place'] ?? '',
      ChainName: json['ChainName'] ?? '',
      isselect: json['isselect'] ?? true,

    );
  }
}

