import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/timezone.dart' as tz;
import 'DownloadUtil.dart';





final StreamController<NotificationResponse> didReceiveLocalNotificationStream =
StreamController<NotificationResponse>.broadcast();

class NotificationService  {
  NotificationService();
  String imageUrl = "";
  final text = Platform.isIOS;
  final BehaviorSubject<String> behaviorSubject = BehaviorSubject();
  late RemoteMessage remoteMessage;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  Future<void> initializePlatformNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('notification_ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    final InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _localNotifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) { // this will call when tap on notification of forground app
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            _configureSelectNotificationSubject(remoteMessage.data['category'], remoteMessage.data['contentId']);
            break;
          case NotificationResponseType.selectedNotificationAction:
            print("two");
            break;
        }
      },
    );
  }

  Future<void> _configureSelectNotificationSubject(
      String screenType, String id) async {

    checkNotificationAndRedirectActivity(screenType);

  }


  void checkNotificationAndRedirectActivity(screenType) {

    var redirectActivity= screenType;

    Future.delayed(Duration(milliseconds: 400), () {

    });







  }


  Future<NotificationDetails> _notificationDetailsImageShow() async {
    final bigPicture = await DownloadUtil.downloadAndSaveFile(
        imageUrl, Platform.isIOS ? "imageUrl" : "");

    AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'com.app.commercity.urgent',
      'channel name',
      groupKey: 'com.example.flutter_push_notifications',
      channelDescription: 'channel description',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      ticker: 'ticker',
      fullScreenIntent: true,
      enableVibration: true,
      largeIcon: FilePathAndroidBitmap(bigPicture),
      styleInformation: BigPictureStyleInformation(
        FilePathAndroidBitmap(bigPicture),
        hideExpandedLargeIcon: false,
      ),
      color: Colors.transparent,
    );
    DarwinNotificationDetails iosNotificationDetails =
    DarwinNotificationDetails(
        threadIdentifier: "thread1",
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        attachments: <DarwinNotificationAttachment>[
          DarwinNotificationAttachment(bigPicture)
        ]);

    final details = await _localNotifications.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {}

    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iosNotificationDetails);

    return platformChannelSpecifics;
  }




  Future<NotificationDetails> _notificationDetailsBackground() async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'com.app.IAIndia.urgent',
      'channel name',
      groupKey: 'com.example.flutter_push_notifications',
      channelDescription: 'channel description',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      ticker: 'ticker',
      fullScreenIntent: true,
      enableVibration: true,
      styleInformation: BigTextStyleInformation(''),
      color: Colors.transparent,
    );
    DarwinNotificationDetails iosNotificationDetails =
    DarwinNotificationDetails(
      threadIdentifier: "thread1",
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iosNotificationDetails
    );

    return platformChannelSpecifics;
  }

  Future<void> showLocalNotification({  // call when app is in forground
    required int id,
    required String title,
    required String body,
    required String payload,
    required int seconds,
    required RemoteMessage remoteMessage,
  }) async {
    this.remoteMessage = remoteMessage;
    this.imageUrl = payload;
    final platformChannelSpecifics;
    if(imageUrl=="") {
      platformChannelSpecifics = await _notificationDetailsBackground();
    }else {
      platformChannelSpecifics = await _notificationDetailsImageShow();
    }

  }

}
