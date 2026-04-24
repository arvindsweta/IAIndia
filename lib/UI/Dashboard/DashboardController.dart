import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:myfirstdemo/Model/CityModel.dart';
import 'package:myfirstdemo/Model/LoginResponce.dart';
import 'package:myfirstdemo/Model/TravelerModel.dart';

import 'package:myfirstdemo/Model/TripWrapper.dart';
import 'package:myfirstdemo/Widgets/Toast/CustomSnackbar.dart';
import '../../Constants/ApiEndpoints.dart';

import '../../Model/HotelCabFlightModel.dart';
import '../../Model/HotelListByCityModel.dart';
import '../../Model/MyTripListModel.dart';
import '../../Services/ApiServices/ApiServices.dart';

import '../../Utilities/Debug/PrintMe.dart';


class DashboardController extends GetxController {


  Future<TripWrapper?> postTripData() async {
    try {
      // Note: Ensure ApiServices().postRequest returns a Map<String, dynamic>
      var response = await ApiServices().postRequest(
        apiUrl: ApiEndpoints.GetTripAPI,
        requestJson: "",
      );

      if (response != null && response is Map<String, dynamic>) {
        print("Raw API Response: $response");
        return TripWrapper.fromJson(response);
      }
      return null;
    } catch (e, r) {
      print("Error parsing Trip Data: $e");
      print("Stacktrace: $r");
      CustomSnackBar().showSnackbar("Error", "Failed to parse trip information");
      return null;
    }
  }

  Future<MyTripListModel?> getMyTripData(String userid) async {

    final Map<String, dynamic> requestuserMap = {
      "UserID": userid.toString(),


    };

    try {
      // Note: Ensure ApiServices().postRequest returns a Map<String, dynamic>
      var response = await ApiServices().postRequest(
        apiUrl: ApiEndpoints.GetMyTripAPI,
        requestJson: jsonEncode(requestuserMap),
      );

      if (response != null && response is Map<String, dynamic>) {

        showLog("Raw API Response: $response");
        return MyTripListModel.fromJson(response);
      }
      return null;
    } catch (e, r) {
      print("Error parsing Trip Data: $e");
      print("Stacktrace: $r");
      CustomSnackBar().showSnackbar("Error", "Failed to parse trip information");
      return null;
    }
  }
  Future<MyTripListModel?> getMyTripDetailData(String userid,String tripId) async {

    final Map<String, dynamic> requestuserMap = {
      "UserID": userid.toString(),
      "TripID": tripId.toString(),
      "bit": "T"


    };

    try {
      // Note: Ensure ApiServices().postRequest returns a Map<String, dynamic>
      var response = await ApiServices().postRequest(
        apiUrl: ApiEndpoints.GetMyTripDetailsAPI,
        requestJson: jsonEncode(requestuserMap),
      );

      if (response != null && response is Map<String, dynamic>) {

        showLog("Raw API Response: $response");
        return MyTripListModel.fromJson(response);
      }
      return null;
    } catch (e, r) {
      print("Error parsing Trip Data: $e");
      print("Stacktrace: $r");
      CustomSnackBar().showSnackbar("Error", "Failed to parse trip information");
      return null;
    }
  }
  Future<TripResponse?> getHotelCabFlightData(String userid,String tripId,String bitType) async {

    final Map<String, dynamic> requestuserMap = {
      "UserID": userid.toString(),
      "TripID": tripId.toString(),
      "bit": bitType


    };

    try {
      // Note: Ensure ApiServices().postRequest returns a Map<String, dynamic>
      var response = await ApiServices().postRequest(
        apiUrl: ApiEndpoints.GetMyTripDetailsAPI,
        requestJson: jsonEncode(requestuserMap),
      );

      if (response != null && response is Map<String, dynamic>) {

        showLog("Raw API Response: $response");
        return TripResponse.fromJson(response);
      }
      return null;
    } catch (e, r) {
      print("Error parsing Trip Data: $e");
      print("Stacktrace: $r");
      CustomSnackBar().showSnackbar("Error", "Failed to parse trip information");
      return null;
    }
  }





