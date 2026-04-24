class TripExpenseResponse {
  final bool success;
  final String message;
  final List<TripExpenseData> data;

  TripExpenseResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory TripExpenseResponse.fromJson(Map<String, dynamic> json) {
    var root = json['d'];
    return TripExpenseResponse(
      success: root['Success'] ?? false,
      message: root['Message'] ?? '',
      data: (root['Data'] as List)
          .map((i) => TripExpenseData.fromJson(i))
          .toList(),
    );
  }
}

class TripExpenseData {
  final String type;
  final int id;
  final int tripId;
  final int expenseId;
  final String? remarks;
  final String? ApprovedRemarks;
  final String? ExpenceName;
  final String? NameOfPersone;
  final String? ExpenceDate;
  final String? ApprovedStatus;
  final DateTime? expenseDate;
  final String? expenseImage1;
  final String? expenseImage2;
  final String? expenseImage3;
  final String? TriPlace;
  final String? RembursmentRemarks;
  final String? Status;
  final double expenseAmount;


  final bool? approvedBit;

  TripExpenseData({
    required this.type,
    required this.id,
    required this.tripId,
    required this.expenseId,
    required this.ExpenceDate,
    required this.ExpenceName,
    required this.ApprovedStatus,
    required this.NameOfPersone,
    required this.RembursmentRemarks,
    required this.ApprovedRemarks,
    this.remarks,
    this.expenseDate,
    this.expenseImage1,
    this.expenseImage2,
    this.expenseImage3,
    this.Status,
    required this.expenseAmount,
    this.approvedBit,
    this.TriPlace,
  });

  factory TripExpenseData.fromJson(Map<String, dynamic> json) {
    return TripExpenseData(
      type: json['__type'] ?? '',
      id: json['ID'] ?? 0,
      tripId: json['TripID'] ?? 0,
      expenseId: json['ExpenceID'] ?? 0,
      remarks: json['Remarks'],
      ExpenceName: json['ExpenceName'],
      ExpenceDate: json['ExpenceDate'] ?? "/Date(1775586600000)/",
      NameOfPersone: json['NameOfPersone'],
      ApprovedStatus: json['ApprovedStatus'],
      RembursmentRemarks: json['RembursmentRemarks'],
      ApprovedRemarks: json['ApprovedRemarks'],
      Status: json['Status'],
      // Handling null for Date

      expenseImage1: json['ExpenceImage1'],
      expenseImage2: json['ExpenceImage2'],
      expenseImage3: json['ExpenceImage3'],

      expenseAmount: (json['ExpenceAmount'] as num?)?.toDouble() ?? 0.0,
      approvedBit: json['ApprovedBit'],
      TriPlace: json['TriPlace'],
    );
  }
}