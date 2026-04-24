import 'dart:convert';

class VerifyOtpResponse {
  final Map<String, dynamic>? d;

  VerifyOtpResponse({this.d});

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    // 1. Get the 'd' value (which is currently a String)
    var dValue = json['d'];

    if (dValue is String) {
      // 2. Decode the string into a real Map
      return VerifyOtpResponse(
        d: jsonDecode(dValue) as Map<String, dynamic>,
      );
    } else if (dValue is Map<String, dynamic>) {
      // Handle cases where it might already be a map
      return VerifyOtpResponse(d: dValue);
    }

    return VerifyOtpResponse(d: null);
  }
}