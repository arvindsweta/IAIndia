import 'dart:async';

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:myfirstdemo/Services/ApiServices/GlobalLoader.dart';
import 'package:myfirstdemo/Services/ApiServices/SecureStorageService.dart';
import 'package:myfirstdemo/UI/Dashboard/Expence/ExpenceChatScreen.dart';
import 'package:myfirstdemo/Utilities/Util.dart';

import '../../Constants/Assets.dart';
import '../../Model/HotelCabFlightModel.dart';
import '../../Model/MyTripListModel.dart';
import '../../Widgets/CustomWidgets.dart';
import 'Expence/AddExpenseView.dart';
import 'DashboardController.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class MyTripDetailPage extends StatefulWidget {

  var tripDetailData;
  MyTripDetailPage({super.key ,required this.tripDetailData});



  @override
  State<MyTripDetailPage> createState() => _MyTripDetailPageState();
}

class _MyTripDetailPageState extends State<MyTripDetailPage> {

  late final DashboardController dashboardController = Get.put(DashboardController());
  final SecureStorageService _storageService = SecureStorageService();



  List<TripListData> detailsTripList = [];
  List<TripDetail> cabHotelflightTripList = [];
  var ToDate = '-';
  var FromDate = '-';


  @override
  void initState() {
    List<String> parts = widget.tripDetailData.dateRange.split('to');
    if (parts.length >= 2) {
      FromDate= parts[0].trim();
      ToDate = parts[1].trim();



    }

    getMyTripDetailsApi(widget.tripDetailData.id.toString());

    super.initState();

  }

  @override
  void dispose() {

    super.dispose();
  }




