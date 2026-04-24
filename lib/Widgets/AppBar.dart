
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfirstdemo/Services/ApiServices/SecureStorageService.dart';
import 'package:myfirstdemo/Services/ApiSession/NavigationContext.dart';
import 'package:myfirstdemo/Widgets/CustomWidgets.dart';
import 'package:myfirstdemo/Widgets/CustomWidgets.dart';

import '../Constants/Assets.dart';
import '../Services/ApiSession/Size.dart';


final SecureStorageService _storageService = SecureStorageService();
PreferredSizeWidget customBackAppBar({title, backgroundColor}) => PreferredSize(
      preferredSize: Size.fromHeight((screenHeight as double)*.90),
      child: Container(
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(24),
                bottomLeft: Radius.circular(24))),
        padding: const EdgeInsets.only(left: 10, top: 16.0, bottom: 8),
        child: AppBar(
          forceMaterialTransparency: true,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(NavigationContext.navigatorKey.currentContext!);
                },
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child: svgView(
                      assetName: Assets.pngPath, fit: BoxFit.cover),
                ),
              ),
              Container(
                width: screenWidth * 0.67,
                child: Text(
                  title.toString().toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      letterSpacing: -0.5,
                      fontFamily: 'OpenSans',
                      fontSize: 18.0,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      height: 20.05),
                ),
              ),

            ],
          ),
        ),
      ),
    );


PreferredSizeWidget customAppBar(
    {required String title,
      leadingOnTap,
      required BuildContext context,
      trailingAsset,
      trailingOnTap,
      isvisibal}) =>
    PreferredSize(
      preferredSize: Size.fromHeight(MediaQuery.of(context).size.height *.07),
      child: Container(
        color: Colors.blue,
        padding: EdgeInsets.only(top: 0),
        child: Stack(
          children: [
            Column(
              children: [
                AppBar(
                  forceMaterialTransparency: true,
                  automaticallyImplyLeading: false,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: leadingOnTap,
                            child: Padding(
                              padding: EdgeInsets.only(

                                left: 10,
                              ),
                              child: SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: svgView(
                                      assetName: Assets.hamburgerIcon,
                                      fit: BoxFit.contain)),
                            ),
                          ),


                        ],
                      ),

                    ],
                  ),
                ),
              ],
            ),
            Positioned(right: 10,top: 50,child: Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: InkWell(
                onTap: leadingOnTap,
                child: Padding(
                  padding: EdgeInsets.only(
                    right: 16.0,
                    left: 10,
                  ),
                  child: SizedBox(
                      height: 30,
                      width: 30,
                      child: svgView(
                          assetName: Assets.hamburgerIcon,
                          fit: BoxFit.contain)),
                ),
              ),
            ),)


          ],
        ),
        // color: cream,
      ),
    );

extension on Future<double?> {
  double? operator *(double other) {}
}

