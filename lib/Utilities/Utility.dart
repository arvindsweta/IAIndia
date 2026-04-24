// import 'package:device_info_plus/device_info_plus.dart';
import 'dart:convert';

import 'package:intl/intl.dart';

import '../Model/ExpenceChatModel.dart';


class Utility {

  String formatNewsDate(String? inputDate) {
    if (inputDate == null || inputDate.isEmpty) {
      return '';
    }

    try {
      // Parse the input date string
      DateTime date = DateTime.parse(inputDate).toLocal();

      // Define month names
      const monthNames = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];

      // Get suffix (st, nd, rd, th)
      String getDaySuffix(int day) {
        if (day >= 11 && day <= 13) return 'th';
        switch (day % 10) {
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

      String month = monthNames[date.month - 1];
      String suffix = getDaySuffix(date.day);

      return '$month ${date.day}$suffix ${date.year}';
    } catch (e) {
      return '';
    }
  }

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else if (hour < 21) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  String getDateNumber(String dateTimeString) {
    try {
      // Parse the date-time string into a DateTime object
      final dateTime = DateTime.parse(dateTimeString);

      // Format the DateTime object to get only the day number (with leading zero)
      final dayNumber = DateFormat('dd').format(dateTime);

      return dayNumber; // e.g., "08"
    } catch (e) {
      // Handle any parsing errors
      return '';
    }
  }

  String getMonthName(String dateTimeString) {
    try {
      // Parse the date-time string into a DateTime object
      final dateTime = DateTime.parse(dateTimeString);

      // Format the DateTime object to get the abbreviated month name in uppercase
      final monthName = DateFormat('MMM').format(dateTime).toUpperCase();

      return monthName; // e.g., "APR"
    } catch (e) {
      // Handle any parsing errors
      return '';
    }
  }

  String getTime(String dateTimeString) {
    try {
      // Parse the date-time string into a DateTime object
      final dateTime = DateTime.parse(dateTimeString).toLocal();

      // Format the DateTime object to display time like "10:00 AM"
      final timeString = DateFormat('hh:mm a').format(dateTime);

      return timeString; // e.g., "10:00 AM"
    } catch (e) {
      // Handle any parsing errors
      return '';
    }
  }

  String capitalizeFirstLetter(String? input) {
    // Return empty string if input is null or empty
    if (input == null || input.isEmpty) return 'Male';

    return input[0].toUpperCase() + input.substring(1);
  }





  String convertToISODate(String? date) {
    try {
      // Null or empty check
      if (date == null || date.trim().isEmpty) {
        return '';
      }

      // Parse dd/MM/yyyy format
      DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(date.trim());

      // Format to yyyy-MM-dd
      String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

      return formattedDate;

    } on FormatException catch (e) {
      print('Invalid date format: $e');
      return '';
    } catch (e) {
      print('Error converting date: $e');
      return '';
    }
  }


  String getRatedStars(double? ratingValue) {
    if (ratingValue == null || ratingValue == 0) {
      return '0 Star';
    }

    // Convert decimal rating (0.0-1.0) to star rating (0-5)
    // 0.2 = 1 star, 0.4 = 2 stars, 0.6 = 3 stars, 0.8 = 4 stars, 1.0 = 5 stars
    int stars = (ratingValue * 5).round();

    // Use singular "Star" for 1, plural "Stars" for others
    String starText = stars == 1 ? 'Star' : 'Stars';

    return 'Rated $stars $starText';
  }


  String getAvgRating(double? ratingValue, int? ratingCount) {
    print('avgRating1');
    print(ratingValue);
    print(ratingCount);
    // Handle null or zero cases
    if (ratingValue == null || ratingValue == 0) {

      return '0 Star';
    }

    if (ratingCount == null || ratingCount == 0) {
      return '0 Star';
    }

    // Calculate average rating
    double avgRating = ratingValue / ratingCount;

    print('avgRating');
    print(avgRating.toString());

    // Clamp the average rating between 0 and 5
    avgRating = avgRating.clamp(0.0, 5.0);

    // Format to 1 decimal place
    String formattedRating = avgRating.toStringAsFixed(1);

    // Use singular "Star" for exactly 1.0, plural "Stars" for others
    String starText = avgRating == 1.0 ? 'Star' : 'Stars';

    return 'Rated $formattedRating $starText';
  }



  int getRatingStars(double? ratingValue) {
    if (ratingValue == null || ratingValue == 0) {
      return 0;
    }

    // Convert decimal rating (0.0-1.0) to star rating (0-5)
    // 0.2 = 1 star, 0.4 = 2 stars, 0.6 = 3 stars, 0.8 = 4 stars, 1.0 = 5 stars
    return (ratingValue * 5).round();
  }




  String getAnnouncemetDate(String? date) {
    try {
      if (date == null || date.trim().isEmpty) {
        return "";
      }

      // Parse to local datetime
      DateTime dt = DateTime.parse(date).toLocal();
      DateTime now = DateTime.now();

      Duration difference = now.difference(dt);

      // Return relative time if within certain thresholds
      if (difference.inSeconds < 60) {
        return "Just now";
      } else if (difference.inMinutes < 60) {
        return "${difference.inMinutes} min ago";
      } else if (difference.inHours < 24) {
        int hours = difference.inHours;
        return "$hours ${hours == 1 ? 'hour' : 'hours'} ago";
      } else if (difference.inDays < 7) {
        int days = difference.inDays;
        return "$days ${days == 1 ? 'day' : 'days'} ago";
      } else {
        // For older dates, show formatted date
        String day = dt.day.toString();
        String suffix = _getOrdinalSuffix(dt.day);
        String month = DateFormat('MMM').format(dt);
        String time = DateFormat('h:mm a').format(dt).toLowerCase();

        return "$month ${dt.day}$suffix, ${dt.year}   $time";
      }
    } catch (e) {
      return "";
    }
  }

  String _getOrdinalSuffix(int day) {
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

  double safeInt(int? v) => v?.toDouble() ?? 0.0;
  double safeDouble(double? v) => v ?? 0.0;


  String getLikeDislikeText(double? ratingValue) {
    if (ratingValue == null) return "none";

    // handle 1.0 → like
    if (ratingValue == 1.0) return "like";

    // handle 0.0 → dislike
    if (ratingValue == 0.0) return "dislike";

    // everything else
    return "none";
  }



}
