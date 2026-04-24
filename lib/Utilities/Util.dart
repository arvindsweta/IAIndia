import 'dart:io';
import 'dart:ui';



import 'package:flutter/material.dart';


import 'package:get/get.dart';

import 'package:http/http.dart' as http;

import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;


import '../Constants/Colors.dart';
import '../constants/Assets.dart';
import 'Debug/PrintMe.dart';

/* String getTimeZoneToDate(String dateTime){
    var dateValue =  DateFormat("yyyy-MM-ddTHH:mm:ssZ").parseUTC(dateTime).toLocal();
    String formattedDate = DateFormat("dd MMM yyyy hh:mm a").format(dateValue);
    return formattedDate;
  }*/
String capitalizeFirstLetter(String input) {
  if (input == null || input.isEmpty) {
    return input;
  }
  return input[0].toUpperCase() + input.substring(1).toLowerCase();
}

String allWordsCapitilize(String value) {
  var result = value[0].toUpperCase();
  for (int i = 1; i < value.length; i++) {
    if (value[i - 1] == " ") {
      result = result + value[i].toUpperCase();
    } else {
      result = result + value[i];
    }
  }
  return result;
}

String getHTMLContent(String title, String desc, String url) {
  String htmlContent = """
         <!DOCTYPE html><html>
<body>

<h1><i><b>${title}</h1></i></b>
<h3>${desc}</h3>
<a href="${url}">click to view
</a>


</body>
</html>
""";
  return htmlContent;
}

String maskEmail(String email) {
  // Split the email into local part and domain part
  List<String> parts = email.split('@');
  String localPart = parts[0];
  String domainPart = parts[1];

  // Mask local part: Show first 2 characters, replace the rest with stars
  String maskedLocalPart = localPart.substring(0, 2) +
      '*' * (localPart.length - 2) +
      localPart.substring(localPart.length - 1, localPart.length);

  // Mask domain part: Show first 2 characters of the domain, replace the rest with stars
  int atIndex = domainPart.indexOf('.');
  String maskedDomain = domainPart.substring(0, atIndex) +
      '*' * (domainPart.length - atIndex - 1);

  // Combine the masked parts
  return maskedLocalPart + '@' + maskedDomain;
}

String getCurrentDate() {
  DateTime dateTimeNow = DateTime.now();
  return DateFormat('yyyy-MM-dd').format(dateTimeNow);
}

String getCurrentDateDD_MMM_YYYY() {
  DateTime dateTimeNow = DateTime.now();
  return DateFormat('dd MMM yyyy').format(dateTimeNow);
}

String getFormattedDateTimeFromUTC(String utcData) {
  if (utcData == "null" || utcData == "") return "";
  DateTime dateTime = DateTime.parse(utcData);
  dateTime = dateTime.add(DateTime.parse(utcData).timeZoneOffset);
  var finalDate = DateFormat('MMM, yyyy').format(dateTime.toUtc());
  var day = DateFormat('dd').format(dateTime.toUtc());
  // return day + "" + finalDate;
  return '${day}${getDayOfMonthSuffix(int.parse(day))} ${finalDate}';
}


String getGreeting() {
  final hour = DateTime.now().hour;

  if (hour < 12) {
    return 'Good Morning';
  } else if (hour < 17) {
    return 'Good Afternoon';
  } else {
    return 'Good Evening';
  }
}


String getDayOfMonthSuffix(int dayNum) {
  if (!(dayNum >= 1 && dayNum <= 31)) {
    throw Exception('Invalid day of month');
  }

  if (dayNum >= 11 && dayNum <= 13) {
    return 'th';
  }

  switch (dayNum % 10) {
    case 1:
      return 'st';
    case 2:
      return 'nd';
    case 3:
      return 'rd';
    default:
      return 'th';
  }
}




String getFormattedDateDMY(String utcData) {
  if (utcData == "null" || utcData == "") return "";
  DateTime dateTime = DateTime.parse(utcData);
  dateTime = dateTime.add(DateTime.parse(utcData).timeZoneOffset);
  var finalDate = DateFormat('dd mm yyyy').format(dateTime.toUtc());
  return finalDate;
}

String getFormattedDateMMMYYY(String utcData) {
  if (utcData == "null" || utcData == "") return "";
  DateTime dateTime = DateTime.parse(utcData);
  dateTime = dateTime.add(DateTime.parse(utcData).timeZoneOffset);
  var finalDate = DateFormat('MMMM yyyy').format(dateTime.toUtc());
  return finalDate;
}



