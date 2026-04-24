
import 'dart:convert';

import 'package:get/get.dart';
import 'package:myfirstdemo/Utilities/Debug/PrintMe.dart';

import '../../../Constants/ApiEndpoints.dart';
import '../../../Model/AprovedExpenceModel.dart';
import '../../../Model/ExpenceChatModel.dart';
import '../../../Model/ExpenceListModel.dart';
import '../../../Model/LoginResponce.dart';
import '../../../Model/TripExpenseResponse.dart';
import '../../../Services/ApiServices/ApiServices.dart';
import '../../../Widgets/Toast/CustomSnackbar.dart';



class ExpenceController extends GetxController {
  Future<TripExpenseResponse?> GetMyExpenceListApi(String userid) async {

    final Map<String, dynamic> requestuserMap = {
      "UserId": userid.toString(),



    };
    return ApiServices().postRequest(
      apiUrl: ApiEndpoints.GetMyExpenceListAPI,
      requestJson:jsonEncode(requestuserMap),
    ).then((response) {
      try {
        if (response != null && response is Map<String, dynamic>) {
          // Log the response to see exactly what is inside
          print("Decoded Map: $response");
          showLog("Raw API Response: $response");

          // IMPORTANT: 'response' is already a Map,
          // DO NOT use jsonDecode(response) or response.statusCode
          return TripExpenseResponse?.fromJson(response);
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
  Future<LoginResponce?> deleteMyExpenceApi(String userid,String expenceId) async {

    final Map<String, dynamic> requestuserMap = {
      "id": expenceId.toString(),
      "userId": userid.toString(),



    };
    return ApiServices().postRequest(
      apiUrl: ApiEndpoints.deleteExpenceAPI,
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
  Future<TripExpenseResponse?> GetAproveExpenceListApi(String userid) async {

    final Map<String, dynamic> requestuserMap = {
      "ReportTo": userid.toString(),
      "bitType": 1,



    };
    return ApiServices().postRequest(
      apiUrl: ApiEndpoints.GetExpenceAprovedListAPI,
      requestJson:jsonEncode(requestuserMap),
    ).then((response) {
      try {
        if (response != null && response is Map<String, dynamic>) {
          // Log the response to see exactly what is inside
          print("Decoded Map: $response");

          // IMPORTANT: 'response' is already a Map,
          // DO NOT use jsonDecode(response) or response.statusCode
          return TripExpenseResponse?.fromJson(response);
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
  Future<LoginResponce? > PostAddExpenceApi({
    required String tripId,
    required String cotegoriId,
    required String category,
    required String remark,
    required String ExpenceID,
    required String amount,
    required String userId,
    required String expenceDate,
    required String Droptime,
    required String Picktime,
    required String expenceToDate,



  }) async {
    final Map<String, dynamic> requestuserMap = {
      "TripID": tripId,
      "ID":0,
      "Remarks":remark,
      "ExpenceID":cotegoriId,
      "CreatedBy":userId.toString(),
      "ExpenceName":"category",
      "RembursmentRemarks":"",
      "ApprovedBit":"",
      "ApprovedBy":"",
      "ModifyBy":"",
      "Status":"Active",
      "RembursmentBy":"",
      "Droptime":Droptime,
      "Picktime":Picktime,
      "ExpenceAmount":amount,
      "ExpenceDate":expenceDate,
      "ExpenceDateTo":expenceToDate,



    };
    final Map<dynamic, dynamic> dataMap ={"data":requestuserMap};

    return ApiServices().postRequest(
      apiUrl: ApiEndpoints.postInsertTripExpenseAPI,
      requestJson: jsonEncode(dataMap),
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

  Future<LoginResponce? > PostCalculateApi({
    required String tripId,

    required String Todate,
    required String fromDate,
    required String Droptime,
    required String Picktime,



  }) async {
    final Map<String, dynamic> requestuserMap = {
      "TripID": tripId,
      "DipartureTime":Picktime,
      "DropTime":Droptime,
      "FromDate":fromDate,
      "ToDate":Todate,



    };


    return ApiServices().postRequest(
      apiUrl: ApiEndpoints.CalculateAmount,
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



  Future<ExpenceListModel?> GetExpenceListApi() async {


    return ApiServices().postRequest(
      apiUrl: ApiEndpoints.GetExpenceMasterListAPI,
      requestJson: "",
    ).then((response) {
      try {
        if (response != null && response is Map<String, dynamic>) {
          // Log the response to see exactly what is inside
          print("Decoded Map: $response");

          // IMPORTANT: 'response' is already a Map,
          // DO NOT use jsonDecode(response) or response.statusCode
          return ExpenceListModel?.fromJson(response);
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

  Future<ExpenceChatModel?> GetExpenceChatListApi( { required String tripId,}) async {
    final Map<String, dynamic> requestuserMap = {
    "TripExpenceID": tripId,

  };

  return ApiServices().postRequest(
      apiUrl: ApiEndpoints.GettExprnceChatAPI,
      requestJson: jsonEncode(requestuserMap),
    ).then((response) {
      try {
        if (response != null && response is Map<String, dynamic>) {
          // Log the response to see exactly what is inside
          print("Decoded Map: $response");


          return ExpenceChatModel?.fromJson(response);
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



  Future<LoginResponce?> postExpenceChatListApi( {
    required String tripId,
    required String userId,
    required String textChat,




  }) async {

    final Map<String, dynamic> requestuserMap = {
      "EmployeeID": userId,
      "ChatData": textChat.toString(),
      "TripExpenceID": tripId,
      "ReplyType": "Traveler",

    };

    return ApiServices().postRequest(
      apiUrl: ApiEndpoints.PostExprnceChatAPI,
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



  Future<LoginResponce?> postUploadImageByExpenceIdApi({ required String base64Image,

    required String fileName,
    required String expenceID,
    required String OrderNo,

  }) async {

    final Map<String, dynamic> requestuserMap = {
      "base64Image": base64Image,
      "OrderNo":OrderNo,
      "fileName":fileName,
      "ID":expenceID,



    };
    showLog(jsonEncode(requestuserMap));

    return ApiServices().postRequest(
      apiUrl: ApiEndpoints.uploadExpenceImageAPI,
      requestJson: jsonEncode(requestuserMap),
    ).then((response) {
      try {
        if (response != null && response is Map<String, dynamic>) {
          // Log the response to see exactly what is inside
          print("Decoded Map: $response");


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


  Future<LoginResponce? > PostAproveRejectExpenceApi({

    required String remark,
    required String ExpenceID,
    required String userId,
    required String status,


  }) async {
    final Map<String, dynamic> dataMap = {

      "ID":ExpenceID,
      "ApprovedBy":userId.toString(),
      "ApprovedStatus":status,
      "ApprovedRemarks":remark,
    };

    final Map<String, dynamic> requestuserMap = {
      "data":dataMap,

    };
    return ApiServices().postRequest(
      apiUrl: ApiEndpoints.aproveRejectExpenceAPI,
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

}
