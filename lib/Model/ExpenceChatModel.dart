/*
class ExpenceChatModel {
  final bool success;

  final List<ChatData> data;

  ExpenceChatModel({
    required this.success,

    required this.data,
  });

  factory ExpenceChatModel.fromJson(Map<String, dynamic> json) {
    var root = json['d'];
    return ExpenceChatModel(
      success: root['Success'] ?? false,

      data: (root['Data'] as List)
          .map((i) => ChatData.fromJson(i))
          .toList(),
    );
  }
}

class ChatData {

  final int id;

  final int expenseId;
  final String? chatMsg;
  final int  CretaedBy;
  final String? CreatedDate;
  final String? CreatedTime;
  final String? ActiveName;





  ChatData({

    required this.id,
    required this.expenseId,
    required this.chatMsg,
    required this.CretaedBy,
    required this.CreatedDate,
    required this.CreatedTime,
    required this.ActiveName,

  });

  factory ChatData.fromJson(Map<String, dynamic> json) {
    return ChatData(

      id: json['ID'] ?? 0,
      expenseId: json['TripExpenceID'] ?? 0,
      chatMsg: json['Text'],

      CretaedBy: json['CretaedBy'],
      CreatedDate: json['CreatedDate'],
      CreatedTime: json['CreatedTime'],
      ActiveName: json['ActiveName'],

    );
  }
}*/

/*
class ExpenceChatModel {
  final bool success;
  final List<ChatData> data;

  ExpenceChatModel({required this.success, required this.data});

  factory ExpenceChatModel.fromJson(Map<String, dynamic> json) {
    return ExpenceChatModel(
      success: json['Success'] ?? false,
      data: (json['Data'] as List)
          .map((item) => ChatData.fromJson(item))
          .toList(),
    );
  }
}

class ChatData {
  final int id;
  final int tripExpenceId;
  final String text;
  final int createdBy;
  final String createdDate;
  final String createdTime;
  final String rplyType;
  final String activeName;

  ChatData({
    required this.id,
    required this.tripExpenceId,
    required this.text,
    required this.createdBy,
    required this.createdDate,
    required this.createdTime,
    required this.rplyType,
    required this.activeName,
  });

  factory ChatData.fromJson(Map<String, dynamic> json) {
    return ChatData(
      id: json['ID'],
      tripExpenceId: json['TripExpenceID'],
      text: json['Text'],
      createdBy: json['CretaedBy'],
      createdDate: json['CreatedDate'],
      createdTime: json['CreatedTime'],
      rplyType: json['RplyType'],
      activeName: json['ActiveName'],
    );
  }
}*/

import 'dart:convert';

class ExpenceChatModel {
  final List<ChatData> data;

  ExpenceChatModel({required this.data});

  factory ExpenceChatModel.fromJson(Map<String, dynamic> json) {
    // 1. Get the value of 'd'
    final String dString = json['d'];

    // 2. Decode the string into a Map
    final Map<String, dynamic> decodedD = jsonDecode(dString);

    // 3. Extract the list from 'Data'
    return ExpenceChatModel(
      data: (decodedD['Data'] as List)
          .map((i) => ChatData.fromJson(i))
          .toList(),
    );
  }
}

class ChatData {
  final int id;
  final int tripExpenceId;
  final String text;
  final int createdBy;
  final String createdDate;
  final String createdTime;
  final String rplyType;
  final String activeName;

  ChatData({
    required this.id,
    required this.tripExpenceId,
    required this.text,
    required this.createdBy,
    required this.createdDate,
    required this.createdTime,
    required this.rplyType,
    required this.activeName,
  });

  factory ChatData.fromJson(Map<String, dynamic> json) {
    return ChatData(
      // Safely parse, handling both String and int inputs
      id: int.tryParse(json['ID'].toString()) ?? 0,
      tripExpenceId: int.tryParse(json['TripExpenceID'].toString()) ?? 0,
      createdBy: int.tryParse(json['CretaedBy'].toString()) ?? 0,

      // Strings are safer, but added a fallback just in case
      text: json['Text']?.toString() ?? '',
      createdDate: json['CreatedDate']?.toString() ?? '',
      createdTime: json['CreatedTime']?.toString() ?? '',
      rplyType: json['RplyType']?.toString() ?? '',
      activeName: json['ActiveName']?.toString() ?? '',
    );
  }
}