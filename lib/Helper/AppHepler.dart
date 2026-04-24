import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:device_info_plus/device_info_plus.dart' show DeviceInfoPlugin;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:myfirstdemo/Helper/NotificationService.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Services/ApiServices/SecureStorageService.dart';
import '../Utilities/Debug/PrintMe.dart';


class AppHelper{

  static final StreamController<ForegroundNotificationEvent> foregroundNotificationStream =
  StreamController<ForegroundNotificationEvent>.broadcast();

  final SecureStorageService tokenController = SecureStorageService();

  var notificationService = NotificationService();
  var _totalNotifications=0;


/*Future<void> storeDeviceDetails() async {
  tokenController.writeDeeplinkUrl(data: "");
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    var iosDeviceInfo = await deviceInfo.iosInfo;
    tokenController.writeDeviceID(data:iosDeviceInfo.identifierForVendor.toString());
    tokenController.writeDeviceTYPE(data:"ios");
  } else if (Platform.isAndroid) {
    final deviceId = await DeviceIdHelper.getAndroidId();
    tokenController.writeDeviceID(data:deviceId);
    tokenController.writeDeviceTYPE(data:"android");
  }
  showLog("DeviceId-> " + tokenController.getDeviceId.toString());
  print("DeviceId-> " + tokenController.getDeviceId.toString());
}*/
  void storeDeviceDetails() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;

      iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;


      // androidDeviceInfo.id; // unique ID on Android
    }






  }



Future<void> checkForFcmToken() async {


  await FirebaseMessaging.instance.requestPermission();
  notificationService.initializePlatformNotifications();

  await Permission.notification.isDenied.then((value) {
    if (value) {
      print("Notification-> permission Req.." + value.toString());
      Permission.notification.request();
    }
  });

  String? token;
  const int maxAttempts = 3;

  for (int attempt = 1; attempt <= maxAttempts; attempt++) {
    try {
      token = await FirebaseMessaging.instance.getToken(); // generate fcm token of device
      printMe("FCM TOKEN>=======>" + token.toString());
      if (!["", "null", null, false].contains(token)) {
        break;
      }
    } on FirebaseException catch (e) {
      printMe("FCM getToken failed [${e.code}]: ${e.message}");
      if (attempt == maxAttempts) {
        return;
      }
    } catch (e) {
      printMe("FCM getToken failed: $e");
      if (attempt == maxAttempts) {
        return;
      }
    }

    await Future.delayed(Duration(seconds: attempt * 2));
  }

  if (["", "null", null, false].contains(token)) {
    return;
  }

  tokenController.writeFCMToken(token.toString());
  registerNotification(); // register with token




}

void registerNotification() async {
 var _messaging = await FirebaseMessaging.instance;
  NotificationSettings settings = await _messaging.requestPermission(
    alert: true,
    badge: true,
    // provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');

    // Do not let iOS show OS banners while app is in foreground.
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: false,
      sound: false,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {//Received message while app is in foreground
      print('@@onMessage title ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');
      _totalNotifications++;

      // Foreground: emit app-level banner event, do not create a local notification.
      foregroundNotificationStream.add(
        ForegroundNotificationEvent(
          message: message,
          title: _resolveTitle(message),
          body: _resolveBody(message),
          imageUrl: _resolveImageUrl(message),
          category: message.data['category']?.toString() ?? '',
        ),
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {// This is triggered when the app is opened via a notification tap (backgrounded app)
      print('@@onMessageOpenedApp title1: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');
      _handleNotificationTap(message);
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) async {
      print("Handling a background message: ${message}");
      if (message != null) {
        _handleNotificationTap(message);
      }
    });



  } else {
    print('User declined or has not accepted permission');
  }
}





showNotification(String imageUrl, RemoteMessage message, title, body) async {
    await notificationService.showLocalNotification(
        id: _totalNotifications,
        title: title,
        body: body,
        payload: imageUrl,
        seconds: 3,
        remoteMessage: message);

}

void _handleNotificationTap(RemoteMessage message) {
  showNotification(
    _resolveImageUrl(message),
    message,
    _resolveTitle(message),
    _resolveBody(message),
  );
}

String _resolveImageUrl(RemoteMessage message) {
  final dynamic imageValue = message.data['image'];
  if (["", "null", null, false].contains(imageValue)) {
    return '';
  }
  return imageValue.toString();
}

String _resolveTitle(RemoteMessage message) {
  final dataTitle = message.data['title'];
  if (["", "null", null, false].contains(dataTitle)) {
    return message.notification?.title ?? '';
  }
  return dataTitle.toString();
}

String _resolveBody(RemoteMessage message) {
  final dataBody = message.data['body'];
  if (["", "null", null, false].contains(dataBody)) {
    return message.notification?.body ?? '';
  }
  return dataBody.toString();
}

  Future<void> _configureSelectNotificationSubject(String screenType,String id) async {
    /*tokenController.writeNotificationID(data: id);
    tokenController.writeNotificationCategory(data: screenType);
    if (tokenController.isUserLoggedIn == false) {
      Navigator.of(NavigationContext.navigatorKey.currentContext!)
          .pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => SplashScreen()));
    } else {
      Future.delayed(Duration(milliseconds: 10), () {
        Navigator
            .of(NavigationContext.navigatorKey.currentContext!)
            .pushReplacement(MaterialWithModalsPageRoute(
            builder: (BuildContext context) =>
                DashboardScreen(openFrom: "notification")));
      });
      //}
    }*/
  }

}

class ForegroundNotificationEvent {
  final RemoteMessage message;
  final String title;
  final String body;
  final String imageUrl;
  final String category;

  ForegroundNotificationEvent({
    required this.message,
    required this.title,
    required this.body,
    required this.imageUrl,
    required this.category,
  });
}
