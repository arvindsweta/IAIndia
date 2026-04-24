import 'dart:io';

import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


Widget svgView({assetName, fit, colorFilter, semanticsLabel, color}) =>
    SvgPicture.asset(
      assetName,
      colorFilter: colorFilter,
      color: color,
      semanticsLabel: semanticsLabel,
      fit: fit,
    );

Widget imageViewColor({
  assetName,
  fit,
  height,
  color,
  width,
}) =>
    Image.asset(
      assetName,
      fit: fit,
      color: color,
    );

Widget imageView({
  assetName,
  fit,
  height,
  width,
}) =>
    Image.asset(
      assetName,
      fit: fit,
    );



Widget titleWidget({title, subtitle}) => Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 3.0),
          child: Text(
            title,
            style: const TextStyle(
              letterSpacing: -0.5,
              fontFamily: 'OpenSans',
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ),
        Text(
          subtitle,
          maxLines: 2,
          style: const TextStyle(
            letterSpacing: -0.5,
            fontFamily: 'OpenSans',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    ));



Widget monthDateWidget({month, date}) => Container(
      width: 60,
      height: 60,
      decoration: ShapeDecoration(
        // color: Colors.white60,
        shape: SmoothRectangleBorder(
          borderRadius: SmoothBorderRadius.all(SmoothRadius(
            cornerRadius: 16,
            cornerSmoothing: 0.5,
          )),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(month,
              style: TextStyle(
                  letterSpacing: -0.5,
                  fontFamily: 'OpenSans',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.14,
                  color: Colors.black)),
          Text(date,
              style: TextStyle(
                  letterSpacing: -0.5,
                  fontFamily: 'OpenSans',
                  fontSize: 26,
                  fontWeight: FontWeight.w300,
                  height: 1.14,
                  color: Colors.black)),
        ],
      ),
    );



