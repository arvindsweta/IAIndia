
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:myfirstdemo/Widgets/CustomWidgets.dart';

import '../../Constants/Assets.dart';
import '../../Constants/Colors.dart';


Widget sheetPrimaryWidget({assetName, title, subTitle, secondaryWidget,required BuildContext context }) {
var screenHeight = MediaQuery.of(context).size.height;
var screenWidth = MediaQuery.of(context).size.width;
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 18.0),
        child: Container(
          height: 12,
          width: 12,
          decoration: const BoxDecoration(
              color: darkNavy, borderRadius: BorderRadius.all(Radius.circular(20))),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          height: screenWidth * .18,
          width: screenWidth * .18,
          child: svgView(
            assetName: assetName,
            fit: BoxFit.cover,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 16),
        child: Text(title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              letterSpacing: -0.5,
              fontFamily: 'OpenSans',
              fontSize: 24,
              fontWeight: FontWeight.w600,
              height: 1.25,
              // This corresponds to line height of 30px for fontSize 24px
            )),
      ),
      Text(
        subTitle,
        textAlign: TextAlign.center,
        style: const TextStyle(
          letterSpacing: -0.5,
          fontFamily: 'OpenSans',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.0,
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(15, 46, 15, 16),
        child: secondaryWidget,
      )
    ],
  );
}






void showListBootomWidget(
    {required BuildContext context,
    required double heightRatio,
    required double widthRatio,
    required Widget child}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    builder: (BuildContext context) {
      return Container(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * heightRatio,
        child: Stack(
          children: [
            Container(
              width: double.maxFinite,
              height: double.maxFinite,
            ),
            Container(alignment: Alignment.topCenter, child: child)
          ],
        ),
      );
    },
  );
}

Widget listTypeWidget({assetName, secondaryWidget}) {
  return SingleChildScrollView(
    child: Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          height: 12,
          width: 12,
          decoration: const BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.all(Radius.circular(20))),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 46, 15, 16),
          child: secondaryWidget,
        )
      ],
    ),
  );
}

getSimpleBottomSheet(
    {required BuildContext context, heightRatio, widthRatio, child}) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    isDismissible: true, // Allow for full-height expansion

    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(left: 0.0),
        child: Container(
            height: heightRatio,
            width: widthRatio,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0.0, -2.0),
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: child),
      );
    },
  );
}

getBottomSheet(
    {required BuildContext context, heightRatio, widthRatio, child}) {
  var screenHeight = MediaQuery.of(context).size.height;
  var screenWidth = MediaQuery.of(context).size.width;

  showCupertinoModalBottomSheet(
    topRadius: Radius.circular(24),
    //expand: true,
    context: context,
    duration: Duration(milliseconds: 700),
    backgroundColor: Colors.white,

    isDismissible: true, // Allow for full-height expansion

    builder: (BuildContext context) {
      return StatefulBuilder(builder: (BuildContext context,
          StateSetter setState /*You can rename this!*/) {
        return Material(
            type: MaterialType.transparency,
            child: Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: Container(
                  height: screenHeight * .94,
                  width: widthRatio,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0.0),
                      topRight: Radius.circular(0.0),
                    ),
                    /* boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0.0, -2.0),
                  blurRadius: 6.0,
                ),
              ],*/
                  ),
                  child: child),
            ));
      });
    },
  );
}

getTransparenBottomSheet(
    {required BuildContext context, heightRatio, widthRatio, child}) {
  var screenHeight = MediaQuery.of(context).size.height;
  showCupertinoModalBottomSheet(
    topRadius: Radius.circular(24),
    //expand: true,
    context: context,
    duration: Duration(milliseconds: 700),
    backgroundColor: Colors.transparent,

    isDismissible: true, // Allow for full-height expansion

    builder: (BuildContext context) {
      return StatefulBuilder(builder: (BuildContext context,
          StateSetter setState /*You can rename this!*/) {
        return Material(
            type: MaterialType.transparency,
            child: Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: Container(
                  height: screenHeight * .94,
                  width: widthRatio,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0.0),
                      topRight: Radius.circular(0.0),
                    ),
                    /* boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0.0, -2.0),
                  blurRadius: 6.0,
                ),
              ],*/
                  ),
                  child: child),
            ));
      });
    },
  );
}