  Future<CityModel?> GetCityListApi() async {
    final Map<String, dynamic> requestuserMap = {
      "ID": "0",
      "StateID": "0",
      "CountryID": "1",

    };


    return ApiServices().postRequest(
      apiUrl: ApiEndpoints.GetCityAPI,
      requestJson: jsonEncode(requestuserMap),
    ).then((response) {
      try {
        if (response != null && response is Map<String, dynamic>) {
          // Log the response to see exactly what is inside
          print("Decoded Map: $response");

          // IMPORTANT: 'response' is already a Map,
          // DO NOT use jsonDecode(response) or response.statusCode
          return CityModel?.fromJson(response);
        }
        return null;
      } catch (e, r) {
        print("Error parsing response: $e");
        print(r);
        CustomSnackBar().showSnackbar("Error", "Something went wrong during parsing");
        return null;
      }
    });
  }




  Future<HotelListByCityModel?> GetHotelByCityListApi(String name,String cityId) async {
    final Map<String, dynamic> requestuserMap = {

      "CityID": cityId.toString(),


    };


    return ApiServices().postRequest(
      apiUrl: ApiEndpoints.getHotelByCityAPI,
      requestJson: jsonEncode(requestuserMap),
    ).then((response) {
      try {
        if (response != null && response is Map<String, dynamic>) {
          // Log the response to see exactly what is inside
          print("Decoded Map: $response");


          return HotelListByCityModel?.fromJson(response);
        }
        return null;
      } catch (e, r) {
        print("Error parsing response: $e");
        print(r);
        CustomSnackBar().showSnackbar("Error", "Something went wrong during parsing");
        return null;
      }
    });
  }




  Future<LoginResponce? > PostAddTripRequestApi({
    required String arrCity,
    required String desCity,
    required String startDate,
    required String endDate,
    required String noOfDays,
    required String remarks,
    required String TripType,
    required String arrCountry,
    required String desCountry


}) async {
    final Map<String, dynamic> requestuserMap = {
      "arrCountry": arrCountry,
      "desCountry":desCountry,
      "arrCity": arrCity,
      "desCity": desCity,
      "startDate": startDate,
      "endDate": endDate,
      "noOfTraveler": "1",
      "noOfDays": noOfDays,
      "remarks": remarks,
      "TripType":TripType,


    };


    return ApiServices().postRequest(
      apiUrl: ApiEndpoints.PostAddTripRequestAPI,
      requestJson: jsonEncode(requestuserMap),
    ).then((response) {
      try {
        if (response != null && response is Map<String, dynamic>) {
          // Log the response to see exactly what is inside
          print("Decoded Map: $response");

          // IMPORTANT: 'response' is already a Map,
          // DO NOT use jsonDecode(response) or response.statusCode
          return LoginResponce?.fromJson(response);
        }
        return null;
      } catch (e, r) {
        print("Error parsing response: $e");
        print(r);
        CustomSnackBar().showSnackbar("Error", "Something went wrong during parsing");
        return null;
      }
    });
  }

  Future<LoginResponce? > SaveTravellerRequestApi({
    required TravelerModel? userModel,
    required String TripID,
    required String MemberID,
    required String startDate,
    required String endDate,

    required String remarks

  }) async {
    final Map<String, dynamic> requestuserMap = {
      "Name": userModel?.firstName.toString(),
      "FamilyName":userModel?.familyName.toString(),
      "Division": userModel?.division.toString(),
      "Designation": userModel?.designation.toString(),
      "Email": userModel?.emailID.toString(),
      "Phone": userModel?.phone.toString(),
      "StartDate": startDate,
      "EndDate": endDate,
      "Remark": remarks,
      "TripID": TripID,
      "MemberID": MemberID,
      "VIPPerson": userModel?.firstName.toString(),
      "HeadPerson": "",


    };

    final Map<String, dynamic> crateid = {
      "CreatedBy":MemberID,
      "member":requestuserMap
    };
    return ApiServices().postRequest(
      apiUrl: ApiEndpoints.PostSaveTravellerRequestAPI,
      requestJson: jsonEncode(crateid),
    ).then((response) {
      try {
        if (response != null && response is Map<String, dynamic>) {
          // Log the response to see exactly what is inside
          print("Decoded Map: $response");

          // IMPORTANT: 'response' is already a Map,
          // DO NOT use jsonDecode(response) or response.statusCode
          return LoginResponce?.fromJson(response);
        }
        return null;
      } catch (e, r) {
        print("Error parsing response: $e");
        print(r);
        CustomSnackBar().showSnackbar("Error", "Something went wrong during parsing");
        return null;
      }
    });
  }


