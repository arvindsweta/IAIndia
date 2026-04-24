class UserResponce {
  String? userID;

  UserResponce({this.userID});

  UserResponce.fromJson(Map<String, dynamic> json) {
    userID = json['UserID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserID'] = this.userID;
    return data;
  }
}
