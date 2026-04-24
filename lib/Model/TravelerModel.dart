class TravelerModel {
  final String firstName;
  final String familyName;
  final String designation;
  final String division;
  final String emailID;
  final String phone;
  final String vip;
  final bool isApproved;
  final String reportTo;
  final String travelerType;
  final String status;

  TravelerModel({
    required this.firstName,
    required this.familyName,
    required this.designation,
    required this.division,
    required this.emailID,
    required this.phone,
    required this.vip,
    required this.isApproved,
    required this.reportTo,
    required this.travelerType,
    required this.status,
  });

  // Factory constructor to create a Traveler from JSON
  factory TravelerModel.fromJson(Map<String, dynamic> json) {
    // Accessing the nested 'd' object from your provided structure
    final data = json['d'];

    return TravelerModel(
      firstName: data['FirstName'] ?? '',
      familyName: data['FamilyName'] ?? '',
      designation: data['Designation'] ?? '',
      division: data['Division'] ?? '',
      emailID: data['EmailID'] ?? '',
      phone: data['Phone'] ?? '',
      vip: data['VIP'] ?? '',
      // Parsing "True" string to boolean
      isApproved: data['ApprovedBit']?.toString().toLowerCase() == 'true',
      reportTo: data['ReportTo'] ?? '',
      travelerType: data['TravelerType'] ?? '',
      status: data['Status'] ?? '',
    );
  }
}