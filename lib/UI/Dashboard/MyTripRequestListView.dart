import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:myfirstdemo/Model/TripWrapper.dart';
import 'package:myfirstdemo/Services/ApiServices/GlobalLoader.dart';
import 'package:myfirstdemo/Services/ApiServices/SecureStorageService.dart';
import '../../Model/LoginResponce.dart';
import '../LoginScreen/LoginController.dart';
import 'DashboardController.dart';
import 'TripDetailView.dart';


class MyTripRequestListView extends StatefulWidget {


  MyTripRequestListView({super.key});



  @override
  State<MyTripRequestListView> createState() => _MyTripRequestListViewState();
}

class _MyTripRequestListViewState extends State<MyTripRequestListView> {

  late final DashboardController dashboardController = Get.put(DashboardController());
  final SecureStorageService _storageService = SecureStorageService();
  late final LoginController postUserController = Get.put(LoginController());
  List<TripData> filterTripList = [];
  List<TripData> allTripList = [];
  String? totalTripApproved = "";
  String? totalTripRequest = "";
  String? totalCompleteTrip = "";
  late StreamSubscription _sub;
  List<TripData> myTripList = [];
  List<TripData> myTripRequestList = [];
  List<TripData> myTripToAprovedList = [];
  bool _isLoggingOut = false;

  String? username = "";
  String? selectTabText = "My Trip Request";



  @override
  void initState() {
    postTripApi();

    super.initState();

  }

  @override
  void dispose() {

    super.dispose();
  }

  deleteExpenceApi(tripId,int index) async {
    showLoader(context);
    try {
      String? userId = await _storageService.getUserId();
      // Assuming this returns an instance of VerifyOtpResponse
      LoginResponce? expenceModel = await dashboardController.deleteMyTripApi(tripId.toString()

      );

      if (mounted) {
        dismissLoader(context);
        // Small delay to ensure loader is gone before UI updates or navigation
        await Future.delayed(Duration(milliseconds: 100));

        if (expenceModel != null ) {

          filterTripList.removeAt(index);
setState(() {

});

        }
        else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Invalid")),
          );
        }

      }
    } catch (e) {
      print("Error in postVerifyUserApi: $e");
      if (mounted) {
        dismissLoader(context);
      }
    }
  }





  postTripApi() async {
    showLoader(context);
    try {
      TripWrapper? dataModel = await dashboardController.postTripData();

      if (mounted) {
        dismissLoader(context);
        await Future.delayed(const Duration(milliseconds: 100));

        if (dataModel != null) {
          // If the server returns trips, it's a success
          if (dataModel.trips.isNotEmpty) {
            String? userId = await _storageService.getUserId();
            username = await _storageService.getUsername();

            print( "===========>"+ userId.toString());



            allTripList = dataModel.trips!;

            // My Trip Request Filter 1st Tab



            myTripRequestList = allTripList.where((trip) {
              // Requirement 1: TripStatus must be "Completed"
              bool isCompleted = trip.tripStatus != "Completed";

              // Requirement 2: At least one member must report to the current user
              bool matchesManager = trip.members.any((member) => member.MemberID == userId.toString());

              return isCompleted && matchesManager;
            }).toList();


            filterTripList = myTripRequestList.reversed.toList();


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
          "My Trip Request",
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

  Widget latestNewsWidget() {
    return Column(children: [


      Padding(
          padding: const EdgeInsets.only(left: 0, top: 0),
          child: SizedBox(
            height:
            MediaQuery.of(context).size.height * 0.87,
            child: filterTripList!.isNotEmpty
                ? ListView.builder(
              scrollDirection: Axis.vertical, // Set horizontal scrolling
              itemCount: filterTripList!.length,
              itemBuilder: (context, index) {
                var newsModel = filterTripList![index];
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
                            builder: (context) => TripDetailView(tripData: newsModel,

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
                              remarkShow( '${newsModel.members[0].Remarks}'),

                              statusRow('Status', '${newsModel.tripStatus}'),
                              Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                color: Colors.transparent,
                                child: Align(
                                    alignment: Alignment.center,
                                    child: ElevatedButton(
                                      onPressed: () {

                                        deleteExpenceApi(newsModel.id.toString(),index);

                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.redAccent,
                                        fixedSize: const Size(120, 45),
                                        // Adding the corner radius here
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: const Text('Delete', style: TextStyle(color: Colors.white)),
                                    )
                                ),


                              ),
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
  }}