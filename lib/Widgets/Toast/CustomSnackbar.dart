
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


class CustomSnackBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void showSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      // Additional customization options
      backgroundColor: Colors.black,
      // Set background color
      colorText: Colors.white,
      duration: Duration(seconds: 2),
      isDismissible: true,
      animationDuration: Duration(microseconds: 700),
      snackPosition: SnackPosition.BOTTOM, // Set text color
      /*icon: Icon(Icons.check, color: Colors.white), // Add an icon
       // Set position (default is bottom)
      margin: EdgeInsets.all(15), // Add margin around the snackbar
       // Allow user to dismiss the snackbar
      mainButton: TextButton(
        onPressed: () {
          // Handle button press
          print('Undo button pressed');
        },
        child: Text(
          'Undo',
          style: TextStyle(color: Colors.white),
        ),
      ),*/
    );
  }

  void showSnackBarForLong(String title, String message) {
    Get.snackbar(
      title,
      message,
      // Additional customization options
      backgroundColor: Colors.black,
      // Set background color
      colorText: Colors.white,
      duration: Duration(seconds: 6),
      isDismissible: true,
      animationDuration: Duration(microseconds: 900),
      snackPosition: SnackPosition.BOTTOM, // Set text color
      /*icon: Icon(Icons.check, color: Colors.white), // Add an icon
       // Set position (default is bottom)
      margin: EdgeInsets.all(15), // Add margin around the snackbar
       // Allow user to dismiss the snackbar
      mainButton: TextButton(
        onPressed: () {
          // Handle button press
          print('Undo button pressed');
        },
        child: Text(
          'Undo',
          style: TextStyle(color: Colors.white),
        ),
      ),*/
    );
  }
}

loadingDialog(){
 return Scaffold(
      body: Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
      color: Colors.white,
      size: 200,
  ),
  ));
}