  Future<LoginResponce?> SaveTripDetails({
    required TravelerModel? userModel,
    required String TripID,
    required bool Before6AM,
    required bool SixToTwelve,
    required bool TwelveToSix,
    required bool After6PM,
    required bool SpecificTime,
    required String FromTime,
    required String ToTime,
    required String FromDate,
    required String ToDate,
    required bool Airport,
    required bool Hotel,
    required bool Cab,
    required bool OtherTravel,
    required String OtherText,
    required String DepartureCityID,
    required String ArrivalCityID,
    required String DepartureName,
    required String ArrivalName,
    required String NoOfDays,
    required String TripType,
    required String remarks,
    required String hotelId,



  }) async {

    // 1. Map the specific Trip Detail (The inner object)
    // Note: I've aligned these keys with your first JSON requirement
    final Map<String, dynamic> tripDetail = {
      "TripRequestID": int.tryParse(TripID) ?? 0,
      "Before6AM": Before6AM, // Set based on your UI logic
      "SixToTwelve": SixToTwelve,
      "TwelveToSix": TwelveToSix,
      "After6PM": After6PM,
      "SpecificTime": SpecificTime,
      "FromTime": FromTime,
      "ToTime": ToTime,
      "FromDate": FromDate,
      "ToDate": ToDate,
      "Airport": Airport,
      "Hotel": Hotel,
      "Cab": Cab,
      "OtherTravel": OtherTravel,
      "OtherText": OtherText,
      "DepartureCityID": DepartureCityID,
      "ArrivalCityID": ArrivalCityID,
      "DepartureName": DepartureName,
      "ArrivalName": ArrivalName,
      "NoOfDays": NoOfDays,
      "TripType": TripType,
      "Remarks": remarks,
      "HotelID": hotelId
    };

    // 2. Wrap it in the "SaveTripDetails" root structure
    final Map<String, dynamic> finalRequestPayload = {

        "tripRequestID": int.tryParse(TripID) ?? 0,
        "details": [tripDetail]

    };

    return ApiServices().postRequest(
      apiUrl: ApiEndpoints.PostSaveTripDetails,
      requestJson: jsonEncode(finalRequestPayload),
    ).then((response) {
      try {
        if (response != null && response is Map<String, dynamic>) {
          return LoginResponce.fromJson(response);
        }
        return null;
      } catch (e, r) {
        print("Error parsing response: $e");
        CustomSnackBar().showSnackbar("Error", "Parsing Error");
        return null;
      }
    });
  }
  Future<LoginResponce? > PostTripAproveRejectRequestApi({
    required String tripId,
    required String status,
    required String userId,
    required String remark,


  }) async {
    final Map<String, dynamic> requestuserMap = {
      "TripID": tripId,
      "Status":status,
      "CreatedBy": userId,
      "Remarks":remark,



    };


    return ApiServices().postRequest(
      apiUrl: ApiEndpoints.PostRejectApprovedAPI,
      requestJson: jsonEncode(requestuserMap),
    ).then((response) {
      try {
        if (response != null && response is Map<String, dynamic>) {
          // Log the response to see exactly what is inside
          print("Decoded Map: $response");

          // IMPORTANT: 'response' is already a Map,
          // DO NOT use jsonDecode(response) or response.statusCode
          return LoginResponce?.fromJson(response);
        }
        return null;
      } catch (e, r) {
        print("Error parsing response: $e");
        print(r);
        CustomSnackBar().showSnackbar("Error", "Something went wrong during parsing");
        return null;
      }
    });
  }


  Future<LoginResponce?> deleteMyTripApi(String tripId) async {

    final Map<String, dynamic> requestuserMap = {
      "tripId": tripId.toString(),



    };
    return ApiServices().postRequest(
      apiUrl: ApiEndpoints.DeleteTripRequest,
      requestJson:jsonEncode(requestuserMap),
    ).then((response) {
      try {
        if (response != null && response is Map<String, dynamic>) {
          // Log the response to see exactly what is inside
          print("Decoded Map: $response");

          // IMPORTANT: 'response' is already a Map,
          // DO NOT use jsonDecode(response) or response.statusCode
          return LoginResponce?.fromJson(response);
        }
        return null;
      } catch (e, r) {
        print("Error parsing response: $e");
        print(r);
        CustomSnackBar().showSnackbar("Error", "Something went wrong during parsing");
        return null;
      }
    });
  }



}

