class LoginResponce {
  final String? d; // This matches the "d" in {"d": "Valid"}

  LoginResponce({this.d});

  factory LoginResponce.fromJson(Map<String, dynamic> json) {
    return LoginResponce(
      d: json['d'], // Extracts the value
    );
  }
}