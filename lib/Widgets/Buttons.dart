

import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:myfirstdemo/Widgets/CustomWidgets.dart';



import '../../Constants/Colors.dart';

Widget globalButton({
  double? btnwidth = 300,
  String? title,
  buttonColor,
  titleColor,
  borderColor,
  hasSuffix = false,
  svgAssetSuffix,
  Function()? onPressed,
}) =>
    ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          fixedSize: Size(btnwidth! != 0.0 ? btnwidth! : 70, 70),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius(
              cornerRadius: 16,
              cornerSmoothing: 1,
            ),
            side: BorderSide(
              color: borderColor ?? Colors.transparent,
              // Set border color to grey
              width: 1.5, // Set border width to 1 pixel
            ),
          ),
          backgroundColor: buttonColor,
          //
          shadowColor: Colors.black // Set button color to blue
          ),
      child: Center(
        child: hasSuffix
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: svgView(
                            assetName: svgAssetSuffix, fit: BoxFit.cover),
                      ),
                      Text(
                        title ?? "",
                        style: TextStyle(
                          letterSpacing: -0.5,
                          fontFamily: 'OpenSans',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          height: 23 / 18,

                          color: titleColor, // Set text color here
                        ),
                      ),
                      SizedBox(),
                    ],
                  ),
                  SizedBox(),
                ],
              )
            : Text(
                title ?? "",
                style: TextStyle(
                  letterSpacing: -0.5,
                  fontFamily: 'OpenSans',
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  height: 23 / 18,

                  color: titleColor, // Set text color here
                ),
              ),
      ),
    );

Widget globalButtonWithLoader({
  double? btnwidth = 300,
  String? title,
  buttonColor,
  titleColor,
  borderColor,
  hasSuffix = false,
  svgAssetSuffix,
  isLoading,
  Function()? onPressed,
}) =>
    ElevatedButton(
      onPressed: onPressed,

      style: ElevatedButton.styleFrom(
          fixedSize: Size(btnwidth! != 0.0 ? btnwidth! : 70, 70),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius(
              cornerRadius: 16,
              cornerSmoothing: 1,
            ),
            side: BorderSide(
              color: borderColor ?? Colors.transparent,
              // Set border color to grey
              width: 1.5, // Set border width to 1 pixel
            ),
          ),
          backgroundColor: buttonColor,
          //
          shadowColor: Colors.black // Set button color to blue
          ),
      child: Center(
        child: hasSuffix
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: svgView(
                            assetName: svgAssetSuffix, fit: BoxFit.cover),
                      ),
                      isLoading == true
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              title ?? "",
                              style: TextStyle(
                                letterSpacing: -0.5,
                                fontFamily: 'OpenSans',
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                height: 23 / 18,

                                color: titleColor, // Set text color here
                              ),
                            ),
                      SizedBox(),
                    ],
                  ),
                  SizedBox(),
                ],
              )
            : isLoading == true
                ? CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Text(
                    title ?? "",
                    style: TextStyle(
                      letterSpacing: -0.5,
                      fontFamily: 'OpenSans',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      height: 23 / 18,

                      color: titleColor, // Set text color here
                    ),
                  ),
      ),
    );

Widget globalResizeButton({
  double? btnwidth = 300,
  String? title,
  buttonColor,
  titleColor,
  borderColor,
  hasSuffix = false,
  svgAssetSuffix,
  Function()? onPressed,
}) =>
    ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          fixedSize: Size(btnwidth! != 0.0 ? btnwidth! : 50, 44),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius(
              cornerRadius: 12,
              cornerSmoothing: 1,
            ),
            side: BorderSide(
              color: borderColor ?? Colors.transparent,
              // Set border color to grey
              width: 1.5, // Set border width to 1 pixel
            ),
          ),
          backgroundColor: buttonColor,
          //
          shadowColor: Colors.black // Set button color to blue
          ),
      child: Center(
        child: hasSuffix
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: svgView(
                            assetName: svgAssetSuffix, fit: BoxFit.cover),
                      ),
                      Text(
                        title ?? "",
                        style: TextStyle(
                          letterSpacing: -0.4,
                          fontFamily: 'OpenSans',
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,

                          color: titleColor, // Set text color here
                        ),
                      ),
                      SizedBox(),
                    ],
                  ),
                ],
              )
            : Text(
                title ?? "",
                style: TextStyle(
                  letterSpacing: -0.5,
                  fontFamily: 'OpenSans',
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                  height: 23 / 18,

                  color: titleColor, // Set text color here
                ),
              ),
      ),
    );

Widget globalWithoutCornerButton({
  String? title,
  buttonColor,
  radius,
  titleColor,
  borderColor,
  hasSuffix = false,
  svgAssetSuffix,
  height=70.0,
  required width,
  Function()? onPressed,
}) =>
    ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          fixedSize: Size(width, height),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius(
              cornerRadius: radius,
              cornerSmoothing: 1,
            ),
            side: BorderSide(
              color: borderColor ?? Colors.transparent,
              // Set border color to grey
              width: 1.5, // Set border width to 1 pixel
            ),
          ),
          backgroundColor: buttonColor,
          //
          shadowColor: Colors.black // Set button color to blue
          ),
      child: Center(
        child: hasSuffix
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: svgView(
                            assetName: svgAssetSuffix, fit: BoxFit.cover),
                      ),
                      Text(
                        title ?? "",
                        style: TextStyle(
                          letterSpacing: -0.5,
                          fontFamily: 'OpenSans',
                          fontSize: 18.0,
                          fontWeight: FontWeight.w800,
                          height: 23 / 18,

                          color: titleColor, // Set text color here
                        ),
                      ),
                      SizedBox(),
                    ],
                  ),
                  SizedBox(),
                ],
              )
            : Text(
                title ?? "",
                style: TextStyle(
                  letterSpacing: -0.5,
                  fontFamily: 'OpenSans',
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  height: 23 / 18,

                  color: titleColor, // Set text color here
                ),
              ),
      ),
    );