  getMyTripDetailsApi( String tripId,) async {
    String? userId = await _storageService.getUserId();

    try {
      MyTripListModel? dataModel = await dashboardController.getMyTripDetailData(userId.toString(),tripId);

      if (mounted) {

        await Future.delayed(const Duration(milliseconds: 100));

        if (dataModel != null) {
          // If the server returns trips, it's a success
          if (dataModel.trips.isNotEmpty) {




            detailsTripList = dataModel.trips!;

            print("total count"+ detailsTripList![0].members.length.toString());



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


  getAllHotelCabDetailApi( String tripId, String bitType,) async {
    String? userId = await _storageService.getUserId();

    try {
      TripResponse? dataModel = await dashboardController.getHotelCabFlightData(userId.toString(),tripId,bitType);

      if (mounted) {

        await Future.delayed(const Duration(milliseconds: 100));

        if (dataModel != null) {
          // If the server returns trips, it's a success
          if (dataModel.data.isNotEmpty) {




            cabHotelflightTripList = dataModel.data!;

            print("total count"+ cabHotelflightTripList!.length.toString());


            if(bitType == "H")
              {
                getHotelDetailsSheet(
                    context: context,
                    tripListData: widget.tripDetailData);
              }
            else if(bitType == "F")
            {
              getFlightDetailsSheet(
                  context: context,
                  tripListData: widget.tripDetailData);
            }
            else if(bitType == "C")
            {
              getCabDetailsSheet(
                  context: context,
                  tripListData: widget.tripDetailData);
            }



            setState(() {

            });



            setState(() {
              // Assign dataModel.trips to a local list variable here
              // e.g., myTripList = dataModel.trips;
            });

            // Optional: If your API specifically sends "Valid" as a string


          } else {

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

            GestureDetector(
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


                    _summaryRow('Booking ID', '${widget.tripDetailData.bookingID}', isLink: true),
                    _summaryRow('From Date', FromDate.toString()),
                    _summaryRow('To Date', ToDate.toString()),
                    _summaryRow('Employee Name', '${widget.tripDetailData.members[0].name} ${widget.tripDetailData.members[0].FamilyName}'),
                    _summaryRow('From', '${widget.tripDetailData.members[0].FromCity}'),
                    _summaryRow('To', '${widget.tripDetailData.members[0].ToCity}'),
                    remarkShow( "Remarks",'${widget.tripDetailData.members[0].Remarks}'),
                    statusRow('Status', '${widget.tripDetailData.tripStatus}'),

                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {


                            getAllHotelCabDetailApi(widget.tripDetailData.id.toString(), "F");



                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            fixedSize: const Size(90,30),
                            // Adding the corner radius here
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Flight', style: TextStyle(color: Colors.white)),
                        ),

                        ElevatedButton(
                          onPressed: () {
                            getAllHotelCabDetailApi(widget.tripDetailData.id.toString(), "H");





                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            fixedSize: const Size(90, 30),
                            // Adding the corner radius here
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Hotel', style: TextStyle(color: Colors.white)),
                        ),

                        ElevatedButton(
                          onPressed: () {

                            getAllHotelCabDetailApi(widget.tripDetailData.id.toString(), "C");






                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            fixedSize: const Size(120, 30),
                            // Adding the corner radius here
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Transport', style: TextStyle(color: Colors.white)),
                        )
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {



                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddExpenseView(

                                tripId:widget.tripDetailData.id.toString() ,tripDate: widget.tripDetailData.dateRange.toString(),

                              )),
                        );


                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        fixedSize: const Size(300,30),
                        // Adding the corner radius here
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Add Expense', style: TextStyle(color: Colors.white)),
                    ),


                  ],
                ),
              )))










          ],
        ),
      ),

      // Bottom Navigation Bar

    );
  }


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

              downloadFile(value);

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
                    child: cabHotelflightTripList.isNotEmpty
                        ? ListView.builder(
                      scrollDirection: Axis.vertical, // Set horizontal scrolling
                      itemCount: cabHotelflightTripList.length,
                      itemBuilder: (context, index) {
                        var newsModel = cabHotelflightTripList[index];



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

                                      _summaryRow('Check In Date', '${getFormattedDDMMYYY(newsModel.fromDateTime)}' ),
                                      _summaryRow('Check Out Date', ' ${getFormattedDDMMYYY(newsModel.toDateTime)}' ),

                                      remarkShow("Hotel", '${newsModel.detailName}'),
                                      _summaryRow('Hotel City', "${newsModel.hotelCityName}"),
                                      _summaryRow('Confirmation No', '${newsModel.confirmationNo}'),





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
                    child: cabHotelflightTripList.isNotEmpty
                        ? ListView.builder(
                      scrollDirection: Axis.vertical, // Set horizontal scrolling
                     itemCount: cabHotelflightTripList.length,
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
                                      _summaryRow('From', '${newsModel.FromCity}'),
                                      _summaryRow('To', '${newsModel.ToCity}'),

                                      _summaryRow('Airline Name', ' ${newsModel.AirlineName}' ),
                                      _summaryRow('FlightNO', "${newsModel.FlightNO}"),
                                      _summaryRow('Flight Class', "${newsModel.FlightClass}"),

                                      _summaryActionRow('Download Ticket', "${newsModel.TicketImage}"),






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
                      itemCount: cabHotelflightTripList.length,
                      itemBuilder: (context, index) {
                        var newsModel = cabHotelflightTripList[index];
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

                                      _summaryRow('Provider name', '${newsModel.cabType}' ),
                                      _summaryRow('Pickup', '${newsModel.pickLocation}' ),
                                      _summaryRow('Drop', '${newsModel.dropLocation}' ),
                                      _summaryRow('Model', '${newsModel.cabType}' ),
                                      _summaryRow('Pickup Time', '${newsModel.pickupTime}' ),
                                      _summaryRow('Drop Time', '${newsModel.dropTime}' ),

                                      _summaryRow('Booking date', ' ${getFormattedDDMMYYY(newsModel.cabFromDate)}' ),






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
  Widget remarkShow(String title,String value){
    return Container(

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Keeps label at the top
        children: [
           Text(
              title.toString(),
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
  Future<void> downloadFile(String url) async {
    try {
      // 1. Get the directory
      final dir = await getApplicationDocumentsDirectory();

      // 2. Extract the filename from the URL (e.g., "document.pdf")
      String fileName = p.basename(url);

      // 3. Create the full path including the filename
      final savePath = p.join(dir.path, fileName);

      final dio = Dio();

      // 4. Download to the specific file path
      await dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            double progress = (received / total) * 100;
            print("${progress.toStringAsFixed(0)}%");
          }
        },
      );

      print("File saved at: $savePath");

      // 5. Open the file
      OpenFile.open(savePath);

    } catch (e) {
      print("Download failed: $e");
    }
  }

}