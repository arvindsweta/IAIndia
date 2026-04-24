import 'dart:convert';

class MyTripListModel {
  // We keep the raw 'd' if you need it for the "Valid" check,
  // but we primarily use the 'trips' list.
  final String? rawStatus;
  final List<TripListData> trips;

  MyTripListModel({this.rawStatus, required this.trips});

  factory MyTripListModel.fromJson(Map<String, dynamic> json) {
    var dValue = json['d'];
    List<TripListData> tripList = [];
    String? status;

    if (dValue is String) {
      status = dValue; // Holds "Valid" or the JSON string
      try {
        // Try to decode d as a list of trips
        var decoded = jsonDecode(dValue);
        if (decoded is List) {
          tripList = decoded.map((item) => TripListData.fromJson(item)).toList();
        }
      } catch (e) {
        // If it's just a string like "Valid", jsonDecode might fail or not be a list
        print("Note: 'd' is a simple string, not a trip list.");
      }
    }

    return MyTripListModel(rawStatus: status, trips: tripList);
  }
}

class TripListData {
  final int id;
  final String bookingID;
  final String dateRange;
  final String tripStatus;
  final List<TripListMember> members;

  TripListData({required this.id, required this.bookingID, required this.dateRange, required this.tripStatus, required this.members});

  factory TripListData.fromJson(Map<String, dynamic> json) {
    return TripListData(
      id: json['ID'] ?? 0,
      bookingID: json['bookingID'] ?? '',
      dateRange: json['dateRange'] ?? '',
      tripStatus: json['TripStatus'] ?? '',
      members: (json['members'] as List?)?.map((m) => TripListMember.fromJson(m)).toList() ?? [],
    );
  }
}

class TripListMember {
  final String name;
  final String FamilyName;
  final String email;
  final String reportTo;
  final String MemberID;
  final String FromCity;
  final String ToCity;
  final String HotelBookingID;
  final String HotelFromDate;
  final String HotelToDate;
  final String HotelBookingStatus;
  final String CabBookingID;
  final String CabFromDate;
  final String CabBookingStatus;
  final String DepartureDate;
  final String FlightStatus;
  final String FlightBookingID;
  final String TravelerType;
  final String hotel;
  final String cab;
  final String flight;
  final String HotelID;
  final String HotelCityName;
  final String HotelCityID;
  final String FlightNO;
  final String AirlineName;
  final String FlightClass;
  final String SeatNo;
  final String FlightTime;
  final String ChainName;
  final String ConfirmationNo;
  final String Remarks;
  final String PickLocation;
  final String DropLocation;
  final String CabType;
  final String PickupTime;
  final String DropTime;
  final String TicketImage;





  TripListMember({required this.HotelBookingID,required this.HotelFromDate,
  required this.HotelToDate, required this.HotelBookingStatus,
  required this.CabBookingID, required this.CabFromDate,
  required this.CabBookingStatus,
  required this.DepartureDate,
  required this.FlightStatus,
  required this.FlightBookingID,
  required this.TravelerType,
  required this.hotel,
  required this.cab,
  required this.flight,
  required this.HotelID,
  required this.HotelCityName,
  required this.HotelCityID,
  required this.FlightNO,
  required this.AirlineName,
  required this.FlightClass,
  required this.SeatNo,
  required this.FlightTime,
  required this.name,
  required this.FamilyName,
  required this.email,
  required this.reportTo,
  required this.MemberID,
  required this.FromCity,
  required this.ToCity,
  required this.ChainName,
  required this.ConfirmationNo,
  required this.Remarks,
  required this.PickLocation,
  required this.DropLocation,
  required this.CabType,
  required this.PickupTime,
  required this.DropTime,
  required this.TicketImage,

  }

  );

  factory TripListMember.fromJson(Map<String, dynamic> json) {
    return TripListMember(
      name: json['name'] ?? '',
      FamilyName: json['FamilyName'] ?? '',
      email: json['Email'] ?? '',
      reportTo: json['ReportTo'] ?? '',
      MemberID: json['MemberID'] ?? '',
      FromCity: json['FromCity'] ?? '',
      ToCity: json['ToCity'] ?? '',
      HotelBookingID: json['HotelBookingID'] ?? '',
      HotelFromDate: json['HotelFromDate'] ?? '',
      HotelToDate: json['HotelToDate'] ?? '',
      HotelBookingStatus: json['HotelBookingStatus'] ?? '',
      CabBookingID: json['CabBookingID'] ?? '',
      CabFromDate: json['CabFromDate'] ?? '',
      CabBookingStatus: json['CabBookingStatus'] ?? '',
      DepartureDate: json['DepartureDate'] ?? '',
      FlightStatus: json['FlightStatus'] ?? '',
      FlightBookingID: json['FlightBookingID'] ?? '',
      TravelerType: json['TravelerType'] ?? '',
      hotel: json['hotel'] ?? '',
      cab: json['cab'] ?? '',
      flight: json['flight'] ?? '',
      HotelID: json['HotelID'] ?? '',
      HotelCityName: json['HotelCityName'] ?? '',
      HotelCityID: json['HotelCityID'] ?? '',
      FlightNO: json['FlightNO'] ?? '',
      AirlineName: json['AirlineName'] ?? '',
      FlightClass: json['FlightClass'] ?? '',
      SeatNo: json['SeatNo'] ?? '',
      FlightTime: json['FlightTime'] ?? '',
      ChainName: json['ChainName'] ?? '',
      ConfirmationNo: json['ConfirmationNo'] ?? '',
      Remarks: json['Remarks'] ?? '',
      PickLocation: json['PickLocation'] ?? '',
      DropLocation: json['DropLocation'] ?? '',
      CabType: json['CabType'] ?? '',
      PickupTime: json['PickupTime'] ?? '',
      DropTime: json['DropTime'] ?? '',
      TicketImage: json['TicketImage'] ?? '',
    );
  }
}
