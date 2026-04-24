import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:myfirstdemo/Helper/AppHepler.dart';
import 'package:myfirstdemo/Services/ApiSession/NavigationContext.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:myfirstdemo/UI/OnBording/SplashScreen.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

}


Future<void> main() async {



  WidgetsFlutterBinding.ensureInitialized();



  tz.initializeTimeZones();

  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyBv1t4hxi3FDqm37nEqZa553DYENVjvasM",
          appId: "1:371039023388:android:1398e7e95b3b07f0c3cad9",
          messagingSenderId: "371039023388",
          projectId: "iai-india"),
    );
  } else {
    await Firebase.initializeApp(

    );
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const GetMaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}


/*Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();



  await Firebase.initializeApp();

  tz.initializeTimeZones();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);



  runApp(const MyApp());
}*/



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. Wrap with ScreenUtilInit properly
    return ScreenUtilInit(
      designSize: const Size(360, 690), // Standard mobile design size
      minTextAdapt: true,
      splitScreenMode: true,
      // 3. Use the builder to return your MaterialApp
      builder: (context, child) {
        return MaterialApp(
          navigatorKey: NavigationContext.navigatorKey,
          scaffoldMessengerKey: NavigationContext.scaffoldMessengerKey,
          title: 'Commer Connect',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          home: ForegroundFcmBannerHost(child: child ?? const SizedBox.shrink()),
        );
      },
      child:  SplashScreen(), // This is passed as 'child' to the builder
    );
  }
}

class ForegroundFcmBannerHost extends StatefulWidget {
  const ForegroundFcmBannerHost({super.key, required this.child});

  final Widget child;

  @override
  State<ForegroundFcmBannerHost> createState() => _ForegroundFcmBannerHostState();
}

class _ForegroundFcmBannerHostState extends State<ForegroundFcmBannerHost> {
  StreamSubscription<ForegroundNotificationEvent>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = AppHelper.foregroundNotificationStream.stream.listen(_showBanner);
  }

  /*void _showBanner(ForegroundNotificationEvent event) {
    final messenger = NavigationContext.scaffoldMessengerKey.currentState;
    if (messenger == null) {
      return;
    }

    messenger
      ..hideCurrentMaterialBanner()
      ..showMaterialBanner(
        MaterialBanner(
          elevation: 4,
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          content: GestureDetector(
            onTap: () {
              messenger.hideCurrentMaterialBanner();
               // ✅ Handle tap to navigate
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                if (event.body.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(event.body, style: const TextStyle(fontSize: 13)),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => messenger.hideCurrentMaterialBanner(),
              child: const Text('DISMISS'),
            ),
          ],
        ),
      );
  }*/

  void _showBanner(ForegroundNotificationEvent event) {
    final navigator = NavigationContext.navigatorKey.currentContext;
    if (navigator == null) return;

    showDialog(
      context: navigator,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            event.title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (event.imageUrl.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Image.network(
                    event.imageUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const SizedBox.shrink(),
                  ),
                ),
              if (event.body.isNotEmpty)
                Text(
                  event.body,
                  style: const TextStyle(fontSize: 14),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('DISMISS'),
            ),
          ],
        );
      },
    );

    // ✅ Auto-dismiss after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      try {
        Navigator.of(navigator).pop();
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

