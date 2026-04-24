import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// A universal logging function that can be used throughout the project.
///
/// - [message]: The content to log (any type)
/// - [useLog]: If true, uses developer.log, otherwise uses print (default: false)
/// - [tag]: Optional tag prefix for the log message
/// - [isApiLog]: If true, automatically detects and formats API requests/responses
void logIt<T>(
  T message, {
  bool useLog = false,
  String? tag,
}) {
  if (kDebugMode) {
    // Build the formatted message
    final StringBuffer buffer = StringBuffer();

    // Add tag prefix if provided
    if (tag != null && tag.isNotEmpty) {
      buffer.write('[$tag] ');
    }

    // Add API request/response indicators if enabled
    // Add the actual message
    buffer.write(message);

    // Output using the selected method
    if (useLog) {
      developer.log(buffer.toString());
    } else {
      print(buffer.toString());
    }
  }
}

/// A dedicated API logging function that prints request and response data with colors
/// for better readability in console logs.
///
/// - [endPoint]: The API endpoint being called
/// - [requestJson]: The request payload as a JSON string (can be empty)
/// - [statusCode]: The HTTP status code returned (optional)
/// - [response]: The response data (optional)
/// - [useLog]: If true, uses developer.log instead of print (default: false)
/// - [tag]: Optional tag prefix for the log (default: "API")
void printRequestData({
  String tag = "API",
  String? endPoint,
  String requestJson = "",
  int? statusCode,
  dynamic response,
  bool useLog = false,
  String  ? isGetRequest,
}) {
  if (kDebugMode) {
    // ANSI Color codes for console output
    const String reset = '\x1B[0m';
    const String red = '\x1B[31m';
    const String green = '\x1B[32m';
    const String yellow = '\x1B[33m';
    const String blue = '\x1B[34m';
    const String magenta = '\x1B[35m';
    const String cyan = '\x1B[36m';

    // Build message with colors
    final StringBuffer buffer = StringBuffer();

    // Header with endpoint
    buffer.write('${magenta}API : [$tag]${reset} ');
    if (endPoint != null) {
      buffer.write('${cyan}ENDPOINT:${reset} $endPoint\n');
    }

    // Request data (only if not empty)
    if (requestJson.isNotEmpty) {
      buffer.write('${blue}➡️ REQUEST:${reset}\n$requestJson\n');
    } else {
      buffer.write('${blue}➡️ REQUEST:${reset} <empty>\n');
    }



    // Response data if available
    if (response != null) {
      // Color-code status based on code
      String statusColor = yellow;
      if (statusCode != null) {
        if (statusCode >= 200 && statusCode < 300) {
          statusColor = green;
        } else if (statusCode >= 400) {
          statusColor = red;
        }
        buffer.write('${statusColor}STATUS:${reset} $statusCode\n');
      }

      buffer.write('${green}⬅️ RESPONSE:${reset}\n$response');
    }

    // Output using selected method
    final String message = buffer.toString();
    if (useLog) {
      developer.log(message);
    } else {
      print(message);
    }
  }
}

void printException(dynamic exception, [StackTrace? stackTrace]) {
  if (kDebugMode) {
    const String reset = '\x1B[0m';
    const String red = '\x1B[31m';
    const String yellow = '\x1B[33m';

    final StringBuffer buffer = StringBuffer();

    // Exception header
    buffer.write('\n${red}❌ EXCEPTION !!! ${reset}\n');

    // Exception message
    buffer.write('${red}Message:${reset} $exception\n');

    // Stacktrace if available
    if (stackTrace != null) {
      buffer.write('${yellow}StackTrace:${reset}\n$stackTrace');
    }

    print(buffer.toString());
  }
}
