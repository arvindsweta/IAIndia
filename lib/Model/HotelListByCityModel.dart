class HotelListByCityModel {
  List<HotelCityItem>? d;

  HotelListByCityModel({this.d});

  HotelListByCityModel.fromJson(Map<String, dynamic> json) {
    if (json['d'] != null) {
      d = <HotelCityItem>[];
      json['d'].forEach((v) {
        d!.add(new HotelCityItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.d != null) {
      data['d'] = this.d!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HotelCityItem {

  int? iD;
  String? HotelName;
  String? Place;



  HotelCityItem(
      {
        this.iD,
        this.Place,
        this.HotelName,

      });

  HotelCityItem.fromJson(Map<String, dynamic> json) {

    iD = json['ID'];
    Place = json['Place'];
    HotelName = json['HotelName'];


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['ID'] = this.iD;
    data['Place'] = this.Place;
    data['HotelName'] = this.HotelName;


    return data;
  }
}
