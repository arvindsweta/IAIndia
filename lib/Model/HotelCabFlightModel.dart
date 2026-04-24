import 'dart:convert';

class TripResponse {
  final List<TripDetail> data;

  TripResponse({required this.data});

  factory TripResponse.fromJson(Map<String, dynamic> json) {
    var dValue = json['d'];
    List<dynamic> list = [];

    // Handles both raw List and JSON-stringified List
    if (dValue is String) {
      list = jsonDecode(dValue) as List;
    } else if (dValue is List) {
      list = dValue;
    }

    return TripResponse(
      data: list.map((i) => TripDetail.fromJson(i)).toList(),
    );
  }
}

class TripDetail {
  final String dataType;
  final String tripId;
  final String memberName;
  final String bookingId;
  final String detailName;
  final String remarks;
  final String fromDateTime;
  final String toDateTime;
  final String status;
  final String ticketImage;

  // Cab Specific Fields
  final String cabFromDate;
  final String cabToDate;
  final String cabBookingStatus;
  final String pickLocation;
  final String dropLocation;
  final String pickupTime;
  final String dropTime;
  final String cabType;

  // Flight/Hotel Specific Fields (kept for compatibility)
  final String flightNo;
  final String airlineName;
  final String flightStatus;
  final String departureDate;
  final String hotelCityName;
  final String confirmationNo;

  TripDetail({
    required this.dataType,
    required this.tripId,
    required this.memberName,
    required this.bookingId,
    required this.detailName,
    required this.remarks,
    required this.fromDateTime,
    required this.toDateTime,
    required this.status,
    required this.ticketImage,
    required this.cabFromDate,
    required this.cabToDate,
    required this.cabBookingStatus,
    required this.pickLocation,
    required this.dropLocation,
    required this.pickupTime,
    required this.dropTime,
    required this.cabType,
    required this.flightNo,
    required this.airlineName,
    required this.flightStatus,
    required this.departureDate,
    required this.hotelCityName,
    required this.confirmationNo,
  });

  factory TripDetail.fromJson(Map<String, dynamic> json) {
    return TripDetail(
      dataType: json['DataType']?.toString() ?? '',
      tripId: json['TripID']?.toString() ?? '',
      memberName: json['MemberName']?.toString() ?? '',
      bookingId: json['BookingID']?.toString() ?? '',
      detailName: json['DetailName']?.toString() ?? '',
      remarks: json['Remarks']?.toString() ?? '',
      fromDateTime: json['FromDateTime']?.toString() ?? '',
      toDateTime: json['ToDateTime']?.toString() ?? '',
      status: json['Status']?.toString() ?? '',
      ticketImage: json['TicketImage']?.toString() ?? '',

      // Cab Mapping
      cabFromDate: json['CabFromDate']?.toString() ?? '',
      cabToDate: json['CabToDate']?.toString() ?? '',
      cabBookingStatus: json['CabBookingStatus']?.toString() ?? '',
      pickLocation: json['PickLocation']?.toString() ?? '',
      dropLocation: json['DropLocation']?.toString() ?? '',
      pickupTime: json['PickupTime']?.toString() ?? '',
      dropTime: json['DropTime']?.toString() ?? '',
      cabType: json['CabType']?.toString() ?? '',

      // Flight/Hotel Mapping
      flightNo: json['FlightNO']?.toString() ?? '',
      airlineName: json['AirlineName']?.toString() ?? '',
      flightStatus: json['FlightStatus']?.toString() ?? '',
      departureDate: json['DepartureDate']?.toString() ?? '',
      hotelCityName: json['HotelCityName']?.toString() ?? '',
      confirmationNo: json['ConfirmationNo']?.toString() ?? '',
    );
  }
}