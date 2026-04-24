import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';


import '../../Utilities/Debug/PrintMe.dart';
import 'ApiCalls.dart';
import 'package:http/http.dart' as http;
class ApiServices {
  static  String accessToken = '';
  static bool isNavigatingToLogin = false;
  static bool isNavigatingProfile = false;


  static void updateAccessToken(String newToken) {
    accessToken = newToken;
    printMe("Access Token Updated: ${newToken.substring(0, 20)}...");
  }

  Future<Map<String, String>> getHeaderMap() async {


    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json;charset=utf-8',

    };
  }

  ///-------------- get Request ----------------
  Future<dynamic> getRequest(String endPoint, var data,
      {bool returnWithStatusCode = false}) async {
    try {
      var header = await getHeaderMap();
      final response = await ApiCall.getMethod(
          headers: header, endpoint: endPoint, data: data);
      printMe("API RESULTS ================================>>");
      printMe("API URL : ${response.request}");
      printMe("STATUS CODE : ${response.statusCode}");
      printWarning("++++++++++++++++++++");
      log(response.body);
      printWarning("++++++++++++++++++++");

      if (returnWithStatusCode) {
        print(returnWithStatusCode);
        return response;
      }
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      else if (response.statusCode == 401) {




          return "401";

      }


      else {
        return null;
      }
    } catch (e, stacktrace) {
      printWarning("Exception : ");
      printError(e.toString());
      printWarning("Stacktrace : ");
      printError(stacktrace.toString());
      return null;
    }
  }


  ///---------------------delete--------------------

