 import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
 import 'package:get/get.dart';

class ApiCall {
  ///GET API CALL
  static Future<http.Response> getMethod(
      {required String endpoint, required headers, required var data}) {

    print("************");
    print(headers);
    print("************");
    return http.get(Uri.parse(endpoint + data), headers: headers);
  }

  ///POST API Call

  static Future<http.Response> postMethod(
      {required String url, required headers, required dynamic body}) async {
     return await http.post(Uri.parse(url), headers: headers, body: body);
  }

  /// PUT API Call
  static Future<http.Response> putMethod({
    required String url,
    required headers,
    required dynamic body,
  }) async {
     return await http.put(Uri.parse(url), headers: headers, body: body);
  }

  /// patchMethod API Call
  static Future<http.Response> patchMethod({
    required String url,
    required headers,
    required dynamic body,
  }) async {
     return await http.patch(Uri.parse(url), headers: headers, body: body);
  }

  /// DELETE api call

  static Future<http.Response> deleteMethod(
      {required String endpoint, required headers, required var data}) async {
    print("************");
    print(headers);
    print("************");
    return await http.delete(
      Uri.parse(endpoint + data),
      headers: headers,
    );
  }

  static Future<http.Response> multipartMethod({
    required String url,
    required Map<String, String> headers,
    required File file,
    String fileFieldName = "file",
    Map<String, String>? extraFields,
  }) async {
    final uri = Uri.parse(url);
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

    // Send request and convert to Response
    var streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }


  showLoader() {
    Future.delayed(Duration.zero, () {
      showDialog(


          barrierColor: Colors.black12,
          context: Get.context!,
          builder: (_) => Material(
              type: MaterialType.transparency,
              child: WillPopScope(
                onWillPop: () async => false,
                child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Container(
                      alignment: Alignment.center,
                      // margin: EdgeInsets.only(top: 20),
                      child: Container(

                          child: Container(
                            margin: EdgeInsets.only(top: 20),
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              color: Colors.deepPurple,
                            ),
                          )

                      ),
                    )),
              )));
    });
  }

  Future<Map<String, String>> getHeaderWithTokenMap(String newToken) async {
    return {
      "Content-Type": "application/json",
      'Authorization': "Bearer " + newToken
    };
  }

  dismissLoader() {
    Get.back();
  }


}