String getFormattedDateFromDate(String fromdate) {
  DateTime dateTimeCreatedAt = DateTime.parse(fromdate);
  var manthDate = DateFormat('dd MMM yyyy').format(dateTimeCreatedAt.toUtc());
  return manthDate;
}
/*String getFormattedDDMMYYY(String? fromdate) {
  // 1. Handle null or empty input immediately
  if (fromdate == null || fromdate.isEmpty) {
    return "--"; // Or return an empty string
  }

  try {
    // 2. Define exactly what the input looks like
    DateFormat inputFormat = DateFormat("dd/MM/yyyy HH:mm:ss");

    // 3. Parse the string
    DateTime dateTimeCreatedAt = inputFormat.parse(fromdate);

    // 4. Return the new format
    return DateFormat('dd-MM-yyyy').format(dateTimeCreatedAt.toUtc());

  } catch (e) {
    // 5. Handle cases where the string exists but is "garbage"
    print("Error parsing date: $e");
    return "Invalid Date";
  }
}*/
String getFormattedDDMMYYY(String? fromdate) {
  // 1. Handle null or empty input immediately
  if (fromdate == null || fromdate.isEmpty) {
    return "--"; // Or return an empty string
  }

  try {
    DateFormat inputFormat = DateFormat("yyyy-MM-dd");
    DateTime dateTime = inputFormat.parse(fromdate);
    print(dateTime);
    return DateFormat("dd-MMM-yyyy").format(dateTime);
    // Format to any desired output



  } catch (e) {
    // 5. Handle cases where the string exists but is "garbage"
    print("Error parsing date: $e");
    return "Invalid Date";
  }
}

String getTimeFromDate(String fromdate) {
  if (fromdate == "" || fromdate == null || fromdate == "null") return "";
  print("==>"+fromdate);

  DateTime dateTimeCreatedAt = DateTime.parse(fromdate);
  var finalDate = DateFormat('HH:mm a').format(dateTimeCreatedAt.toUtc());
  return finalDate;
}

String getDateOnlyFromDate(String fromdate) {
  if (fromdate == "" || fromdate == null || fromdate == "null") return "";
  DateTime dateTimeCreatedAt = DateTime.parse(fromdate);
  var finalDate = DateFormat('dd').format(dateTimeCreatedAt.toUtc());
  return finalDate;
}

String getMonthOnlyFromDate(String fromdate) {
  if (fromdate == "" || fromdate == null || fromdate == "null") return "";
  DateTime dateTimeCreatedAt = DateTime.parse(fromdate);
  var finalDate = DateFormat('MMM').format(dateTimeCreatedAt.toUtc());
  return finalDate;
}

String getFormattedTimeFromDate(String fromdate) {
  DateTime dateTimeCreatedAt = DateTime.parse(fromdate);
  var manthDate = DateFormat('dd MMM yyyy').format(dateTimeCreatedAt.toUtc());
  return manthDate;
}

String getFormattedDateDMMY(String utcData) {
  if (utcData == "null" || utcData == "") return "";
  DateTime dateTime = DateTime.parse(utcData);
  dateTime = dateTime.add(DateTime.parse(utcData).timeZoneOffset);
  var finalDate = DateFormat('dd').format(dateTime.toUtc());
  var manthDate = DateFormat('MMM yyyy').format(dateTime.toUtc());
  var sctal =
      "${finalDate}" "${getDayNumberSuffix(int.parse(finalDate))} ${manthDate}";
  return sctal;
}

String getFormattedMMDateYYYY(String utcData) {
  if (utcData == "null" || utcData == "") return "";
  DateTime dateTime = DateTime.parse(utcData);
  dateTime = dateTime.add(DateTime.parse(utcData).timeZoneOffset);
  var finalDate = DateFormat('dd').format(dateTime.toUtc());
  var manthDate = DateFormat('MMM').format(dateTime.toUtc());
  var year = DateFormat('yyyy').format(dateTime.toUtc());
  var sctal = "${manthDate}  ${finalDate}"
      "${getDayNumberSuffix(int.parse(finalDate))} ${year}";
  return sctal;
}

String getDayNumberSuffix(int day) {
  if (day >= 11 && day <= 13) {
    return "th";
  }
  switch (day % 10) {
    case 1:
      return "st";
    case 2:
      return "nd";
    case 3:
      return "rd";
    default:
      return "th";
  }
}



