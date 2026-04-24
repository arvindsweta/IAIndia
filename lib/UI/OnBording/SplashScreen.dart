import 'dart:async';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:flutter/material.dart';
import 'package:myfirstdemo/Constants/Assets.dart';
import 'package:myfirstdemo/Services/ApiServices/SecureStorageService.dart';
import 'package:myfirstdemo/UI/Dashboard/DashboardScreen.dart';

import 'package:myfirstdemo/UI/LoginScreen/SignInView.dart';
import 'package:myfirstdemo/UI/SecurityDashboard/MenuDrawer/MainNavigationPage.dart';
import 'package:myfirstdemo/Widgets/CustomWidgets.dart';

import '../../Helper/AppHepler.dart';



class SplashScreen extends StatefulWidget {
  @override
  _SplashScreen createState() => new _SplashScreen();
}

class _SplashScreen extends State<SplashScreen>with SingleTickerProviderStateMixin  {
  final SecureStorageService _storageService = SecureStorageService();
  late AnimationController _controller;
  late Animation<double> _animation;


  Timer? _timer;

  @override
  void initState() {
    super.initState();
    AppHelper().checkForFcmToken();


    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();
    initPreference();
  }

  initPreference() async {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      timer.cancel();
      routeTopage();
    });
  }

  routeTopage() async {
    String? userId = await _storageService.getUserId();
    String? usertype = await _storageService.getIsLoginType();


    if (userId != null) {

      if (usertype == "Security") {
        Future.delayed(Duration(milliseconds: 2), () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MainNavigationPage()),
          );
        });
      }
      else {
        Future.delayed(Duration(milliseconds: 2), () {


          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DashboardScreen(

                )),
          );

        });
      }
    }
    else {
      Future.delayed(Duration(milliseconds: 2), () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialWithModalsPageRoute(builder: (context) => SignInView()),
                (Route<dynamic> route) => false);
      });
    }





  }


  @override
  Widget build(BuildContext context) {



    return Material(
      child: splashUi(),
    );
  }

  Widget splashUi() {
    return Container(
      color: Colors.blue,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Container(
          padding: EdgeInsets.all(50),
          width: 350,
          height: 350,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(175),
            border: Border.all(color: Colors.white),
          ),
          child:SizedBox(
              width: 150,
              height: 150,
              child: ScaleTransition(
                  scale: _animation, // Animated scale value
                  child: Container(

                    child: imageView(

                      assetName: Assets.iailogo,
                      fit: BoxFit.fill, // better for circular images
                    ),
                  ))
          )


        ),
      ),
    );
  }
}