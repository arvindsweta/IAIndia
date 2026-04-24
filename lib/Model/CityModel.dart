class CityModel {
  List<CityItem>? d;

  CityModel({this.d});

  CityModel.fromJson(Map<String, dynamic> json) {
    if (json['d'] != null) {
      d = <CityItem>[];
      json['d'].forEach((v) {
        d!.add(new CityItem.fromJson(v));
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

class CityItem {
  String? sType;
  String? iD;
  String? cityName;
  String? stateID;
  String? stateName;
  String? countryID;
  String? alias;
  String? cityStatus;
  String? status;
  Null? updateBy;
  String? countryName;

  CityItem(
      {this.sType,
        this.iD,
        this.cityName,
        this.stateID,
        this.stateName,
        this.countryID,
        this.alias,
        this.cityStatus,
        this.status,
        this.updateBy,
        this.countryName});

  CityItem.fromJson(Map<String, dynamic> json) {
    sType = json['__type'];
    iD = json['ID'];
    cityName = json['CityName'];
    stateID = json['StateID'];
    stateName = json['StateName'];
    countryID = json['CountryID'];
    alias = json['Alias'];
    cityStatus = json['CityStatus'];
    status = json['Status'];
    updateBy = json['UpdateBy'];
    countryName = json['CountryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__type'] = this.sType;
    data['ID'] = this.iD;
    data['CityName'] = this.cityName;
    data['StateID'] = this.stateID;
    data['StateName'] = this.stateName;
    data['CountryID'] = this.countryID;
    data['Alias'] = this.alias;
    data['CityStatus'] = this.cityStatus;
    data['Status'] = this.status;
    data['UpdateBy'] = this.updateBy;
    data['CountryName'] = this.countryName;
    return data;
  }
}