bool isNavigationBarVisible(BuildContext context) {

  final padding = MediaQuery.of(context).viewPadding;

  if(Platform.isIOS)
    {
      return false;
    }

   else if(padding.bottom >24.0)
     {
       return true;
     }

  return false;
}

String getFormattedDateYMD(String utcData) {
  if (utcData == "null" || utcData == "") return "";
  DateTime dateTime = DateTime.parse(utcData);
  dateTime = dateTime.add(DateTime.parse(utcData).timeZoneOffset);
  var finalDate = DateFormat('yyyy-MM-dd').format(dateTime.toUtc());
  return finalDate;
}

String getFormattedDateYMDHHMMSS(String utcData) {
  if (utcData == "null" || utcData == "") return "";
  DateTime dateTime = DateTime.parse(utcData);
  dateTime = dateTime.add(DateTime.parse(utcData).timeZoneOffset);
  var finalDate =
      DateFormat("yyyy-MM-dd").format(dateTime.toUtc());
  return finalDate;
}

String getFormattedDateAndTimeFromUTC(String utcData) {
  if (utcData == "null" || utcData == "") return "";
  DateTime dateTime = DateTime.parse(utcData);
  dateTime = dateTime.add(DateTime.parse(utcData).timeZoneOffset);
  var finalDate = DateFormat('dd MMM yy').format(dateTime.toUtc());
  return finalDate;
}

String getFormattedDateAndTimeFromUTCYYYMMDD(String utcData) {
  if (utcData == "null" || utcData == "") return "";
  DateTime dateTime = DateTime.parse(utcData);
  dateTime = dateTime.add(DateTime.parse(utcData).timeZoneOffset);
  var finalDate = DateFormat('yyyy,MMM,dd').format(dateTime.toUtc());
  return finalDate;
}

String getFormattedCalculateDaya(String utcData) {
  var array = utcData.split(",");

  DateTime currentDate = DateTime.now(); // current date
  DateTime expiryDate = DateTime.parse(utcData);

  //Duration difference = currentDate.difference(expiryDate); // your expiry date

  Duration difference = currentDate.difference(expiryDate);
  int daysRemaining = difference.inDays;
  print(currentDate);
  print(expiryDate);

  if (daysRemaining < 0) {
    return '$daysRemaining days ';
  } else if (daysRemaining == 0) {
    DateTime localAsUtc = currentDate.toUtc();

    // Difference
    Duration diff = localAsUtc.difference(expiryDate);
    if (diff.inHours > 0) {
      return '${diff.inHours}hr ago';
    } else {
      return '${diff.inMinutes.remainder(60)}min  ago';
    }

    //print('Expires today');
  } else {
    return '$daysRemaining days ago';
  }

  /*if (utcData == "null" || utcData == "") return "";
  DateTime dateTime = DateTime.parse(utcData);
  dateTime = dateTime.add(DateTime.parse(utcData).timeZoneOffset);
  var finalDate = DateFormat('dd MMM yyyy').format(dateTime.toUtc());*/
}

String getFormattedDateAndTimeFromGMT(String utcData) {
  if (utcData == "null" || utcData == "") return "";
  if (utcData.contains("GMT")) {
    var data = utcData.split(" ");
    var dates = data.length == 6 ? "${data[2]} ${data[1]} ${data[5]}" : utcData;
    return dates;
  } else {
    return utcData;
  }
}

String getFormattedTimeFromUTC(String utcData) {
  if (utcData == "null" || utcData == "") return "";
  DateTime dateTime = DateTime.parse(utcData);
  dateTime = dateTime.add(DateTime.parse(utcData).timeZoneOffset);
  var finalDate = DateFormat('hh:mm').format(dateTime.toUtc());
  return finalDate;
}

String getOnlyDateFromUTC(String utcData) {
  if (utcData == "null" || utcData == "") return "";
  DateTime dateTime = DateTime.parse(utcData);
  dateTime = dateTime.add(DateTime.parse(utcData).timeZoneOffset);
  return dateTime.day.toString();
}

String getOnlyMonthFromUTC(String utcData) {
  if (utcData == "null" || utcData == "") return "";
  DateTime dateTime = DateTime.parse(utcData);
  dateTime = dateTime.add(DateTime.parse(utcData).timeZoneOffset);
  return DateFormat.MMM().format(dateTime);
}

String getFormattedTimeYYYYMMDD(String utcData) {
  if (utcData == "null" || utcData == "") return "";
  DateTime dateTime = DateTime.parse(utcData);
  dateTime = dateTime.add(DateTime.parse(utcData).timeZoneOffset);
  var finalDate = DateFormat('hh:mm a').format(dateTime.toUtc());
  return finalDate;
}

