import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:myfirstdemo/Constants/NotificationCenter.dart';
import 'package:myfirstdemo/Model/LoginResponce.dart';
import 'package:myfirstdemo/Model/TripWrapper.dart';
import 'package:myfirstdemo/Services/ApiServices/GlobalLoader.dart';
import 'package:myfirstdemo/Services/ApiServices/SecureStorageService.dart';
import 'package:myfirstdemo/Utilities/Util.dart';

import '../../Constants/Assets.dart';
import '../../Model/MyTripListModel.dart';
import '../../Widgets/CustomWidgets.dart';
import 'DashboardController.dart';
import 'MyTripDetailPage.dart';
class MyTripView extends StatefulWidget {


  MyTripView({super.key});



  @override
  State<MyTripView> createState() => _MyTripViewState();
}

class _MyTripViewState extends State<MyTripView> {

  late final DashboardController dashboardController = Get.put(DashboardController());
  final SecureStorageService _storageService = SecureStorageService();


  List<TripListData> filterTripList = [];
  List<TripListData> myTripList = [];



  @override
  void initState() {
    getMyTripApi();

    super.initState();

  }

  @override
  void dispose() {

    super.dispose();
  }


  getMyTripApi() async {
    String? userId = await _storageService.getUserId();
    showLoader(context);
    try {
      MyTripListModel? dataModel = await dashboardController.getMyTripData(userId.toString());

      if (mounted) {
        dismissLoader(context);
        await Future.delayed(const Duration(milliseconds: 100));

        if (dataModel != null) {
          // If the server returns trips, it's a success
          if (dataModel.trips.isNotEmpty) {




            myTripList = dataModel.trips!.reversed.toList();

            // My Trip Request Filter 1st Tab





            setState(() {

            });

            print("Loaded ${dataModel.trips.length} trips successfully.");

            setState(() {
              // Assign dataModel.trips to a local list variable here
              // e.g., myTripList = dataModel.trips;
            });

            // Optional: If your API specifically sends "Valid" as a string
            if (dataModel.rawStatus == "Valid") {
              print("Status is Valid");
            }

          } else {
            print("No trips found or status: ${dataModel.rawStatus}");
            // CustomSnackBar().showSnackbar("Info", "No trip data available");
          }
        }
      }
    } catch (e) {
      print("Error in postTripApi: $e");
      if (mounted) dismissLoader(context);
    }
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
          "MyTrip",
          style: TextStyle(color: Color(0xFF1A1C4E), fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            latestNewsWidget()










          ],
        ),
      ),

      // Bottom Navigation Bar

    );
  }

  // Helper widget for Grid Cards


  Widget latestNewsWidget() {
    return Column(children: [


      Padding(
          padding: const EdgeInsets.only(left: 0, top: 0),
          child: SizedBox(
            height:
            MediaQuery.of(context).size.height * 0.85,
            child: myTripList!.isNotEmpty
                ? ListView.builder(
              scrollDirection: Axis.vertical, // Set horizontal scrolling
              itemCount: myTripList!.length,
              itemBuilder: (context, index) {
                var newsModel = myTripList![index];
                var ToDate = '-';
                var FromDate = '-';
                List<String> parts = newsModel.dateRange.split('to');
                if (parts.length >= 2) {
                  FromDate= parts[0].trim();
                  ToDate = parts[1].trim();

                }



                return GestureDetector(
                    onTap: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyTripDetailPage(tripDetailData: newsModel,

                            )),
                      );

                    },
                    child: Container(
                        width: MediaQuery.of(context).size.height * 0.47,

                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black12),
                          ),
                          child: Column(
                            children: [


                              _summaryRow('Booking ID', '${newsModel.bookingID}', isLink: true),
                              _summaryRow('From Date', FromDate.toString()),
                              _summaryRow('To Date', ToDate.toString()),

                              _summaryRow('Employee Name', '${newsModel.members[0].name} ${newsModel.members[0].FamilyName}'),
                              _summaryRow('From', '${newsModel.members[0].FromCity}'),
                              _summaryRow('To', '${newsModel.members[0].ToCity}'),
                              remarkShow( '${newsModel.members[0].Remarks}'),
                              statusRow('Status', '${newsModel.tripStatus}'),



                            ],
                          ),
                        )));
              },
            )
                : Container(),
          ))

    ]
    );
  }

  Widget remarkShow(String value){
    return Container(

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Keeps label at the top
        children: [
          const Text(
              "Remark: ",
              style: TextStyle(fontWeight: FontWeight.bold)
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight, // Forces text to the right
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight:  FontWeight.w500,
                  color:  Colors.black,

                ),// Optional: aligns the text block to the right
              ),
            ),
          ),
        ],
      ),
    );
  }
  //4techbugssmo@gmail.com
  Widget _summaryRow(String label, String value, {bool isLink = false, bool isBoldValue = false}) {
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
              fontWeight: (isBoldValue || isLink) ? FontWeight.bold : FontWeight.w500,
              color: isLink ? Colors.blue : Colors.black,
              decoration: isLink ? TextDecoration.underline : null,
            ),
          ),
        ],
      ),
    );
  }


  Widget _summaryActionRow(String label, String value ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight:  FontWeight.bold,
              color:  Colors.blue ,

            ),
          ),
          InkWell(
            onTap: () {

            },
            child: Padding(
              padding: EdgeInsets.only(
                top: 15,
                right: 16.0,
                left: 10,
              ),
              child: SizedBox(
                height: 30,
                width: 30,
                child: svgView(
                  assetName: Assets.PDFIcon,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          )

        ],
      ),
    );
  }


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



  getHotelDetailsSheet(
      {required BuildContext context , tripListData}) {
    var screenHeight = MediaQuery.of(context).size.height;
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
                    height: MediaQuery.of(context).size.height * .94,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0.0),
                        topRight: Radius.circular(0.0),
                      ),

                    ),


                  child: SizedBox(
                    height:
                    MediaQuery.of(context).size.height * 0.85,
                    child: tripListData!.members.isNotEmpty
                        ? ListView.builder(
                      scrollDirection: Axis.vertical, // Set horizontal scrolling
                      itemCount: tripListData!.members.length,
                      itemBuilder: (context, index) {
                        var newsModel = tripListData!.members[index];



                        return GestureDetector(
                            onTap: () {



                            },
                            child: Container(
                                width: MediaQuery.of(context).size.height * 0.47,

                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.black12),
                                  ),
                                  child: Column(
                                    children: [

                                      _summaryRow('Check In Date', '${getFormattedDDMMYYY(newsModel.HotelFromDate)}' ),
                                      _summaryRow('Check Out Date', ' ${getFormattedDDMMYYY(newsModel.HotelToDate)}' ),
                                      _summaryRow('Hotel', "${newsModel.hotel} - ${newsModel.ChainName}"),
                                      _summaryRow('Hotel City', "${newsModel.HotelCityName}"),
                                      _summaryRow('Confirmation No', '${newsModel.ConfirmationNo}'),





                                    ],
                                  ),
                                )));
                      },
                    )
                        : Container(),
                  ),


                ),
              ));
        });
      },
    );
  }


  getFlightDetailsSheet(
      {required BuildContext context , tripListData}) {
    var screenHeight = MediaQuery.of(context).size.height;
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
                  height: MediaQuery.of(context).size.height * .94,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0.0),
                      topRight: Radius.circular(0.0),
                    ),

                  ),

                  child: SizedBox(
                    height:
                    MediaQuery.of(context).size.height * 0.85,
                    child: tripListData!.members.isNotEmpty
                        ? ListView.builder(
                      scrollDirection: Axis.vertical, // Set horizontal scrolling
                      itemCount: tripListData!.members.length,
                      itemBuilder: (context, index) {
                        var newsModel = tripListData!.members[index];
                        return GestureDetector(
                            onTap: () {



                            },
                            child: Container(
                                width: MediaQuery.of(context).size.height * 0.47,

                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.black12),
                                  ),
                                  child: Column(
                                    children: [

                                      _summaryRow('Departure Date', '${getFormattedDDMMYYY(newsModel.DepartureDate)} (${newsModel.FlightTime})' ),
                                      _summaryRow('Airline Name', ' ${newsModel.AirlineName}' ),
                                      _summaryRow('FlightNO', "${newsModel.FlightNO}"),
                                      _summaryRow('Flight Class', "${newsModel.FlightClass}"),
                                      _summaryActionRow('Download Ticket', ""),






                                    ],
                                  ),
                                )));
                      },
                    )
                        : Container(),
                  ),


                ),
              ));
        });
      },
    );
  }


  getCabDetailsSheet(
      {required BuildContext context , tripListData}) {

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
                  height: MediaQuery.of(context).size.height * .94,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0.0),
                      topRight: Radius.circular(0.0),
                    ),

                  ),

                  child: SizedBox(
                    height:
                    MediaQuery.of(context).size.height * 0.85,
                    child: tripListData!.members.isNotEmpty
                        ? ListView.builder(
                      scrollDirection: Axis.vertical, // Set horizontal scrolling
                      itemCount: tripListData!.members.length,
                      itemBuilder: (context, index) {
                        var newsModel = tripListData!.members[index];
                        return GestureDetector(
                            onTap: () {



                            },
                            child: Container(
                                width: MediaQuery.of(context).size.height * 0.47,

                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.black12),
                                  ),
                                  child: Column(
                                    children: [

                                      _summaryRow('Provider name', '${newsModel.cab}' ),

                                      _summaryRow('Booking from', ' ${getFormattedDDMMYYY(newsModel.CabFromDate)}' ),







                                    ],
                                  ),
                                )));
                      },
                    )
                        : Container(),
                  ),


                ),
              ));
        });
      },
    );
  }

}