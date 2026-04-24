import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:myfirstdemo/Constants/NotificationCenter.dart';
import 'package:myfirstdemo/Model/LoginResponce.dart';
import 'package:myfirstdemo/Model/TripWrapper.dart';
import 'package:myfirstdemo/Services/ApiServices/GlobalLoader.dart';
import 'package:myfirstdemo/Services/ApiServices/SecureStorageService.dart';

import 'package:myfirstdemo/UI/Dashboard/NewTripRequestScreen.dart';
import 'DashboardController.dart';
class TripDetailView extends StatefulWidget {

  var tripData;
  TripDetailView({super.key,required this.tripData});



  @override
  State<TripDetailView> createState() => _TripDetailViewState();
}

class _TripDetailViewState extends State<TripDetailView> {

  late final DashboardController dashboardController = Get.put(DashboardController());
  var ToDate = '-';
  var FromDate = '-';

  @override
  void initState() {
    List<String> parts = widget.tripData.dateRange.split('to');
    if (parts.length >= 2) {
      FromDate = parts[0].trim();
      ToDate = parts[1].trim();
    }
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Custom Colors based on your mockup
    const Color bgPurple = Color(0xFFF3F2F8);


    return Scaffold(
      backgroundColor: bgPurple,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "My Trip Request Details",
          style: TextStyle(color: Color(0xFF1A1C4E), fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: Container(

        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: Container(

          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.transparent)),

          child: Column(

            mainAxisSize: MainAxisSize.min,
            children: [
            _summaryRow('Booking ID', '${widget.tripData.bookingID}', isLink: true),
            _summaryRow('From Date', FromDate.toString()),
            _summaryRow('To Date', ToDate.toString()),
            _summaryRow('Employee Name', '${widget.tripData.members[0].name} ${widget.tripData.members[0].FamilyName}'),

            _summaryRow('From', '${widget.tripData.members[0].FromCity}'),
              _summaryRow('To', '${widget.tripData.members[0].ToCity}'),
              _summaryRow('Remark', '${widget.tripData.members[0].Remarks}'),
              statusRow('Status', '${widget.tripData.tripStatus}'),

          ],),



        ),
      )
      // Bottom Navigation Bar

    );
  }

  // Helper widget for Grid Cards



  Widget statusRow(String label, String value, ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight:  FontWeight.bold ,
              color: value.toString().toUpperCase() == "OPEN"?Colors.orange:value.toString().toUpperCase() == "REJECTED"?
              Colors.redAccent:value.toString().toUpperCase() == "APPROVED"?Colors.green:Colors.black,

            ),
          ),
        ],
      ),
    );
  }
  //4techbugssmo@gmail.com
  Widget _summaryRow(String label, String value, {bool isLink = false, bool isBoldValue = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: (isBoldValue || isLink) ? FontWeight.bold : FontWeight.w500,
              color: isLink ? Colors.blue : Colors.black,
              decoration: isLink ? TextDecoration.underline : null,
            ),
          ),
        ],
      ),
    );
  }
}