String getFormattedTimeAmPmFromUTC(String utcData) {
  if (utcData == "null" || utcData == "") return "";
  DateTime dateTime = DateTime.parse(utcData);

  var finalDate = DateFormat('dd/MM/yyyy').format(dateTime);
  return finalDate;
}

String getTimestampToDateTime(int millis) {
  var dt = DateTime.fromMillisecondsSinceEpoch(millis * 1000);
  var d12 = DateFormat('dd MMM yyyy,hh:mm a').format(dt);
  return d12.toString();
}
String getddyyyMMMTime(int millis) {
  var dt = DateTime.fromMillisecondsSinceEpoch(millis * 1000);
  var d12 = DateFormat('yyyyy-MM-dd').format(dt);
  return d12.toString();
}
String getConvertDate(String fromdate) {

  int ms = int.parse(fromdate.replaceAll(RegExp(r'[^0-9]'), ''));
  DateTime dt = DateTime.fromMillisecondsSinceEpoch(ms);

  String dateformatted = DateFormat('dd-MM-yyyy').format(dt);
  return dateformatted;

 /* var dt = DateTime.fromMillisecondsSinceEpoch(millis * 1000);
  var d12 = DateFormat('yyyyy-MM-dd').format(dt);
  return d12.toString();*/
}



isDateBeforeToday(utcData) {
  DateTime dateTime = DateTime.parse(utcData);
  dateTime = dateTime.add(DateTime.parse(utcData).timeZoneOffset);
  return dateTime.isBefore(DateTime.now());
}

String getTimeDiffrence(String fromdate) {
  DateTime dateTimeCreatedAt = DateTime.parse(fromdate);
  DateTime dateTimeNow = DateTime.now();

  final differenceInDays = dateTimeNow.difference(dateTimeCreatedAt).inHours;
  print('$differenceInDays');
  //
  // final differenceInMonths = dateTimeNow.difference(dateTimeCreatedAt).inMonths;
  // print('$differenceInMonths');
  return differenceInDays.toString();
}

String capitalizeEachWord(String text) {
  return text
      .split(' ')
      .map((word) =>
  word.isEmpty ? word : word[0].toUpperCase() + word.substring(1))
      .join(' ');
}



double getPageMargin(BuildContext context) {
  return MediaQuery.of(context).size.width * 0.055;
}



Future<bool> hasNetwork(BuildContext context) async {
  try {
    final result = await InternetAddress.lookup('example.com');
    bool data = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    if (data == false) {
      // noInternetConevtivitiView(context: context);
      return data;
    } else {
      return data;
    }
  } on SocketException catch (_) {
    // noInternetConevtivitiView(context: context);
    return false;
  }
}





int parseDoubleToInteger(String value) {
  if (value == "" || value == null) {
    return 0;
  }
  if (value.contains(".")) {
    return double.parse(value).round();
  } else {
    return int.parse(value);
  }
}


String getInitials(String name) {
  List<String> parts = name.trim().split(' ');
  String initials = '';
  for (var part in parts) {
    if (part.isNotEmpty) {
      initials += part[0].toUpperCase();
    }
  }
  return initials;
}





Future<File> changeFileNameOnly(File file, String newFileName) {
  var path = file.path;
  var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
  var newPath = path.substring(0, lastSeparator + 1) + newFileName;
  return file.rename(newPath);
}



String setRating(int stars) {
  if (stars < 1) return '0.0';
  if (stars > 5) return '1.0';

  // 1 star = 0.2, 2 stars = 0.4, 3 stars = 0.6, 4 stars = 0.8, 5 stars = 1.0
  double value = stars * 0.2;
  return value.toStringAsFixed(1);
}


Color getBadgeColor(String badge) {
  switch (badge.toLowerCase()) {
    case 'silver':
      return silverBg;
    case 'bronze':
      return badgeBg;
    case 'gold':
      return goldBg;
    case 'platinum':
      return platinumBg;
    case 'diamond':
      return diamondBg;
    default:
      return badgeBg;
  }
}

Color getBadgePercentageColor(String badge) {
  switch (badge.toLowerCase()) {
    case 'silver':
      return silverPercentage;
    case 'bronze':
      return badgePercentage;
    case 'gold':
      return goldPercentage;
    case 'platinum':
      return platinumPercentage;
    case 'diamond':
      return diamondPercentage;
    default:
      return badgePercentage;
  }
}





