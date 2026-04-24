import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:myfirstdemo/Constants/ApiEndpoints.dart';
import 'package:myfirstdemo/Model/CityModel.dart';
import 'package:myfirstdemo/Model/HotelListModel.dart';
import 'package:myfirstdemo/Model/HotelPlaceModel.dart';
import 'package:myfirstdemo/Model/LoginResponce.dart';
import 'package:myfirstdemo/Model/TravelerModel.dart';

import 'package:myfirstdemo/Model/TripWrapper.dart';
import 'package:myfirstdemo/Model/VerifyOtpResponse.dart';
import 'package:myfirstdemo/Services/ApiServices/ApiServices.dart';
import 'package:myfirstdemo/Widgets/Toast/CustomSnackbar.dart';



class SecurityDashbordController extends GetxController {


  Future<HotelListModel?> postHotelListData() async {
    try {
      // Note: Ensure ApiServices().postRequest returns a Map<String, dynamic>
      var response = await ApiServices().postRequest(
        apiUrl: ApiEndpoints.GetHotelApi,
        requestJson: "",
      );

      if (response != null && response is Map<String, dynamic>) {
        print("Raw API Response: $response");
        return HotelListModel.fromJson(response);
      }
      return null;
    } catch (e, r) {
      print("Error parsing Trip Data: $e");
      print("Stacktrace: $r");
      CustomSnackBar().showSnackbar("Error", "Failed to parse trip information");
      return null;
    }
  }

  Future<HotelPlaceModel?> getMapHotelListData() async {
    try {
      // Note: Ensure ApiServices().postRequest returns a Map<String, dynamic>
      var response = await ApiServices().postRequest(
        apiUrl: ApiEndpoints.GetMapHotelApi,
        requestJson: "",
      );

      if (response != null && response is Map<String, dynamic>) {
        print("Raw API Response: $response");
        return HotelPlaceModel.fromJson(response);
      }
      return null;
    } catch (e, r) {
      print("Error parsing Trip Data: $e");
      print("Stacktrace: $r");
      CustomSnackBar().showSnackbar("Error", "Failed to parse trip information");
      return null;
    }
  }

  Future<LoginResponce?> postSecurityLoginApi({required String userEmail,required String Password}) async {
    final Map<String, dynamic> requestuserMap = {
      "UserName": userEmail,
      'Password': Password,
    };

    final Map<String, dynamic> requestMap = {
      "data": requestuserMap,
    };

    try {
      // 1. Wait for the API response
      final response = await ApiServices().postRequest(
        apiUrl: ApiEndpoints.SecurityLoginUrl,
        requestJson: jsonEncode(requestMap),
      );

      // 2. Validate the response
      if (response != null && response is Map<String, dynamic>) {
        print("Decoded Map: $response");

        // 3. Return the parsed model
        return LoginResponce.fromJson(response);
      } else {
        print("Response was null or not a Map");
        return null;
      }
    } catch (e, r) {
      // 4. Handle errors
      print("Error during API call or parsing: $e");
      print(r);
      // Ensure CustomSnackBar works on the main thread or check context
      CustomSnackBar().showSnackbar("Error", "Something went wrong");
      return null;
    }
  }

  Future<VerifyOtpResponse?> userSecureLoginVerifyotp({required String userEmail,required String Password,required String otp}) async {
    final Map<String, dynamic> requestuserMap = {
      "UserName": userEmail,
      'Password': Password,
      "OTP":otp,
    };


    return ApiServices().postRequest(
      apiUrl: ApiEndpoints.SecurityVerifyOTP,
      requestJson: jsonEncode(requestuserMap),
    ).then((response) {
      try {
        if (response != null && response is Map<String, dynamic>) {
          // Log the response to see exactly what is inside
          print("Decoded Map: $response");

          // IMPORTANT: 'response' is already a Map,
          // DO NOT use jsonDecode(response) or response.statusCode
          return VerifyOtpResponse?.fromJson(response);
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

  Future<VerifyOtpResponse?> hotelActiveInActiveApi({required String hotelId,required String Status,required String useId}) async {
    final Map<String, dynamic> requestuserMap = {
      "HotelID": hotelId,
      'Status': Status,
      "CreatedBy":useId,
    };


    return ApiServices().postRequest(
      apiUrl: ApiEndpoints.SecurityVerifyOTP,
      requestJson: jsonEncode(requestuserMap),
    ).then((response) {
      try {
        if (response != null && response is Map<String, dynamic>) {
          // Log the response to see exactly what is inside
          print("Decoded Map: $response");

          // IMPORTANT: 'response' is already a Map,
          // DO NOT use jsonDecode(response) or response.statusCode
          return VerifyOtpResponse?.fromJson(response);
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