//response is true if status code is 204 is returned here instead of body
  Future<bool> deleteRequest(
      String endPoint,
      var data,
      ) async {
    try {
      var header = await getHeaderMap();
      // printMe('header');
      // printMe(header);
      final response = await ApiCall.deleteMethod(
          headers: header, endpoint: endPoint, data: data);
      printMe("API DELETE REQUEST for $endPoint  ");
      printMe("API URL : ${response.request}");
      printMe("STATUS CODE : ${response.statusCode}");
      printMe("API RESPONSE :");
      log(response.body);
      if (response.statusCode == 204 || response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e, stacktrace) {
      printWarning("Exception : ");
      printError(e.toString());
      printWarning("Stacktrace : ");
      printError(stacktrace.toString());
      return false;
    }
  }

  ///-------------------post Request---------------------------------------------------------------

  Future<dynamic> postRequest(
      {required String apiUrl,
        required String requestJson,
        bool returnWithStatusCode = false}) async {
    try {
      var headers = await getHeaderMap();
      final response = await ApiCall.postMethod(
          url: apiUrl, headers: headers, body: requestJson);
      printMe(" API Request for $apiUrl Api:  ### ");
      printMe("RequestJson : $requestJson");
      printMe(response.request.toString());
      printMe(response.statusCode.toString());
      printMe("[√]Response :");
      printResponse(response.body);
      printMe("[√]headers :");
      // print(headers);

      if (returnWithStatusCode) {
        print(returnWithStatusCode);
        return response;
      }

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e, stacktrace) {
      printWarning("Exception : $e");
      printError(e.toString());
      printWarning("Stacktrace : ");
      printError(stacktrace.toString());
      return null;
    }
  }



  // post Request for Edit Profile
  Future<dynamic> postSubscribeRequest({
    required String apiUrl,
    required String requestJson,
  }) async {
    try {
      var headers = await getHeaderMap();

      final response = await ApiCall.postMethod(
        url: apiUrl,
        headers: headers,
        body: requestJson,
      );
      printMe(" API Request for $apiUrl Api:  ### ");
      printMe("RequestJson : $requestJson");
      printMe(response.request.toString());
      printMe("code" + response.statusCode.toString());
      printMe("[√]Response :");
      printResponse(response.body);
      return response;
    } catch (e, stacktrace) {
      printWarning("Exception : $e");
      printError(e.toString());
      printWarning("Stacktrace : ");
      printError(stacktrace.toString());
      return null;
    }
  }


  Future<dynamic> patchRequest({
    required String apiUrl,
    required String requestJson,
  }) async {
    try {
      var headers = await getHeaderMap();

      final response = await ApiCall.patchMethod(
        url: apiUrl,
        headers: headers,
        body: requestJson,
      );
      printMe(" API Request for $apiUrl Api:  ### ");
      printMe("RequestJson : $requestJson");
      printMe(response.request.toString());
      printMe("code" + response.statusCode.toString());
      printMe("[√]Response :");
      printResponse(response.body);
      return response;
    } catch (e, stacktrace) {
      printWarning("Exception : $e");
      printError(e.toString());
      printWarning("Stacktrace : ");
      printError(stacktrace.toString());
      return null;
    }
  }
// Put mehod

  Future<dynamic> putRequest({
    required String apiUrl,
    required String requestJson,
  }) async {
    try {
      var headers = await getHeaderMap();

      final response = await ApiCall.putMethod(
        url: apiUrl,
        headers: headers,
        body: requestJson,
      );
      printMe(" API Request for $apiUrl Api:  ### ");
      printMe("RequestJson : $requestJson");
      printMe(response.request.toString());
      printMe("code" + response.statusCode.toString());
      printMe("[√]Response :");
      printResponse(response.body);
      return response;
    } catch (e, stacktrace) {
      printWarning("Exception : $e");
      printError(e.toString());
      printWarning("Stacktrace : ");
      printError(stacktrace.toString());
      return null;
    }
  }



  ///------------------------ Multipart Upload (File Upload) ------------------------





  Future<dynamic> uploadFileRequest({
    required String apiUrl,
    required File file,
    String fileFieldName = "file",
    Map<String, String>? extraFields,
    bool returnWithStatusCode = false,
  }) async {
    try {
      var headers = await getHeaderMap();

      // Remove JSON header for multipart
      headers.remove('Content-Type');

      final uri = Uri.parse(apiUrl);

      var request = http.MultipartRequest("POST", uri);

      // Attach headers
      request.headers.addAll(headers);

      // Add file
      request.files.add(
        await http.MultipartFile.fromPath(
          fileFieldName,
          file.path,
        ),
      );

      // Add additional fields if provided
      if (extraFields != null) {
        request.fields.addAll(extraFields);
      }

      printMe("UPLOAD REQUEST: $apiUrl");
      printMe("Uploading File: ${file.path}");

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      printMe("STATUS CODE : ${response.statusCode}");
      printMe("UPLOAD RESPONSE:");
      printResponse(response.body);

      if (returnWithStatusCode) return response;

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e, stacktrace) {
      printWarning("Exception in uploadFileRequest:");
      printError(e.toString());
      printWarning("Stacktrace:");
      printError(stacktrace.toString());
      return null;
    }
  }

  Future<dynamic> uploadFileRequestNew({
    required String apiUrl,
    required File file,
    String fileFieldName = "file",
    Map<String, String>? extraFields,
    bool returnWithStatusCode = false,
  }) async {
    try {
      var headers = await getHeaderMap();

      // Remove JSON header for multipart
      headers.remove('Content-Type');

      final response = await ApiCall.multipartMethod(
        url: apiUrl,
        headers: headers,
        file: file,
        fileFieldName: fileFieldName,
        extraFields: extraFields,
      );

      printMe(" API Request for $apiUrl Api:  ### ");
      printMe("Uploading File: ${file.path}");
      if (extraFields != null) {
        printMe("Extra Fields: $extraFields");
      }
      printMe(response.request.toString());
      printMe(response.statusCode.toString());
      printMe("[√]Response :");
      printResponse(response.body);
      printMe("[√]headers :");
      // print(headers);

      if (returnWithStatusCode) {
        print(returnWithStatusCode);
        return response;
      }

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      return null;
    } catch (e, stacktrace) {
      printWarning("Exception : $e");
      printError(e.toString());
      printWarning("Stacktrace : ");
      printError(stacktrace.toString());
      return null;
    }
  }

}
