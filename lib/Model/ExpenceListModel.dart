class ExpenceListModel {
  List<ExpenceItem>? d;

  ExpenceListModel({this.d});

  ExpenceListModel.fromJson(Map<String, dynamic> json) {
    if (json['d'] != null) {
      d = <ExpenceItem>[];
      json['d'].forEach((v) {
        d!.add(new ExpenceItem.fromJson(v));
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

class ExpenceItem {

  int? iD;
  String? ExpenceName;



  ExpenceItem(
      {
        this.iD,
        this.ExpenceName,

        });

  ExpenceItem.fromJson(Map<String, dynamic> json) {

    iD = json['ID'];
    ExpenceName = json['ExpenceName'];


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['ID'] = this.iD;
    data['ExpenceName'] = this.ExpenceName;


    return data;
  }
}
