import 'dart:ui';


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../Constants/Colors.dart';

// ********Common function *****************//



showLoader(BuildContext context) {
  Future.delayed(Duration.zero, () {
    showDialog(
        barrierDismissible: false,
        useRootNavigator: false,
        barrierColor: Colors.black.withOpacity(0.55),
        context: context,
        builder: (_) =>
          Material(
          type: MaterialType.transparency,
          child:
            WillPopScope(
              onWillPop: () async => false,
              child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
              child:Container(
                alignment: Alignment.center,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.deepPurple,
                  ),
                  /*LoadingAnimationWidget.stretchedDots(
                      size: 30, color: app_color),*/

                ),
              )
            )
                  ,
            )));
  });
}

dismissLoader(BuildContext context) {
  Future.delayed(Duration.zero, () {
    Navigator.pop(context);
  });
}

dismissLoaderUpdated() {
  Future.delayed(Duration.zero, () {
    Get.back();
  });
}

void showLoaderUpdated() {
  Future.delayed(Duration.zero, () {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: /*BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 20),
            child: Center(
              child: LoadingAnimationWidget.stretchedDots(
                size: 30,
                color:
                    active_indicater, // Replace sunYellow with Colors.yellow or your specific color
              ),
            ),
          ),
        ),*/
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 20),
          child: Center(
            child: LoadingAnimationWidget.stretchedDots(
              size: 30,
              color: active_indicater, // Replace sunYellow with Colors.yellow or your specific color
            ),
          ),
        ),
      ),
      barrierDismissible: false,
      useSafeArea: false,
      barrierColor: Colors.black.withOpacity(
          0.5), // Replace footerBackground with Colors.black or your specific color
    );
  });
}
