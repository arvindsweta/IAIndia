import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';

import 'package:myfirstdemo/Model/LoginResponce.dart';
import 'package:myfirstdemo/Model/TravelerModel.dart';
import 'package:myfirstdemo/Model/VerifyOtpResponse.dart';
import 'package:myfirstdemo/Widgets/Toast/CustomSnackbar.dart';
import '../../Constants/ApiEndpoints.dart';
import '../../Constants/AppLabels.dart';

import '../../Services/ApiServices/ApiServices.dart';

import '../../Utilities/Debug/PrintMe.dart';


class LoginController extends GetxController {

  Future<LoginResponce?> postUserLoginApi({required String userEmail}) async {
    final Map<String, dynamic> requestuserMap = {
      "EmailID": userEmail,
      'PhoneNo': "",
    };

    final Map<String, dynamic> requestMap = {
      "data": requestuserMap,
    };

    try {
      // 1. Wait for the API response
      final response = await ApiServices().postRequest(
        apiUrl: ApiEndpoints.LoginUrl,
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



  Future<LoginResponce?> postUserEmpTokenSaveApi({required String userId,required String token}) async {

    final Map<String, dynamic> requestuserMap = {
      "ID": userId,
      'token': token,
    };


    return ApiServices().postRequest(
      apiUrl: ApiEndpoints.postEmpTokenAPI,
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

  Future<VerifyOtpResponse?> userVerifyotp({required String userEmail,required String otp}) async {
    final Map<String, dynamic> requestuserMap = {
      "UserName": userEmail,
      'OTP': otp,
    };


    return ApiServices().postRequest(
      apiUrl: ApiEndpoints.VerifyOTP,
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

  Future<TravelerModel?> GetUserProfile({required String userId}) async {
    final Map<String, dynamic> requestuserMap = {
      "ID": userId,

    };


    return ApiServices().postRequest(
      apiUrl: ApiEndpoints.GetUserDetailAPI,
      requestJson: jsonEncode(requestuserMap),
    ).then((response) {
      try {
        if (response != null && response is Map<String, dynamic>) {
          // Log the response to see exactly what is inside
          print("Decoded Map: $response");

          // IMPORTANT: 'response' is already a Map,
          // DO NOT use jsonDecode(response) or response.statusCode
          return TravelerModel?.fromJson(response);
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

